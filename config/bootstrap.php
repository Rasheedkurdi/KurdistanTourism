<?php
function is_https_request(): bool
{
    return (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
        || (($_SERVER['SERVER_PORT'] ?? '') === '443');
}

ini_set('session.use_strict_mode', '1');
ini_set('session.use_only_cookies', '1');
ini_set('session.use_trans_sid', '0');
ini_set('session.cookie_httponly', '1');
ini_set('session.cookie_samesite', 'Lax');

if (session_status() === PHP_SESSION_NONE) {
    session_set_cookie_params([
        'lifetime' => 0,
        'path' => '/',
        'domain' => '',
        'secure' => is_https_request(),
        'httponly' => true,
        'samesite' => 'Lax',
    ]);
    session_start();
}

require_once __DIR__ . '/database.php';

function send_security_headers(): void
{
    if (headers_sent()) {
        return;
    }

    header('X-Content-Type-Options: nosniff');
    header('X-Frame-Options: SAMEORIGIN');
    header('Referrer-Policy: strict-origin-when-cross-origin');
    header('Permissions-Policy: camera=(self), microphone=(), geolocation=(self)');
    header("Content-Security-Policy: base-uri 'self'; frame-ancestors 'self'; object-src 'none'; form-action 'self'");
    if (is_https_request()) {
        header('Strict-Transport-Security: max-age=31536000; includeSubDomains');
    }
}

send_security_headers();

class AppBootstrap
{
    /** @var PDO */
    private $pdo;
    /** @var string */
    private $uploadDir;

    public function __construct()
    {
        $database = new Database();
        $pdo = $database->getConnection();
        if (!$pdo) {
            http_response_code(500);
            exit('Database connection failed.');
        }

        $this->pdo = $pdo;
        $this->uploadDir = dirname(__DIR__) . DIRECTORY_SEPARATOR . 'uploads';
        $this->ensureUploadDirectory();
        $this->ensureSchema();
        $this->seedDefaults();
    }

    public function pdo(): PDO
    {
        return $this->pdo;
    }

    public function uploadDir(): string
    {
        return $this->uploadDir;
    }

    private function ensureUploadDirectory(): void
    {
        if (!is_dir($this->uploadDir)) {
            mkdir($this->uploadDir, 0775, true);
        }
    }

    private function ensureSchema(): void
    {
        $queries = [
            "CREATE TABLE IF NOT EXISTS admins (
                id INT AUTO_INCREMENT PRIMARY KEY,
                username VARCHAR(50) NOT NULL UNIQUE,
                password_hash VARCHAR(255) NOT NULL,
                full_name VARCHAR(120) NOT NULL,
                email VARCHAR(150) DEFAULT '',
                role ENUM('super_admin','admin') NOT NULL DEFAULT 'admin',
                active TINYINT(1) NOT NULL DEFAULT 1,
                last_login DATETIME NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                username VARCHAR(50) NOT NULL UNIQUE,
                full_name VARCHAR(120) NOT NULL,
                email VARCHAR(150) NOT NULL UNIQUE,
                password_hash VARCHAR(255) NOT NULL,
                phone VARCHAR(80) DEFAULT '',
                language VARCHAR(5) NOT NULL DEFAULT 'ku',
                bio TEXT DEFAULT NULL,
                avatar VARCHAR(255) DEFAULT NULL,
                status ENUM('active','suspended','deleted') NOT NULL DEFAULT 'active',
                is_verified TINYINT(1) NOT NULL DEFAULT 0,
                verification_code VARCHAR(10) DEFAULT NULL,
                verification_token VARCHAR(64) DEFAULT NULL,
                code_expires_at DATETIME DEFAULT NULL,
                last_login DATETIME DEFAULT NULL,
                login_count INT NOT NULL DEFAULT 0,
                reset_token VARCHAR(64) DEFAULT NULL,
                reset_expires DATETIME DEFAULT NULL,
                marked_for_deletion_at TIMESTAMP NULL DEFAULT NULL,
                deletion_reason VARCHAR(255) DEFAULT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS user_oauth_identities (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                provider VARCHAR(40) NOT NULL,
                provider_user_id VARCHAR(191) NOT NULL,
                email VARCHAR(150) NOT NULL,
                display_name VARCHAR(120) DEFAULT '',
                avatar_url VARCHAR(255) DEFAULT '',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                UNIQUE KEY uq_oauth_provider_user (provider, provider_user_id),
                KEY idx_oauth_user (user_id),
                CONSTRAINT fk_oauth_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS governments (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name_ku VARCHAR(120) NOT NULL,
                name_en VARCHAR(120) NOT NULL,
                name_ar VARCHAR(120) NOT NULL,
                color VARCHAR(20) NOT NULL DEFAULT '#3498db',
                lat DECIMAL(10,7) DEFAULT NULL,
                lng DECIMAL(10,7) DEFAULT NULL,
                zoom_level INT NOT NULL DEFAULT 10,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS categories (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name_ku VARCHAR(120) NOT NULL,
                name_en VARCHAR(120) NOT NULL,
                name_ar VARCHAR(120) NOT NULL,
                icon VARCHAR(50) NOT NULL DEFAULT 'map-marker-alt',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS locations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name_ku VARCHAR(150) NOT NULL,
                name_en VARCHAR(150) NOT NULL,
                name_ar VARCHAR(150) NOT NULL,
                description_ku TEXT,
                description_en TEXT,
                description_ar TEXT,
                lat DECIMAL(10,7) NOT NULL,
                lng DECIMAL(10,7) NOT NULL,
                government_id INT NOT NULL,
                category_id INT NOT NULL,
                address VARCHAR(255) DEFAULT '',
                phone VARCHAR(80) DEFAULT '',
                email VARCHAR(150) DEFAULT '',
                website VARCHAR(255) DEFAULT '',
                directions_url VARCHAR(255) DEFAULT '',
                opening_hours VARCHAR(150) DEFAULT '',
                ticket_price VARCHAR(120) DEFAULT '',
                featured TINYINT(1) NOT NULL DEFAULT 0,
                status ENUM('published','draft') NOT NULL DEFAULT 'published',
                total_visits INT NOT NULL DEFAULT 0,
                average_rating DECIMAL(3,2) NOT NULL DEFAULT 0,
                created_by INT DEFAULT NULL,
                image_path VARCHAR(255) DEFAULT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                CONSTRAINT fk_locations_government FOREIGN KEY (government_id) REFERENCES governments(id) ON DELETE RESTRICT,
                CONSTRAINT fk_locations_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
                CONSTRAINT fk_locations_admin FOREIGN KEY (created_by) REFERENCES admins(id) ON DELETE SET NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS location_images (
                id INT AUTO_INCREMENT PRIMARY KEY,
                location_id INT NOT NULL,
                image_path VARCHAR(255) NOT NULL,
                sort_order INT NOT NULL DEFAULT 0,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                CONSTRAINT fk_location_images_location FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS feedback (
                id INT AUTO_INCREMENT PRIMARY KEY,
                location_id INT NOT NULL,
                user_id INT DEFAULT NULL,
                visitor_name VARCHAR(120) NOT NULL,
                visitor_email VARCHAR(150) DEFAULT '',
                rating INT NOT NULL,
                comment TEXT NOT NULL,
                status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                CONSTRAINT fk_feedback_location FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE,
                CONSTRAINT fk_feedback_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS location_visits (
                id INT AUTO_INCREMENT PRIMARY KEY,
                location_id INT DEFAULT NULL,
                user_id INT DEFAULT NULL,
                ip_address VARCHAR(45) DEFAULT '',
                user_agent VARCHAR(255) DEFAULT '',
                visited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                KEY idx_visits_user (user_id),
                CONSTRAINT fk_visits_location FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE SET NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS settings (
                setting_key VARCHAR(100) PRIMARY KEY,
                setting_value TEXT NOT NULL
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS user_activities (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                activity_type VARCHAR(50) NOT NULL,
                target_id INT DEFAULT NULL,
                target_type VARCHAR(50) DEFAULT '',
                ip_address VARCHAR(45) DEFAULT '',
                user_agent VARCHAR(255) DEFAULT '',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                CONSTRAINT fk_user_activities_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS user_favorites (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                location_id INT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE KEY unique_favorite (user_id, location_id),
                KEY idx_favorites_user (user_id),
                KEY idx_favorites_location (location_id),
                CONSTRAINT fk_favorites_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                CONSTRAINT fk_favorites_location FOREIGN KEY (location_id) REFERENCES locations(id) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS location_suggestions (
                id INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                name_ku VARCHAR(150) NOT NULL,
                name_en VARCHAR(150) DEFAULT NULL,
                name_ar VARCHAR(150) DEFAULT NULL,
                description_ku TEXT DEFAULT NULL,
                description_en TEXT DEFAULT NULL,
                description_ar TEXT DEFAULT NULL,
                lat DECIMAL(10,7) NOT NULL,
                lng DECIMAL(10,7) NOT NULL,
                government_id INT DEFAULT NULL,
                category_id INT DEFAULT NULL,
                address VARCHAR(255) DEFAULT NULL,
                phone VARCHAR(80) DEFAULT NULL,
                email VARCHAR(150) DEFAULT NULL,
                website VARCHAR(255) DEFAULT NULL,
                directions_url VARCHAR(255) DEFAULT NULL,
                opening_hours VARCHAR(150) DEFAULT NULL,
                ticket_price VARCHAR(120) DEFAULT NULL,
                image_path VARCHAR(255) DEFAULT NULL,
                image_base64 MEDIUMTEXT DEFAULT NULL,
                status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
                admin_note TEXT DEFAULT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                reviewed_at TIMESTAMP NULL DEFAULT NULL,
                KEY idx_suggestions_user (user_id),
                KEY idx_suggestions_status (status),
                CONSTRAINT fk_suggestions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
            "CREATE TABLE IF NOT EXISTS contact_messages (
                id INT AUTO_INCREMENT PRIMARY KEY,
                full_name VARCHAR(120) NOT NULL,
                email VARCHAR(150) NOT NULL,
                phone VARCHAR(80) DEFAULT NULL,
                subject VARCHAR(200) NOT NULL,
                message TEXT NOT NULL,
                status ENUM('unread','read','replied') NOT NULL DEFAULT 'unread',
                admin_reply TEXT DEFAULT NULL,
                replied_at TIMESTAMP NULL DEFAULT NULL,
                ip_address VARCHAR(45) DEFAULT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                KEY idx_contact_status (status),
                KEY idx_contact_email (email)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
        ];

        foreach ($queries as $query) {
            $this->pdo->exec($query);
        }

        // Ensure optional columns added in later migrations exist
        $this->ensureColumn('users', 'auth_provider', "ALTER TABLE users ADD COLUMN auth_provider VARCHAR(40) DEFAULT 'password' AFTER is_verified");
        $this->ensureColumn('users', 'auth_provider_id', "ALTER TABLE users ADD COLUMN auth_provider_id VARCHAR(191) DEFAULT NULL AFTER auth_provider");
        $this->ensureColumn('users', 'avatar_url', "ALTER TABLE users ADD COLUMN avatar_url VARCHAR(255) DEFAULT NULL AFTER avatar");
        $this->ensureColumn('locations', 'directions_url', "ALTER TABLE locations ADD COLUMN directions_url VARCHAR(255) DEFAULT '' AFTER website");

        // Ensure missing columns in location_suggestions
        $this->ensureColumn('location_suggestions', 'phone', "ALTER TABLE location_suggestions ADD COLUMN phone VARCHAR(80) DEFAULT NULL AFTER address");
        $this->ensureColumn('location_suggestions', 'email', "ALTER TABLE location_suggestions ADD COLUMN email VARCHAR(150) DEFAULT NULL AFTER phone");
        $this->ensureColumn('location_suggestions', 'website', "ALTER TABLE location_suggestions ADD COLUMN website VARCHAR(255) DEFAULT NULL AFTER email");
        $this->ensureColumn('location_suggestions', 'directions_url', "ALTER TABLE location_suggestions ADD COLUMN directions_url VARCHAR(255) DEFAULT NULL AFTER website");
        $this->ensureColumn('location_suggestions', 'opening_hours', "ALTER TABLE location_suggestions ADD COLUMN opening_hours VARCHAR(150) DEFAULT NULL AFTER directions_url");
        $this->ensureColumn('location_suggestions', 'ticket_price', "ALTER TABLE location_suggestions ADD COLUMN ticket_price VARCHAR(120) DEFAULT NULL AFTER opening_hours");
        $this->ensureColumn('location_suggestions', 'image_path', "ALTER TABLE location_suggestions ADD COLUMN image_path VARCHAR(255) DEFAULT NULL AFTER ticket_price");
        $this->ensureColumn('location_suggestions', 'image_base64', "ALTER TABLE location_suggestions ADD COLUMN image_base64 MEDIUMTEXT DEFAULT NULL AFTER image_path");
        
        // Add image_path to locations table for direct cover image storage
        $this->ensureColumn('locations', 'image_path', "ALTER TABLE locations ADD COLUMN image_path VARCHAR(255) DEFAULT NULL AFTER created_by");

        // Split into two separate calls — PDO exec() does not support multi-statement ALTER
        $this->ensureColumn('feedback', 'user_id', "ALTER TABLE feedback ADD COLUMN user_id INT DEFAULT NULL AFTER location_id");
        $this->ensureForeignKey('feedback', 'fk_feedback_user', "ALTER TABLE feedback ADD CONSTRAINT fk_feedback_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL");
    }

    private function seedDefaults(): void
    {
        $adminCount = (int) $this->pdo->query("SELECT COUNT(*) FROM admins")->fetchColumn();
        $defaultAdminPassword = getenv('DEFAULT_ADMIN_PASSWORD') ?: '';
        if ($adminCount === 0 && $defaultAdminPassword !== '') {
            $stmt = $this->pdo->prepare(
                "INSERT INTO admins (username, password_hash, full_name, email, role)
                 VALUES (?, ?, ?, ?, ?)"
            );
            $stmt->execute([
                getenv('DEFAULT_ADMIN_USERNAME') ?: 'admin',
                password_hash($defaultAdminPassword, PASSWORD_DEFAULT),
                'System Administrator',
                getenv('DEFAULT_ADMIN_EMAIL') ?: 'admin@example.com',
                'super_admin'
            ]);
        }

        $governmentCount = (int) $this->pdo->query("SELECT COUNT(*) FROM governments")->fetchColumn();
        if ($governmentCount === 0) {
            $stmt = $this->pdo->prepare(
                "INSERT INTO governments (name_ku, name_en, name_ar, color, lat, lng, zoom_level)
                 VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            $defaults = [
                ['دهۆک', 'Duhok', 'دهوك', '#e74c3c', 36.8665, 43.0000, 10],
                ['هەولێر', 'Erbil', 'أربيل', '#2ecc71', 36.1901, 44.0090, 10],
                ['سلێمانی', 'Sulaymaniyah', 'السليمانية', '#3498db', 35.5576, 45.4359, 10],
            ];
            foreach ($defaults as $row) {
                $stmt->execute($row);
            }
        }

        $categoryCount = (int) $this->pdo->query("SELECT COUNT(*) FROM categories")->fetchColumn();
        if ($categoryCount === 0) {
            $stmt = $this->pdo->prepare(
                "INSERT INTO categories (name_ku, name_en, name_ar, icon)
                 VALUES (?, ?, ?, ?)"
            );
            $defaults = [
                ['مێژوویی', 'Historical', 'تاريخي', 'landmark'],
                ['سروشتی', 'Natural', 'طبيعي', 'mountain'],
                ['هۆتێل', 'Hotel', 'فندق', 'hotel'],
                ['خواردنگە', 'Restaurant', 'مطعم', 'utensils'],
                ['پارک', 'Park', 'حديقة', 'tree']
            ];
            foreach ($defaults as $row) {
                $stmt->execute($row);
            }
        }

        $settingDefaults = [
            'allow_registration' => '1',
            'allow_feedback' => '1',
            'feedback_moderation' => '1',
            'email_notifications' => '0',
            'default_language' => 'ku',
            'locations_per_page' => '12'
        ];
        $stmt = $this->pdo->prepare(
            "INSERT INTO settings (setting_key, setting_value) VALUES (?, ?)
             ON DUPLICATE KEY UPDATE setting_value = setting_value"
        );
        foreach ($settingDefaults as $key => $value) {
            $stmt->execute([$key, $value]);
        }
    }

    private function ensureColumn(string $table, string $column, string $sql): void
    {
        $stmt = $this->pdo->prepare(
            "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?"
        );
        $stmt->execute([$table, $column]);
        if ((int) $stmt->fetchColumn() === 0) {
            $this->pdo->exec($sql);
        }
    }

    private function ensureForeignKey(string $table, string $constraintName, string $sql): void
    {
        $stmt = $this->pdo->prepare(
            "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND CONSTRAINT_NAME = ?"
        );
        $stmt->execute([$table, $constraintName]);
        if ((int) $stmt->fetchColumn() === 0) {
            $this->pdo->exec($sql);
        }
    }
}

function app(): AppBootstrap
{
    static $app = null;
    if ($app === null) {
        $app = new AppBootstrap();
    }
    return $app;
}

function pdo(): PDO
{
    return app()->pdo();
}

function json_response(array $data, int $status = 200): void
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit();
}

function request_data(): array
{
    $contentType = $_SERVER['CONTENT_TYPE'] ?? '';
    if (stripos($contentType, 'application/json') !== false) {
        $decoded = json_decode(file_get_contents('php://input'), true);
        return is_array($decoded) ? $decoded : [];
    }

    return $_POST;
}

function request_origin(): string
{
    $scheme = is_https_request() ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'] ?? '';
    return $host === '' ? '' : $scheme . '://' . $host;
}

function allowed_cors_origins(): array
{
    $allowed = getenv('CORS_ALLOWED_ORIGINS') ?: '';
    return array_values(array_filter(array_map('trim', explode(',', $allowed))));
}

function configure_cors(): void
{
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    if ($origin === '') {
        return;
    }

    $allowedOrigins = allowed_cors_origins();
    $sameOrigin = request_origin();
    if ($origin === $sameOrigin || in_array($origin, $allowedOrigins, true)) {
        header('Access-Control-Allow-Origin: ' . $origin);
        header('Access-Control-Allow-Credentials: true');
        header('Vary: Origin');
    }
}

function reject_cross_origin_state_change(): void
{
    $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
    if (!in_array($method, ['POST', 'PUT', 'PATCH', 'DELETE'], true)) {
        return;
    }

    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    if ($origin === '') {
        return;
    }

    $allowedOrigins = allowed_cors_origins();
    if ($origin !== request_origin() && !in_array($origin, $allowedOrigins, true)) {
        json_response(['error' => 'Cross-origin request blocked'], 403);
    }
}

function csrf_token(): string
{
    if (empty($_SESSION['_csrf_token'])) {
        $_SESSION['_csrf_token'] = bin2hex(random_bytes(32));
    }

    return $_SESSION['_csrf_token'];
}

function csrf_input(): string
{
    return '<input type="hidden" name="_csrf_token" value="' . htmlspecialchars(csrf_token(), ENT_QUOTES, 'UTF-8') . '">';
}

function verify_csrf_token(?string $token): bool
{
    return is_string($token) && hash_equals(csrf_token(), $token);
}

function require_csrf_token(): void
{
    if (!verify_csrf_token($_POST['_csrf_token'] ?? null)) {
        http_response_code(419);
        exit('Invalid security token.');
    }
}

function app_url(string $path = ''): string
{
    $base = rtrim(getenv('APP_URL') ?: request_origin(), '/');
    if ($base === '') {
        $base = '.';
    }

    return $base . '/' . ltrim($path, '/');
}

function html_escape(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function client_ip(): string
{
    return substr($_SERVER['REMOTE_ADDR'] ?? 'unknown', 0, 45);
}

function client_user_agent(): string
{
    return substr($_SERVER['HTTP_USER_AGENT'] ?? '', 0, 255);
}

function rate_limit_key(string $scope, string $identifier): string
{
    return $scope . ':' . hash('sha256', strtolower(trim($identifier)) . '|' . client_ip());
}

function rate_limit_is_blocked(string $key, int $maxAttempts = 5, int $windowSeconds = 900): bool
{
    $now = time();
    $_SESSION['_rate_limits'][$key] = array_values(array_filter(
        $_SESSION['_rate_limits'][$key] ?? [],
        static function ($timestamp) use ($now, $windowSeconds): bool {
            return is_int($timestamp) && $timestamp > $now - $windowSeconds;
        }
    ));

    return count($_SESSION['_rate_limits'][$key]) >= $maxAttempts;
}

function rate_limit_record_failure(string $key): void
{
    $_SESSION['_rate_limits'][$key] ??= [];
    $_SESSION['_rate_limits'][$key][] = time();
}

function rate_limit_clear(string $key): void
{
    unset($_SESSION['_rate_limits'][$key]);
}

function image_extension_from_mime(string $mimeType): ?string
{
    $extensions = [
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        'image/gif' => 'gif',
        'image/webp' => 'webp',
    ];

    return $extensions[$mimeType] ?? null;
}

function uploaded_image_extension(array $file, int $maxBytes): ?string
{
    if (!isset($file['tmp_name'], $file['size']) || !is_uploaded_file($file['tmp_name'])) {
        return null;
    }

    if ((int) $file['size'] <= 0 || (int) $file['size'] > $maxBytes) {
        return null;
    }

    $imageInfo = getimagesize($file['tmp_name']);
    if ($imageInfo === false || empty($imageInfo['mime'])) {
        return null;
    }

    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mimeType = $finfo ? finfo_file($finfo, $file['tmp_name']) : $imageInfo['mime'];
    if ($finfo) {
        finfo_close($finfo);
    }

    if ($mimeType !== $imageInfo['mime']) {
        return null;
    }

    return image_extension_from_mime($mimeType);
}

function image_data_extension(string $imageData, int $maxBytes): ?string
{
    if ($imageData === '' || strlen($imageData) > $maxBytes) {
        return null;
    }

    $imageInfo = getimagesizefromstring($imageData);
    if ($imageInfo === false || empty($imageInfo['mime'])) {
        return null;
    }

    return image_extension_from_mime($imageInfo['mime']);
}

function secure_random_filename(string $prefix, string $extension): string
{
    return $prefix . bin2hex(random_bytes(16)) . '.' . $extension;
}

function sanitize_hex_color(string $color, string $fallback = '#3498db'): string
{
    return preg_match('/^#[0-9A-Fa-f]{6}$/', $color) ? $color : $fallback;
}

function sanitize_icon_name(string $icon, string $fallback = 'map-marker-alt'): string
{
    return preg_match('/^[a-z0-9-]{1,50}$/', $icon) ? $icon : $fallback;
}

function current_admin(): ?array
{
    if (empty($_SESSION['admin_logged_in']) || empty($_SESSION['admin_id'])) {
        return null;
    }

    return [
        'id' => (int) $_SESSION['admin_id'],
        'name' => $_SESSION['admin_name'] ?? '',
        'username' => $_SESSION['admin_username'] ?? '',
        'role' => $_SESSION['admin_role'] ?? 'admin'
    ];
}

function require_admin(?string $role = null): array
{
    $admin = current_admin();
    if (!$admin) {
        json_response(['error' => 'Authentication required'], 401);
    }

    if ($role === 'super_admin' && $admin['role'] !== 'super_admin') {
        json_response(['error' => 'Forbidden'], 403);
    }

    return $admin;
}

function save_uploaded_images(int $locationId, array $files): array
{
    if (empty($files['name'])) {
        return [];
    }

    $pdo = pdo();
    $uploadDir = app()->uploadDir();
    $saved = [];
    $names = is_array($files['name']) ? $files['name'] : [$files['name']];
    $tmpNames = is_array($files['tmp_name']) ? $files['tmp_name'] : [$files['tmp_name']];
    $errors = is_array($files['error']) ? $files['error'] : [$files['error']];

    $stmt = $pdo->prepare(
        "INSERT INTO location_images (location_id, image_path, sort_order) VALUES (?, ?, ?)"
    );

    foreach ($names as $index => $originalName) {
        if (($errors[$index] ?? UPLOAD_ERR_NO_FILE) !== UPLOAD_ERR_OK) {
            error_log("Upload error for file $originalName: " . ($errors[$index] ?? 'unknown'));
            continue;
        }

        $tmpName = $tmpNames[$index] ?? '';
        $file = [
            'name' => $originalName,
            'tmp_name' => $tmpName,
            'size' => is_file($tmpName) ? filesize($tmpName) : 0,
            'error' => $errors[$index] ?? UPLOAD_ERR_NO_FILE,
        ];

        $extension = uploaded_image_extension($file, 10 * 1024 * 1024);
        if ($extension === null) {
            error_log("Invalid image upload for file $originalName");
            continue;
        }

        $filename = secure_random_filename('loc_', $extension);
        $destination = $uploadDir . DIRECTORY_SEPARATOR . $filename;
        
        // Ensure upload directory exists and is writable
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }
        
        if (!move_uploaded_file($tmpName, $destination)) {
            $error = error_get_last();
            error_log("Failed to move uploaded file $tmpName to $destination: " . ($error['message'] ?? 'unknown error'));
            continue;
        }

        $relativePath = 'uploads/' . $filename;
        $stmt->execute([$locationId, $relativePath, $index]);
        $saved[] = $relativePath;
        error_log("Successfully saved image for location $locationId: $relativePath");
        
        // Also update the locations table image_path if this is the first image (index 0)
        if ($index === 0) {
            $updateStmt = $pdo->prepare("UPDATE locations SET image_path = ? WHERE id = ?");
            $updateStmt->execute([$relativePath, $locationId]);
            error_log("Updated locations.image_path for location $locationId: $relativePath");
        }
    }

    return $saved;
}

function delete_location_images(int $locationId): void
{
    $pdo = pdo();
    $stmt = $pdo->prepare("SELECT image_path FROM location_images WHERE location_id = ?");
    $stmt->execute([$locationId]);
    $images = $stmt->fetchAll(PDO::FETCH_COLUMN);

    foreach ($images as $path) {
        // Extract filename from path (path may be like "uploads/1234567890.jpg")
        $filename = basename($path);
        $fullPath = app()->uploadDir() . DIRECTORY_SEPARATOR . $filename;
        if (is_file($fullPath)) {
            unlink($fullPath);
        }
    }

    $deleteStmt = $pdo->prepare("DELETE FROM location_images WHERE location_id = ?");
    $deleteStmt->execute([$locationId]);
}
?>
