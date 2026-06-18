<?php
require_once __DIR__ . '/bootstrap.php';

class UserAuth {
    private $db;
    
    public function __construct() {
        app();
        $this->db = Database::getInstance();
    }

    private function createSession(array $user): void {
        session_regenerate_id(true);
        $_SESSION['user_logged_in'] = true;
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user_name'] = $user['full_name'];
        $_SESSION['user_email'] = $user['email'];
        $_SESSION['user_role'] = 'user';
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
        $this->logActivity($userId, 'register', null, '', client_ip(), client_user_agent());
        
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
        $rateLimitKey = rate_limit_key('user_login', (string) $username);
        
        if (empty($username) || empty($password)) {
            return ['success' => false, 'errors' => ['Username and password are required']];
        }
        if (rate_limit_is_blocked($rateLimitKey)) {
            return ['success' => false, 'errors' => ['Too many login attempts. Please wait and try again.']];
        }
        
        // Find user
        $user = $this->db->fetch(
            "SELECT * FROM users WHERE (username = ? OR email = ?) AND status = 'active'",
            [$username, $username]
        );
        
        if (!$user || !password_verify($password, $user['password_hash'])) {
            rate_limit_record_failure($rateLimitKey);
            return ['success' => false, 'errors' => ['Invalid username or password']];
        }
        rate_limit_clear($rateLimitKey);
        
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
        $this->logActivity($user['id'], 'login', null, '', client_ip(), client_user_agent());
        
        // Create session
        $this->createSession($user);
        
        return [
            'success' => true,
            'user' => $this->sanitizeUser($user)
        ];
    }

    public function loginWithOAuthProfile(array $profile): array {
        $provider = (string) ($profile['provider'] ?? '');
        $providerUserId = (string) ($profile['provider_user_id'] ?? '');
        $email = strtolower(trim((string) ($profile['email'] ?? '')));
        $name = trim((string) ($profile['name'] ?? ''));
        $avatarUrl = trim((string) ($profile['avatar_url'] ?? ''));

        if (!preg_match('/^[a-z0-9_-]{2,40}$/', $provider) || $providerUserId === '') {
            return ['success' => false, 'errors' => ['Invalid sign-in provider response']];
        }
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            return ['success' => false, 'errors' => ['Provider did not return a valid email address']];
        }
        if ($name === '') {
            $name = $email;
        }

        $pdo = $this->db->getConnection();
        if (!$pdo) {
            return ['success' => false, 'errors' => ['Database connection failed']];
        }

        $pdo->beginTransaction();
        try {
            $stmt = $pdo->prepare(
                "SELECT u.*
                 FROM user_oauth_identities oi
                 JOIN users u ON u.id = oi.user_id
                 WHERE oi.provider = ? AND oi.provider_user_id = ? AND u.status = 'active'
                 LIMIT 1"
            );
            $stmt->execute([$provider, $providerUserId]);
            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$user) {
                $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ? AND status = 'active' LIMIT 1");
                $stmt->execute([$email]);
                $user = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($user) {
                    $update = $pdo->prepare(
                        "UPDATE users
                         SET is_verified = 1, auth_provider = ?, auth_provider_id = ?, avatar_url = COALESCE(NULLIF(?, ''), avatar_url)
                         WHERE id = ?"
                    );
                    $update->execute([$provider, $providerUserId, $avatarUrl, $user['id']]);
                } else {
                    $username = $this->uniqueOAuthUsername($email);
                    $passwordHash = password_hash(bin2hex(random_bytes(32)), PASSWORD_DEFAULT);
                    $insert = $pdo->prepare(
                        "INSERT INTO users (username, full_name, email, password_hash, is_verified, auth_provider, auth_provider_id, avatar_url)
                         VALUES (?, ?, ?, ?, 1, ?, ?, ?)"
                    );
                    $insert->execute([$username, $name, $email, $passwordHash, $provider, $providerUserId, $avatarUrl]);
                    $userId = (int) $pdo->lastInsertId();
                    $stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
                    $stmt->execute([$userId]);
                    $user = $stmt->fetch(PDO::FETCH_ASSOC);
                }

                $link = $pdo->prepare(
                    "INSERT INTO user_oauth_identities (user_id, provider, provider_user_id, email, display_name, avatar_url)
                     VALUES (?, ?, ?, ?, ?, ?)
                     ON DUPLICATE KEY UPDATE user_id = VALUES(user_id), email = VALUES(email), display_name = VALUES(display_name), avatar_url = VALUES(avatar_url)"
                );
                $link->execute([$user['id'], $provider, $providerUserId, $email, $name, $avatarUrl]);
            }

            $updateLogin = $pdo->prepare(
                "UPDATE users
                 SET last_login = NOW(), login_count = login_count + 1, auth_provider = ?, auth_provider_id = ?, avatar_url = COALESCE(NULLIF(?, ''), avatar_url)
                 WHERE id = ?"
            );
            $updateLogin->execute([$provider, $providerUserId, $avatarUrl, $user['id']]);
            $pdo->commit();
        } catch (Throwable $e) {
            $pdo->rollBack();
            error_log('OAuth login failed: ' . $e->getMessage());
            return ['success' => false, 'errors' => ['Could not complete social sign-in']];
        }

        $stmt = $pdo->prepare("SELECT * FROM users WHERE id = ?");
        $stmt->execute([$user['id']]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        $this->logActivity($user['id'], 'oauth_login', null, $provider, client_ip(), client_user_agent());
        $this->createSession($user);

        return [
            'success' => true,
            'user' => $this->sanitizeUser($user)
        ];
    }
    
    public function logout() {
        if (isset($_SESSION['user_id'])) {
            $this->logActivity($_SESSION['user_id'], 'logout', null, '', client_ip(), client_user_agent());
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
            return ['success' => true, 'message' => 'If that email exists, a reset link will be sent.'];
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
        
        if (strlen($newPassword) < 8) {
            return ['success' => false, 'errors' => ['Password must be at least 8 characters']];
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
    
    private function uniqueOAuthUsername(string $email): string {
        $localPart = strstr($email, '@', true);
        $base = preg_replace('/[^a-zA-Z0-9_]/', '_', (string) $localPart);
        $base = trim((string) $base, '_');
        if (strlen($base) < 3) {
            $base = 'user_' . substr(hash('sha256', $email), 0, 8);
        }
        $base = substr($base, 0, 20);
        $username = $base;
        $counter = 1;

        while ($this->db->fetch("SELECT id FROM users WHERE username = ?", [$username])) {
            $suffix = '_' . $counter;
            $username = substr($base, 0, 20 - strlen($suffix)) . $suffix;
            $counter++;
        }

        return $username;
    }

    private function sanitizeUser($user) {
        unset($user['password_hash']);
        unset($user['verification_token']);
        unset($user['verification_code']);
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
