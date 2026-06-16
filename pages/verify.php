<?php
require_once __DIR__ . '/../config/user_auth.php';

$email = $_GET['email'] ?? '';
$auth = new UserAuth();

// If already logged in, redirect to profile
if ($auth->getCurrentUser()) {
    header('Location: profile.php');
    exit;
}

$error = '';
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_csrf_token();
    $code = trim($_POST['code'] ?? '');
    $email = trim($_POST['email'] ?? '');
    
    if (empty($code) || empty($email)) {
        $error = 'Please enter both email and verification code';
    } else {
        $result = $auth->verifyEmail($email, $code);
        if ($result['success']) {
            $success = 'Email verified successfully! You can now log in.';
        } else {
            $error = $result['error'] ?? 'Invalid verification code';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>دڵنیابوونەوەی ئیمەیڵ - Email Verification</title>
    
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
        .verify-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }
        
        .verify-card {
            background: white;
            border-radius: 16px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        
        .verify-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .verify-icon {
            font-size: 48px;
            color: #667eea;
            margin-bottom: 15px;
        }
        
        .verify-header h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }
        
        .verify-header p {
            color: #666;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn-primary {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
        }
        
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-error {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        
        .alert-success {
            background: #efe;
            color: #3a3;
            border: 1px solid #cfc;
        }
        
        .back-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="verify-container">
        <div class="verify-card">
            <div class="verify-header">
                <div class="verify-icon">
                    <i class="fas fa-envelope-open-text"></i>
                </div>
                <h1>دڵنیابوونەوەی ئیمەیڵ</h1>
                <p>Email Verification</p>
            </div>
            
            <?php if ($error): ?>
                <div class="alert alert-error"><?php echo htmlspecialchars($error); ?></div>
            <?php endif; ?>
            
            <?php if ($success): ?>
                <div class="alert alert-success"><?php echo htmlspecialchars($success); ?></div>
                <div style="text-align: center; margin-top: 20px;">
                    <a href="login.php" class="btn btn-primary" style="display: inline-block; text-decoration: none; width: auto; padding: 12px 30px;">
                        <i class="fas fa-sign-in-alt"></i> چوونەژوورەوە / Login
                    </a>
                </div>
            <?php else: ?>
                <form method="POST" action="">
                    <?php echo csrf_input(); ?>
                    <div class="form-group">
                        <label for="email">ئیمەیڵ / Email</label>
                        <input type="email" id="email" name="email" value="<?php echo htmlspecialchars($email); ?>" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="code">کۆدی دڵنیابوونەوە / Verification Code</label>
                        <input type="text" id="code" name="code" placeholder="Enter 6-digit code" required maxlength="10">
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-check-circle"></i> دڵنیابوونەوە / Verify
                    </button>
                </form>
            <?php endif; ?>
            
            <div class="back-link">
                <a href="../index.html">
                    <i class="fas fa-arrow-left"></i> گەڕانەوە بۆ سەرەکی / Back to Home
                </a>
            </div>
        </div>
    </div>
</body>
</html>
