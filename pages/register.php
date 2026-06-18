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
$oauthError = trim($_GET['oauth_error'] ?? '');
if ($oauthError !== '') {
    $errors[] = $oauthError;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_csrf_token();
    $result = $auth->register($_POST);
    
    if ($result['success']) {
        $success = $result['message'];
        
        // Auto-login the user using the provided credentials
        $auth->login($_POST['username'], $_POST['password']);
        
        // Redirect to the map after successful registration and login
        header('Location: ../index.html');
        exit;
    } else {
        $errors = $result['errors'];
    }
}
?>
<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>تۆمارکردن - شوێنە گەشتیاریەکانی کوردستان</title>
    
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
            max-width: 450px;
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
        
        .form-row {
            display: flex;
            gap: 15px;
        }
        
        .form-row .form-group {
            flex: 1;
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
        
        .form-group input, .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .form-group input:focus, .form-group select:focus {
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

        .oauth-buttons {
            display: grid;
            gap: 10px;
            margin-bottom: 20px;
        }

        .btn-oauth {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            background: #fff;
            color: #1f2937;
            border: 1px solid #d1d5db;
            text-decoration: none;
        }

        .btn-oauth:hover {
            background: #f8fafc;
            border-color: #667eea;
            transform: translateY(-1px);
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
        
        .password-strength {
            margin-top: 8px;
            height: 4px;
            background: #e1e8ed;
            border-radius: 2px;
            overflow: hidden;
        }
        
        .password-strength-bar {
            height: 100%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }
        
        .strength-weak { background: #e74c3c; width: 33%; }
        .strength-medium { background: #f39c12; width: 66%; }
        .strength-strong { background: #27ae60; width: 100%; }
        
        .terms-checkbox {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .terms-checkbox input {
            margin-top: 4px;
            width: auto;
        }
        
        .terms-checkbox label {
            margin: 0;
            font-size: 14px;
            line-height: 1.4;
        }
        
        .terms-checkbox a {
            color: #667eea;
            text-decoration: none;
        }
        
        .terms-checkbox a:hover {
            text-decoration: underline;
        }

        /* Dark mode overrides (Default for the app) */
        body:not(.light-mode) .auth-card {
            background: #1e293b;
        }
        body:not(.light-mode) .form-group label,
        body:not(.light-mode) .terms-checkbox label {
            color: #cbd5e1;
        }
        body:not(.light-mode) .form-group input,
        body:not(.light-mode) .form-group select {
            background: #0f172a;
            border-color: #334155;
            color: #f1f5f9;
        }
        body:not(.light-mode) .auth-footer {
            background: #0f172a;
            border-color: #334155;
        }
        body:not(.light-mode) .password-strength {
            background: #334155;
        }
        body:not(.light-mode) .btn-oauth {
            background: #0f172a;
            border-color: #334155;
            color: #f1f5f9;
        }
        body:not(.light-mode) .btn-oauth:hover {
            background: #172033;
        }
        body:not(.light-mode) .divider::before {
            background: #334155;
        }
        body:not(.light-mode) .divider span {
            background: #1e293b;
            color: #94a3b8;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1>درووستکردنی هەژمار</h1>
                <p>بەشداری لە کۆمەڵگەی گەشتیاری کوردستان بکە</p>
            </div>
            
            <div class="auth-body">
                <?php if (!empty($errors)): ?>
                    <div class="alert alert-error">
                        <?php foreach ($errors as $error): ?>
                            <div><?php echo htmlspecialchars($error); ?></div>
                        <?php endforeach; ?>
                    </div>
                <?php endif; ?>

                <div class="oauth-buttons">
                    <a class="btn btn-oauth" href="oauth_start.php?provider=google" rel="nofollow">
                        <i class="fab fa-google"></i> Continue with Google
                    </a>
                </div>

                <div class="divider"><span>یان هەژماری نوێ درووست بکە</span></div>
                
                <form method="post" id="register-form">
                    <?php echo csrf_input(); ?>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="username">ناوی بەکارهێنەر *</label>
                            <div class="input-icon">
                                <i class="fas fa-user"></i>
                                <input type="text" id="username" name="username" required 
                                       value="<?php echo htmlspecialchars($_POST['username'] ?? ''); ?>"
                                       placeholder="ناوی بەکارهێنەر"
                                       pattern="^[a-zA-Z0-9_]{3,20}$"
                                       title="ناوی بەکارهێنەر دەبێت 3-20 پیت بێت و تەنها پیت، ژمارە و _ لەخۆبگرێت">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="full_name">ناوی تەواو *</label>
                            <div class="input-icon">
                                <i class="fas fa-id-card"></i>
                                <input type="text" id="full_name" name="full_name" required 
                                       value="<?php echo htmlspecialchars($_POST['full_name'] ?? ''); ?>"
                                       placeholder="ناوی تەواو">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">ئیمەیل *</label>
                        <div class="input-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" id="email" name="email" required 
                                   value="<?php echo htmlspecialchars($_POST['email'] ?? ''); ?>"
                                   placeholder="ئیمەیل">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">تەلەفۆن (بەردەست)</label>
                        <div class="input-icon">
                            <i class="fas fa-phone"></i>
                            <input type="tel" id="phone" name="phone" 
                                   value="<?php echo htmlspecialchars($_POST['phone'] ?? ''); ?>"
                                   placeholder="تەلەفۆن"
                                   pattern="^[+]?[0-9]{10,15}$"
                                   title="ژمارەی تەلەفۆنی دروست">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="language">زمان *</label>
                        <div class="input-icon">
                            <i class="fas fa-language"></i>
                            <select id="language" name="language" required>
                                <option value="ku" <?php echo (($_POST['language'] ?? '') == 'ku') ? 'selected' : ''; ?>>کوردی</option>
                                <option value="en" <?php echo (($_POST['language'] ?? '') == 'en') ? 'selected' : ''; ?>>English</option>
                                <option value="ar" <?php echo (($_POST['language'] ?? '') == 'ar') ? 'selected' : ''; ?>>العربية</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">تێپەڕەوشە *</label>
                        <div class="input-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" required 
                                   placeholder="تێپەڕەوشە"
                                   minlength="6">
                        </div>
                        <div class="password-strength">
                            <div class="password-strength-bar" id="strength-bar"></div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirm_password">دووبارەکردنەوەی تێپەڕەوشە *</label>
                        <div class="input-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="confirm_password" name="confirm_password" required 
                                   placeholder="تێپەڕەوشە دووبارە بکە">
                        </div>
                    </div>
                    
                    <div class="terms-checkbox">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms">
                            من <a href="privacy.html">مەرجەکانی بەکارهێنان</a> و <a href="privacy.html">سیاسەتی تایبەتمەندی</a> دەخوێنمەوە و ڕازیم بەوان
                        </label>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-user-plus"></i> درووستکردنی هەژمار
                    </button>
                </form>
            </div>
            
            <div class="auth-footer">
                <p>پێشتر هەژمارت هەیە؟ <a href="login.php">چوونەژوورەوە</a></p>
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

        // Password strength checker
        const passwordInput = document.getElementById('password');
        const strengthBar = document.getElementById('strength-bar');
        const confirmInput = document.getElementById('confirm_password');
        
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = 0;
            
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^a-zA-Z0-9]/.test(password)) strength++;
            
            strengthBar.className = 'password-strength-bar';
            
            if (strength <= 2) {
                strengthBar.classList.add('strength-weak');
            } else if (strength <= 4) {
                strengthBar.classList.add('strength-medium');
            } else {
                strengthBar.classList.add('strength-strong');
            }
        });
        
        // Form validation
        document.getElementById('register-form').addEventListener('submit', function(e) {
            const password = passwordInput.value;
            const confirmPassword = confirmInput.value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('تێپەڕەوشەکان یەک نین، تکایە دیارە بکەنەوە');
                return false;
            }
            
            if (password.length < 6) {
                e.preventDefault();
                alert('تێپەڕەوشە دەبێت لەپایین 6 پیت بێت');
                return false;
            }
        });
        
        // Check for registration success message
        <?php if (isset($_GET['registered']) && $_GET['registered'] == 1): ?>
        alert('تۆمارکردن سەرکەوتوو بوو! تکایە چوونەژوورەوە بکە.');
        <?php endif; ?>
    </script>
</body>
</html>
