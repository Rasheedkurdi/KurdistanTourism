<?php
require_once __DIR__ . '/bootstrap.php';

class UserAuth {
    private $db;
    
    public function __construct() {
        $this->db = Database::getInstance();
    }
    
    public function register($data) {
        $errors = [];
        
        // Validate input
        if (empty($data['username'])) {
            $errors[] = 'Username is required';
        } elseif (!preg_match('/^[a-zA-Z0-9_]{3,20}$/', $data['username'])) {
            $errors[] = 'Username must be 3-20 characters and contain only letters, numbers, and underscores';
        }
        
        if (empty($data['email'])) {
            $errors[] = 'Email is required';
        } elseif (!filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $errors[] = 'Invalid email format';
        }
        
        if (empty($data['password'])) {
            $errors[] = 'Password is required';
        } elseif (strlen($data['password']) < 8) {
            $errors[] = 'Password must be at least 8 characters';
        }
        
        if (empty($data['full_name'])) {
            $errors[] = 'Full name is required';
        }
        
        if (!empty($errors)) {
            return ['success' => false, 'errors' => $errors];
        }
        
        // Check if username or email already exists
        $existing = $this->db->fetch(
            "SELECT id FROM users WHERE username = ? OR email = ?",
            [$data['username'], $data['email']]
        );
        
        if ($existing) {
            return ['success' => false, 'errors' => ['Username or email already exists']];
        }
        
        // Create user
        $passwordHash = password_hash($data['password'], PASSWORD_DEFAULT);
        $verificationToken = bin2hex(random_bytes(32));
        
        $userData = [
            'username' => $data['username'],
            'email' => $data['email'],
            'password_hash' => $passwordHash,
            'full_name' => $data['full_name'],
            'phone' => $data['phone'] ?? '',
            'language' => $data['language'] ?? 'ku',
            'verification_token' => $verificationToken,
            'is_verified' => 0
        ];
        
        $userId = $this->db->insert('users', $userData);
        
        if (!$userId) {
            return ['success' => false, 'errors' => ['Registration failed']];
        }
        
        // Log activity
        $this->logActivity($userId, 'login', null, '', $_SERVER['REMOTE_ADDR'], $_SERVER['HTTP_USER_AGENT']);
        
        // Send verification email (if enabled)
        $requireVerification = $this->db->fetch("SELECT setting_value FROM settings WHERE setting_key = 'require_email_verification'");
        if ($requireVerification && $requireVerification['setting_value'] == '1') {
            $this->sendVerificationEmail($data['email'], $verificationToken);
        }
        
        return [
            'success' => true,
            'user_id' => $userId,
            'message' => 'Registration successful'
        ];
    }
    
    public function login($username, $password) {
        $errors = [];
        
        if (empty($username) || empty($password)) {
            return ['success' => false, 'errors' => ['Username and password are required']];
        }
        
        // Find user
        $user = $this->db->fetch(
            "SELECT * FROM users WHERE (username = ? OR email = ?) AND status = 'active'",
            [$username, $username]
        );
        
        if (!$user || !password_verify($password, $user['password_hash'])) {
            return ['success' => false, 'errors' => ['Invalid username or password']];
        }
        
        // Update login info
        $this->db->update('users', 
            [
                'last_login' => date('Y-m-d H:i:s'),
                'login_count' => $user['login_count'] + 1
            ],
            'id = ?',
            [$user['id']]
        );
        
        // Log activity
        $this->logActivity($user['id'], 'login', null, '', $_SERVER['REMOTE_ADDR'], $_SERVER['HTTP_USER_AGENT']);
        
        // Create session
        session_regenerate_id(true);
        $_SESSION['user_logged_in'] = true;
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user_name'] = $user['full_name'];
        $_SESSION['user_email'] = $user['email'];
        $_SESSION['user_role'] = 'user';
        
        return [
            'success' => true,
            'user' => $this->sanitizeUser($user)
        ];
    }
    
    public function logout() {
        if (isset($_SESSION['user_id'])) {
            $this->logActivity($_SESSION['user_id'], 'logout', null, '', $_SERVER['REMOTE_ADDR'], $_SERVER['HTTP_USER_AGENT']);
        }

        // Clear user-related session variables instead of destroying entire session
        unset($_SESSION['user_logged_in'], $_SESSION['user_id'], $_SESSION['user_name'], $_SESSION['user_email'], $_SESSION['user_role']);
        return ['success' => true];
    }
    
    public function getCurrentUser() {
        if (!isset($_SESSION['user_id'])) {
            return null;
        }
        
        $user = $this->db->fetch(
            "SELECT * FROM users WHERE id = ? AND status = 'active'",
            [$_SESSION['user_id']]
        );
        
        return $user ? $this->sanitizeUser($user) : null;
    }
    
    public function requireLogin() {
        $user = $this->getCurrentUser();
        if (!$user) {
            header('Location: login.php');
            exit;
        }
        return $user;
    }
    
    public function updateProfile($userId, $data) {
        $errors = [];
        
        // Validate input
        if (isset($data['email']) && !filter_var($data['email'], FILTER_VALIDATE_EMAIL)) {
            $errors[] = 'Invalid email format';
        }
        
        if (isset($data['phone']) && !empty($data['phone']) && !preg_match('/^[+]?[0-9]{10,15}$/', $data['phone'])) {
            $errors[] = 'Invalid phone number format';
        }
        
        if (!empty($errors)) {
            return ['success' => false, 'errors' => $errors];
        }
        
        // Check if email is being changed and if it's already taken
        if (isset($data['email'])) {
            $existing = $this->db->fetch(
                "SELECT id FROM users WHERE email = ? AND id != ?",
                [$data['email'], $userId]
            );
            
            if ($existing) {
                return ['success' => false, 'errors' => ['Email already exists']];
            }
        }
        
        // Update user
        $allowedFields = ['full_name', 'email', 'phone', 'bio', 'language'];
        $updateData = [];
        
        foreach ($allowedFields as $field) {
            if (isset($data[$field])) {
                $updateData[$field] = $data[$field];
            }
        }
        
        if (empty($updateData)) {
            return ['success' => false, 'errors' => ['No valid fields to update']];
        }
        
        $success = $this->db->update('users', $updateData, 'id = ?', [$userId]);
        
        if ($success) {
            return ['success' => true, 'message' => 'Profile updated successfully'];
        } else {
            return ['success' => false, 'errors' => ['Update failed']];
        }
    }
    
    public function changePassword($userId, $currentPassword, $newPassword) {
        $errors = [];
        
        if (empty($currentPassword) || empty($newPassword)) {
            $errors[] = 'Current and new passwords are required';
        }
        
        if (strlen($newPassword) < 8) {
            $errors[] = 'New password must be at least 8 characters';
        }
        
        if (!empty($errors)) {
            return ['success' => false, 'errors' => $errors];
        }
        
        // Verify current password
        $user = $this->db->fetch("SELECT password_hash FROM users WHERE id = ?", [$userId]);
        
        if (!$user || !password_verify($currentPassword, $user['password_hash'])) {
            return ['success' => false, 'errors' => ['Current password is incorrect']];
        }
        
        // Update password
        $newPasswordHash = password_hash($newPassword, PASSWORD_DEFAULT);
        $success = $this->db->update('users', 
            ['password_hash' => $newPasswordHash], 
            'id = ?', 
            [$userId]
        );
        
        if ($success) {
            return ['success' => true, 'message' => 'Password changed successfully'];
        } else {
            return ['success' => false, 'errors' => ['Password change failed']];
        }
    }
    
    public function uploadAvatar($userId, $file) {
        $errors = [];
        
        if (!isset($file['tmp_name']) || !is_uploaded_file($file['tmp_name'])) {
            return ['success' => false, 'errors' => ['No file uploaded']];
        }

        $maxSize = 5 * 1024 * 1024; // 5MB
        $extension = uploaded_image_extension($file, $maxSize);
        if ($extension === null) {
            return ['success' => false, 'errors' => ['Invalid image. Only JPG, PNG, GIF, and WebP files up to 5MB are allowed']];
        }

        $filename = secure_random_filename('avatar_' . $userId . '_', $extension);
        $relativePath = 'uploads/avatars/' . $filename;
        $absolutePath = dirname(__DIR__) . '/' . $relativePath;
        
        // Create directory if it doesn't exist
        $uploadDir = dirname(__DIR__) . '/uploads/avatars';
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }
        
        // Move file
        if (!move_uploaded_file($file['tmp_name'], $absolutePath)) {
            $errorMsg = error_get_last();
            return ['success' => false, 'errors' => ['Failed to upload file. ' . ($errorMsg ? $errorMsg['message'] : '')]];
        }
        
        // Update user avatar
        $success = $this->db->update('users', 
            ['avatar' => $relativePath], 
            'id = ?', 
            [$userId]
        );
        
        if ($success) {
            return ['success' => true, 'avatar_url' => $relativePath];
        } else {
            unlink($absolutePath); // Remove uploaded file if update failed
            return ['success' => false, 'errors' => ['Failed to update avatar']];
        }
    }
    
    public function forgotPassword($email) {
        $user = $this->db->fetch("SELECT * FROM users WHERE email = ? AND status = 'active'", [$email]);
        
        if (!$user) {
            return ['success' => false, 'errors' => ['Email not found']];
        }
        
        $resetToken = bin2hex(random_bytes(32));
        $resetExpires = date('Y-m-d H:i:s', strtotime('+1 hour'));
        
        $this->db->update('users', 
            [
                'reset_token' => $resetToken,
                'reset_expires' => $resetExpires
            ], 
            'id = ?', 
            [$user['id']]
        );
        
        // Send reset email (implement email sending)
        $this->sendPasswordResetEmail($email, $resetToken);
        
        return ['success' => true, 'message' => 'Password reset link sent to your email'];
    }
    
    public function resetPassword($token, $newPassword) {
        $errors = [];
        
        if (empty($token) || empty($newPassword)) {
            return ['success' => false, 'errors' => ['Token and new password are required']];
        }
        
        if (strlen($newPassword) < 6) {
            return ['success' => false, 'errors' => ['Password must be at least 6 characters']];
        }
        
        $user = $this->db->fetch(
            "SELECT id FROM users WHERE reset_token = ? AND reset_expires > ? AND status = 'active'",
            [$token, date('Y-m-d H:i:s')]
        );
        
        if (!$user) {
            return ['success' => false, 'errors' => ['Invalid or expired reset token']];
        }
        
        $passwordHash = password_hash($newPassword, PASSWORD_DEFAULT);
        
        $this->db->update('users', 
            [
                'password_hash' => $passwordHash,
                'reset_token' => null,
                'reset_expires' => null
            ], 
            'id = ?', 
            [$user['id']]
        );
        
        return ['success' => true, 'message' => 'Password reset successfully'];
    }
    
    private function sanitizeUser($user) {
        unset($user['password_hash']);
        unset($user['verification_token']);
        unset($user['reset_token']);
        unset($user['reset_expires']);
        return $user;
    }
    
    public function getUserStats($userId) {
        $stats = [
            'suggestions' => 0,
            'photos' => 0,
            'trips' => 0,
            'favorites' => 0
        ];
        
        try {
            $suggestions = $this->db->fetch("SELECT COUNT(*) as count FROM location_suggestions WHERE user_id = ?", [$userId]);
            if ($suggestions) $stats['suggestions'] = $suggestions['count'];
            
            $photos = $this->db->fetch("SELECT COUNT(*) as count FROM photos WHERE user_id = ?", [$userId]);
            if ($photos) $stats['photos'] = $photos['count'];
            
            $trips = $this->db->fetch("SELECT COUNT(*) as count FROM itineraries WHERE user_id = ? AND status != 'deleted'", [$userId]);
            if ($trips) $stats['trips'] = $trips['count'];
            
            $favorites = $this->db->fetch("SELECT COUNT(*) as count FROM user_favorites WHERE user_id = ?", [$userId]);
            if ($favorites) $stats['favorites'] = $favorites['count'];
        } catch (Exception $e) {
            error_log("Error fetching user stats: " . $e->getMessage());
        }
        
        return $stats;
    }
    
    public function getUserFavorites($userId) {
        try {
            return $this->db->fetchAll("
                SELECT l.*, c.icon as category_icon, g.name_en as gov_name 
                FROM user_favorites uf 
                JOIN locations l ON uf.location_id = l.id 
                LEFT JOIN categories c ON l.category_id = c.id
                LEFT JOIN governments g ON l.government_id = g.id
                WHERE uf.user_id = ? 
                ORDER BY uf.created_at DESC", 
                [$userId]
            );
        } catch (Exception $e) {
            error_log("Error fetching user favorites: " . $e->getMessage());
            return [];
        }
    }
    
    private function logActivity($userId, $activityType, $targetId = null, $targetType = '', $ipAddress = '', $userAgent = '') {
        $this->db->insert('user_activities', [
            'user_id' => $userId,
            'activity_type' => $activityType,
            'target_id' => $targetId,
            'target_type' => $targetType,
            'ip_address' => $ipAddress,
            'user_agent' => $userAgent
        ]);
    }
    
    public function verifyEmail($email, $code) {
        // Find user with matching email and verification code
        $user = $this->db->fetch(
            "SELECT id, code_expires_at FROM users WHERE email = ? AND verification_code = ? AND is_verified = 0",
            [$email, $code]
        );
        
        if (!$user) {
            return ['success' => false, 'error' => 'Invalid verification code or email'];
        }
        
        // Check if code is expired
        if ($user['code_expires_at'] && strtotime($user['code_expires_at']) < time()) {
            return ['success' => false, 'error' => 'Verification code expired'];
        }
        
        // Mark user as verified
        $this->db->execute(
            "UPDATE users SET is_verified = 1, verification_code = NULL, code_expires_at = NULL WHERE id = ?",
            [$user['id']]
        );
        
        return ['success' => true, 'message' => 'Email verified successfully'];
    }
    
    private function sendVerificationEmail($email, $token) {
        // Implement email sending
        // This is a placeholder - you would use a proper email service
        error_log("Verification email sent to $email with token $token");
    }
    
    private function sendPasswordResetEmail($email, $token) {
        // Implement email sending
        // This is a placeholder - you would use a proper email service
        error_log("Password reset email sent to $email with token $token");
    }
}
