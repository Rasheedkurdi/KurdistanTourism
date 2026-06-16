<?php
require_once __DIR__ . '/../config/user_auth.php';

$auth = new UserAuth();

// Check if user is already logged in
if ($auth->getCurrentUser()) {
    header('Location: ../index.html');
    exit;
}

$errors = [];
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_csrf_token();
    if (isset($_POST['login'])) {
        $result = $auth->login($_POST['username'], $_POST['password']);
        
        if ($result['success']) {
            header('Location: ../index.html');
            exit;
        } else {
            $errors = $result['errors'];
        }
    } elseif (isset($_POST['forgot_password'])) {
        $result = $auth->forgotPassword($_POST['email']);
        
        if ($result['success']) {
            $success = $result['message'];
        } else {
            $errors = $result['errors'];
        }
    }
}
?>
<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>چوونەژوورەوە - شوێنە گەشتیاریەکانی کوردستان</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+Arabic:wght@300;400;500;600;700&family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Styles -->
    <link rel="stylesheet" href="../assets/css/style.css">
    <link rel="stylesheet" href="../assets/css/pages.css">
    <style>
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }
        
        .auth-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            width: 100%;
            max-width: 400px;
            margin: 20px;
        }
        
        .auth-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .auth-header h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 600;
        }
        
        .auth-header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 14px;
        }
        
        .auth-body {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .input-icon {
            position: relative;
        }
        
        .input-icon i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }
        
        .input-icon input {
            padding-left: 45px;
        }
        
        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #f8f9fa;
            color: #333;
            margin-top: 10px;
        }
        
        .btn-secondary:hover {
            background: #e9ecef;
        }
        
        .auth-footer {
            padding: 20px 30px;
            background: #f8f9fa;
            text-align: center;
        }
        
        .auth-footer a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .auth-footer a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .alert-error {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        
        .alert-success {
            background: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }
        
        .divider {
            text-align: center;
            margin: 20px 0;
            position: relative;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e1e8ed;
        }
        
        .divider span {
            background: white;
            padding: 0 15px;
            position: relative;
            color: #999;
            font-size: 14px;
        }
        
        .forgot-form {
            display: none;
        }
        
        .show-forgot {
            display: block;
        }
        
        .hide-login {
            display: none;
        }

        /* Dark mode overrides (Default for the app) */
        body:not(.light-mode) .auth-card {
            background: #1e293b;
        }
        body:not(.light-mode) .form-group label {
            color: #cbd5e1;
        }
        body:not(.light-mode) .form-group input {
            background: #0f172a;
            border-color: #334155;
            color: #f1f5f9;
        }
        body:not(.light-mode) .auth-footer {
            background: #0f172a;
            border-color: #334155;
        }
        body:not(.light-mode) .divider::before {
            background: #334155;
        }
        body:not(.light-mode) .divider span {
            background: #1e293b;
            color: #94a3b8;
        }
        body:not(.light-mode) .btn-secondary {
            background: #334155;
            color: #f1f5f9;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1>بەخێربێیت</h1>
                <p>چوونەژوورەوە بۆ سیستەمی شوێنە گەشتیاریەکانی کوردستان</p>
            </div>
            
            <div class="auth-body">
                <?php if (!empty($errors)): ?>
                    <div class="alert alert-error">
                        <?php foreach ($errors as $error): ?>
                            <div><?php echo htmlspecialchars($error); ?></div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>
                
                <?php if (!empty($success)): ?>
                    <div class="alert alert-success">
                        <?php echo htmlspecialchars($success); ?>
                    </div>
                <?php endif; ?>
                
                <!-- Login Form -->
                <form method="post" class="login-form <?php echo !empty($success) ? 'hide-login' : ''; ?>">
                    <?php echo csrf_input(); ?>
                    <div class="form-group">
                        <label for="username">ناوی بەکارهێنەر یان ئیمەیل</label>
                        <div class="input-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" id="username" name="username" required 
                                   value="<?php echo htmlspecialchars($_POST['username'] ?? ''); ?>"
                                   placeholder="ناوی بەکارهێنەر یان ئیمەیل">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">تێپەڕەوشە</label>
                        <div class="input-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" required placeholder="تێپەڕەوشە">
                        </div>
                    </div>
                    
                    <button type="submit" name="login" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i> چوونەژوورەوە
                    </button>
                </form>
                
                <!-- Forgot Password Form -->
                <form method="post" class="forgot-form <?php echo !empty($success) ? 'show-forgot' : ''; ?>">
                    <?php echo csrf_input(); ?>
                    <div class="form-group">
                        <label for="email">ئیمەیل</label>
                        <div class="input-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" required 
                                   value="<?php echo htmlspecialchars($_POST['email'] ?? ''); ?>"
                                   placeholder="ئیمەیلی خۆت بنووسە">
                        </div>
                    </div>
                    
                    <button type="submit" name="forgot_password" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> ناردنی بەستەر دەستکاریکردنی تێپەڕەوشە
                    </button>
                </form>
                
                <div class="divider">
                    <span>یان</span>
                </div>
                
                <div class="text-center">
                    <button type="button" class="btn btn-secondary" onclick="toggleForgotForm()">
                        <i class="fas fa-key"></i> <span id="toggle-text">لێبوردنیت تێپەڕەوشە؟</span>
                    </button>
                </div>
            </div>
            
            <div class="auth-footer">
                <p>هێشتا هەژمارەکەت نییە؟ <a href="register.php">تۆمارکردن</a></p>
                <p style="margin-top: 10px;">
                    <a href="../index.html">
                        <i class="fas fa-arrow-left"></i> گەڕانەوە بۆ سەرەکی
                    </a>
                </p>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Load theme
            const savedTheme = localStorage.getItem('tourism_theme') || 'dark';
            if (savedTheme === 'light') {
                document.body.classList.add('light-mode');
            }
        });

        function toggleForgotForm() {
            const loginForm = document.querySelector('.login-form');
            const forgotForm = document.querySelector('.forgot-form');
            const toggleText = document.getElementById('toggle-text');
            
            if (forgotForm.style.display === 'block' || forgotForm.classList.contains('show-forgot')) {
                loginForm.style.display = 'block';
                forgotForm.style.display = 'none';
                toggleText.textContent = 'لێبوردنیت تێپەڕەوشە؟';
            } else {
                loginForm.style.display = 'none';
                forgotForm.style.display = 'block';
                toggleText.textContent = 'چوونەژوورەوە';
            }
        }
        
        // Auto-hide login form if success message is shown
        <?php if (!empty($success)): ?>
        document.querySelector('.login-form').style.display = 'none';
        document.querySelector('.forgot-form').style.display = 'block';
        document.getElementById('toggle-text').textContent = 'چوونەژوورەوە';
        <?php endif; ?>
    </script>
</body>
</html>
