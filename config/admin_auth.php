<?php

require_once __DIR__ . '/bootstrap.php';


class AdminAuth
{
    public function login(string $username, string $password): bool
    {
        $stmt = pdo()->prepare(
            "SELECT id, username, password_hash, full_name, role
             FROM admins
             WHERE username = ? AND active = 1
             LIMIT 1"
        );
        $stmt->execute([$username]);
        $admin = $stmt->fetch();

        if (!$admin || !password_verify($password, $admin['password_hash'])) {
            return false;
        }

        $_SESSION['admin_logged_in'] = true;
        $_SESSION['admin_id'] = (int) $admin['id'];
        $_SESSION['admin_name'] = $admin['full_name'];
        $_SESSION['admin_username'] = $admin['username'];
        $_SESSION['admin_role'] = $admin['role'];

        $update = pdo()->prepare("UPDATE admins SET last_login = NOW() WHERE id = ?");
        $update->execute([$admin['id']]);

        return true;
    }

    public function logout(): void
    {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(
                session_name(),
                '',
                time() - 42000,
                $params['path'],
                $params['domain'],
                $params['secure'],
                $params['httponly']
            );
        }
        session_destroy();
    }

    public function requireLogin(): array
    {
        $admin = current_admin();
        if (!$admin) {
            header('Location: admin_login.php');
            exit();
        }
        return $admin;
    }

    public function requirePermission(string $role = 'admin'): array
    {
        $admin = $this->requireLogin();
        if ($role === 'super_admin' && $admin['role'] !== 'super_admin') {
            http_response_code(403);
            exit('Forbidden');
        }
        return $admin;
    }
}
?>
