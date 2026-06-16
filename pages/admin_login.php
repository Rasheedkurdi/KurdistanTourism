<?php
require_once __DIR__ . '/../config/admin_auth.php';

$auth = new AdminAuth();
if (current_admin()) {
    header('Location: admin.php');
    exit();
}

$error = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_csrf_token();
    $username = trim($_POST['username'] ?? '');
    $password = trim($_POST['password'] ?? '');

    if ($auth->login($username, $password)) {
        header('Location: admin.php');
        exit();
    }

    $error = 'Invalid username or password.';
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Arabic:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Noto Sans Arabic', sans-serif; }
        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            background: linear-gradient(135deg, #123524 0%, #3e7b27 50%, #85a947 100%);
            color: #122117;
        }
        .card {
            width: min(420px, calc(100vw - 32px));
            background: rgba(255,255,255,0.96);
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 24px 60px rgba(0,0,0,0.2);
        }
        h1 { margin: 0 0 8px; font-size: 28px; }
        p { margin: 0 0 20px; color: #54635a; }
        label { display: block; margin-bottom: 8px; font-weight: 700; }
        input {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #cfd8d3;
            border-radius: 12px;
            margin-bottom: 16px;
        }
        button {
            width: 100%;
            border: 0;
            border-radius: 12px;
            padding: 13px 16px;
            background: #123524;
            color: #fff;
            font-weight: 700;
            cursor: pointer;
        }
        .error {
            background: #ffe4e4;
            color: #9b1c1c;
            border-radius: 12px;
            padding: 12px;
            margin-bottom: 16px;
        }
        .hint {
            margin-top: 14px;
            font-size: 14px;
            color: #54635a;
        }
        a { color: #123524; }
    </style>
</head>
<body>
    <form class="card" method="post">
        <?php echo csrf_input(); ?>
        <h1>Admin Login</h1>
        <?php if ($error !== ''): ?>
            <div class="error"><?php echo htmlspecialchars($error, ENT_QUOTES, 'UTF-8'); ?></div>
        <?php endif; ?>
        <label for="username">Username</label>
        <input id="username" name="username" required>
        <label for="password">Password</label>
        <input id="password" name="password" type="password" required>
        <button type="submit">Sign In</button>
        <div class="hint"><a href="../index.html">Back to map</a></div>
    </form>
</body>
</html>
