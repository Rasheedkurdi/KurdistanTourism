<?php
session_start();
require_once __DIR__ . '/../config/user_auth.php';

$auth = new UserAuth();
$user = $auth->requireLogin();

$errors = [];
$success = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['update_profile'])) {
        $result = $auth->updateProfile($user['id'], $_POST);
        
        if ($result['success']) {
            $success = $result['message'];
            // Refresh user data
            $user = $auth->getCurrentUser();
        } else {
            $errors = $result['errors'];
        }
    } elseif (isset($_POST['change_password'])) {
        $result = $auth->changePassword($user['id'], $_POST['current_password'], $_POST['new_password']);
        
        if ($result['success']) {
            $success = $result['message'];
        } else {
            $errors = $result['errors'];
        }
    } elseif (isset($_FILES['avatar'])) {
        if ($_FILES['avatar']['error'] === UPLOAD_ERR_OK) {
            $result = $auth->uploadAvatar($user['id'], $_FILES['avatar']);
            
            if ($result['success']) {
                $success = 'Avatar updated successfully';
                // Refresh user data
                $user = $auth->getCurrentUser();
            } else {
                $errors = $result['errors'];
            }
        } else {
            // Better error messages for upload errors
            $uploadErrors = [
                UPLOAD_ERR_INI_SIZE   => 'File too large. Maximum upload size exceeded (php.ini limit).',
                UPLOAD_ERR_FORM_SIZE  => 'File too large. Maximum upload size exceeded (form limit).',
                UPLOAD_ERR_PARTIAL    => 'File was only partially uploaded. Please try again.',
                UPLOAD_ERR_NO_FILE    => 'No file was selected.',
                UPLOAD_ERR_NO_TMP_DIR => 'Server error: Missing temporary folder.',
                UPLOAD_ERR_CANT_WRITE => 'Server error: Failed to write file to disk.',
                UPLOAD_ERR_EXTENSION  => 'Server error: A PHP extension stopped the upload.'
            ];
            $errorCode = $_FILES['avatar']['error'];
            $errorMsg = isset($uploadErrors[$errorCode]) ? $uploadErrors[$errorCode] : 'Unknown upload error (code: ' . $errorCode . ')';
            $errors = [$errorMsg];
        }
    }
}

// Fetch user stats and favorites
$userStats = $auth->getUserStats($user['id']);
$userFavorites = $auth->getUserFavorites($user['id']);

// Fetch recent trips for activity
$recentTrips = [];
try {
    require_once __DIR__ . '/../config/bootstrap.php';
    $pdo = pdo();
    $stmt = $pdo->prepare("SELECT id, title, created_at FROM itineraries WHERE user_id = ? AND status != 'deleted' ORDER BY created_at DESC LIMIT 5");
    $stmt->execute([$user['id']]);
    $recentTrips = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (Exception $e) {
    // Silently fail - trips not critical for profile
}
?>
<!DOCTYPE html>
<html lang="ku" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>پڕۆفایلی <?php echo htmlspecialchars($user['full_name']); ?> - شوێنە گەشتیاریەکانی کوردستان</title>
    
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
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            width: 100%;
            box-sizing: border-box;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 30px;
            text-align: center;
            overflow: hidden;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            margin-bottom: 20px;
            object-fit: cover;
            background: white;
        }
        
        .profile-name {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .profile-info {
            opacity: 0.9;
            margin-bottom: 20px;
        }
        
        .profile-stats {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        
        .stat-item {
            text-align: center;
            min-width: 80px;
            transition: all 0.2s ease;
        }
        .stat-item:hover {
            transform: translateY(-3px);
            opacity: 0.9;
        }
        
        .stat-number {
            font-size: 22px;
            font-weight: 600;
            display: block;
        }
        
        .stat-label {
            font-size: 13px;
            opacity: 0.8;
        }
        
        .profile-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        
        @media (max-width: 768px) {
            .profile-content {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .profile-header {
                padding: 25px 20px;
                border-radius: 15px;
            }
            
            .profile-avatar {
                width: 100px;
                height: 100px;
                border-width: 3px;
            }
            
            .profile-name {
                font-size: 24px;
            }
            
            .profile-stats {
                gap: 20px;
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .stat-item {
                min-width: 80px;
            }
            
            .stat-number {
                font-size: 20px;
            }
            
            .stat-label {
                font-size: 12px;
            }
            
            .profile-section {
                padding: 20px;
                border-radius: 12px;
            }
            
            .section-title {
                font-size: 18px;
                flex-direction: column;
                align-items: flex-start;
                gap: 5px;
            }
            
            .nav-tabs {
                flex-wrap: wrap;
                border-bottom: none;
                gap: 5px;
                margin-bottom: 20px;
            }
            
            .nav-tab {
                padding: 10px 15px;
                font-size: 14px;
                flex: 1 0 calc(50% - 10px);
                text-align: center;
                border: 1px solid #e1e8ed;
                border-radius: 8px;
                margin-bottom: 5px;
            }
            
            .nav-tab.active {
                border-color: #667eea;
            }
            
            .nav-tab.active::after {
                display: none;
            }
            
            .form-group input, .form-group select, .form-group textarea {
                padding: 10px 12px;
                font-size: 14px;
            }
            
            .btn {
                padding: 10px 20px;
                font-size: 14px;
                width: 100%;
                margin-bottom: 10px;
            }
            
            .activity-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
                padding: 12px 0;
            }
            
            .activity-icon {
                width: 35px;
                height: 35px;
                font-size: 14px;
            }
        }
        
        @media (max-width: 480px) {
            .profile-header {
                padding: 20px 15px;
            }
            
            .profile-avatar {
                width: 80px;
                height: 80px;
            }
            
            .profile-name {
                font-size: 20px;
            }
            
            .profile-stats {
                gap: 15px;
            }
            
            .stat-item {
                min-width: 70px;
            }
            
            .stat-number {
                font-size: 18px;
            }
            
            .nav-tab {
                flex: 1 0 100%;
                font-size: 13px;
                padding: 8px 12px;
            }
            
            .profile-section {
                padding: 15px;
            }
        }
        
        .profile-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .section-title i {
            color: #667eea;
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
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e8ed;
            border-radius: 10px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .btn {
            padding: 12px 24px;
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
        }
        
        .btn-secondary:hover {
            background: #e9ecef;
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
        
        .avatar-upload {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .avatar-upload input[type="file"] {
            display: none;
        }
        
        .avatar-upload label {
            display: inline-block;
            padding: 8px 16px;
            background: #667eea;
            color: white;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .avatar-upload label:hover {
            background: #5a6fd8;
        }
        
        .activity-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid #e1e8ed;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #667eea;
        }
        
        .activity-details {
            flex: 1;
        }
        
        .activity-title {
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .activity-time {
            font-size: 12px;
            color: #999;
        }
        
        .nav-tabs {
            display: flex;
            border-bottom: 2px solid #e1e8ed;
            margin-bottom: 30px;
        }
        
        .nav-tab {
            padding: 15px 25px;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            color: #666;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .nav-tab.active {
            color: #667eea;
        }
        
        .nav-tab.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 2px;
            background: #667eea;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }

        /* Dark mode overrides (Default for the app) */
        body:not(.light-mode) .profile-section {
            background: #1e293b;
            color: #f1f5f9;
        }
        body:not(.light-mode) .section-title {
            color: #f1f5f9;
        }
        body:not(.light-mode) .form-group label {
            color: #cbd5e1;
        }
        body:not(.light-mode) .form-group input, 
        body:not(.light-mode) .form-group select, 
        body:not(.light-mode) .form-group textarea {
            background: #0f172a;
            border-color: #334155;
            color: #f1f5f9;
        }
        body:not(.light-mode) .btn-secondary {
            background: #334155;
            color: #f1f5f9;
        }
        body:not(.light-mode) .nav-tab {
            color: #cbd5e1;
        }
        body:not(.light-mode) .nav-tab.active {
            color: #667eea;
        }
        body:not(.light-mode) .activity-item {
            border-color: #334155;
        }
        body:not(.light-mode) .activity-icon {
            background: #334155;
        }
        body:not(.light-mode) .nav-tabs {
            border-color: #334155;
        }

        /* Suggestion form section blocks */
        .suggest-section-block {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 18px;
            margin-bottom: 18px;
        }
        body:not(.light-mode) .suggest-section-block {
            background: #0f172a;
        }
        .suggest-section-title {
            font-size: 0.95em;
            font-weight: 700;
            margin-bottom: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
    </style>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
</head>
<body class="content-page">
    <div class="container">
        <!-- Header -->
        <header class="header">
            <div class="logo">
                <div class="logo-icon">
                    <a href="../index.html" style="text-decoration: none;">
                        <i class="fas fa-mountain"></i>
                    </a>
                </div>
                <div>
                    <h1><span class="kurdish lang-text" data-key="app_title">شوێنە گەشتیاریەکانی کوردستان</span></h1>
                    <p class="english lang-text" data-key="app_subtitle">Kurdish Tourism Locations Map</p>
                </div>
            </div>
            <div class="header-actions">
                <div class="language-switcher">
                    <button class="lang-btn active" data-lang="ku" onclick="changeLanguage('ku')">کوردی</button>
                    <button class="lang-btn" data-lang="en" onclick="changeLanguage('en')">English</button>
                    <button class="lang-btn" data-lang="ar" onclick="changeLanguage('ar')">العربية</button>
                </div>
                <button class="icon-btn" id="theme-toggle" type="button" aria-label="Toggle theme">
                    <i class="fas fa-moon"></i>
                </button>
                <a href="logout.php" class="icon-btn" title="Logout">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
        </header>

        <div class="profile-container">
            <!-- Profile Header -->
            <div class="profile-header">
                <img src="<?php echo !empty($user['avatar']) ? htmlspecialchars($user['avatar']) : 'https://ui-avatars.com/api/?name=' . urlencode($user['full_name']) . '&background=667eea&color=fff&size=120'; ?>" 
                     alt="<?php echo htmlspecialchars($user['full_name']); ?>" class="profile-avatar">
                <h1 class="profile-name"><?php echo htmlspecialchars($user['full_name']); ?></h1>
                <div class="profile-info">
                    <p>@<?php echo htmlspecialchars($user['username']); ?></p>
                    <p><?php echo htmlspecialchars($user['email']); ?></p>
                    <p><span class="lang-text" data-key="member_since">لەگەڵمان بوو لە</span> <?php echo date('Y/m/d', strtotime($user['created_at'])); ?></p>
                </div>
                <div class="profile-stats">
                    <div class="stat-item" onclick="showTab('my-suggestions'); loadMySuggestions()" style="cursor:pointer;">
                        <span class="stat-number"><?php echo $userStats['suggestions']; ?></span>
                        <span class="stat-label lang-text" data-key="suggestions">پێشنیارەکان</span>
                    </div>
                    <div class="stat-item" onclick="showTab('activity')" style="cursor:pointer;">
                        <span class="stat-number"><?php echo $userStats['trips']; ?></span>
                        <span class="stat-label lang-text" data-key="trips">گەشتەکان</span>
                    </div>
                    <div class="stat-item" onclick="showTab('favorites')" style="cursor:pointer;">
                        <span class="stat-number"><?php echo $userStats['favorites']; ?></span>
                        <span class="stat-label lang-text" data-key="favorites">دڵخوازەکان</span>
                    </div>
                </div>
            </div>

            <!-- Navigation Tabs -->
            <div class="nav-tabs">
                <button class="nav-tab active lang-text" data-key="edit_profile_tab" onclick="showTab('edit-profile')">دەستکاریکردنی پڕۆفایل</button>
                <button class="nav-tab lang-text" data-key="security_tab" onclick="showTab('security')">ئاسایشی</button>
                <button class="nav-tab lang-text" data-key="activity_tab" onclick="showTab('activity')">چالاکیەکان</button>
                <button class="nav-tab lang-text" data-key="favorites_tab" onclick="showTab('favorites')">پێشنیارەکان</button>
                <button class="nav-tab lang-text" data-key="suggest_location_tab" onclick="showTab('suggest-location')">پێشنیاری شوێن</button>
                <button class="nav-tab lang-text" data-key="my_suggestions_tab" onclick="showTab('my-suggestions'); loadMySuggestions()">پێشنیارەکانم</button>
            </div>

            <!-- Tab Content -->
            <div class="tab-content active" id="edit-profile">
                <div class="profile-section">
                    <h2 class="section-title">
                        <i class="fas fa-user-edit"></i>
                        <span class="lang-text" data-key="edit_profile_title">دەستکاریکردنی زانیاری پڕۆفایل</span>
                    </h2>
                    
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
                    
                    <form id="avatar-form" method="post" enctype="multipart/form-data">
                        <div class="avatar-upload">
                            <img src="<?php echo !empty($user['avatar']) ? htmlspecialchars($user['avatar']) : 'https://ui-avatars.com/api/?name=' . urlencode($user['full_name']) . '&background=667eea&color=fff&size=80'; ?>" 
                                 alt="Avatar" style="width: 80px; height: 80px; border-radius: 50%; margin-bottom: 10px;">
                            <br>
                            <input type="file" id="avatar" name="avatar" accept="image/*" onchange="this.form.submit()">
                            <label for="avatar">
                                <i class="fas fa-camera"></i> <span class="lang-text" data-key="change_avatar">گۆڕینی وێنە</span>
                            </label>
                        </div>
                    </form>
                    <form method="post">
                        <div class="form-group">
                            <label for="full_name" class="lang-text" data-key="full_name_label">ناوی تەواو</label>
                            <input type="text" id="full_name" name="full_name" 
                                   value="<?php echo htmlspecialchars($user['full_name']); ?>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email" class="lang-text" data-key="email_label">ئیمەیل</label>
                            <input type="email" id="email" name="email" 
                                   value="<?php echo htmlspecialchars($user['email']); ?>" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone" class="lang-text" data-key="phone_label">تەلەفۆن</label>
                            <input type="tel" id="phone" name="phone" 
                                   value="<?php echo htmlspecialchars($user['phone']); ?>"
                                   pattern="^[+]?[0-9]{10,15}$">
                        </div>
                        
                        <div class="form-group">
                            <label for="language" class="lang-text" data-key="language_label">زمان</label>
                            <select id="language" name="language">
                                <option value="ku" <?php echo $user['language'] == 'ku' ? 'selected' : ''; ?>>کوردی</option>
                                <option value="en" <?php echo $user['language'] == 'en' ? 'selected' : ''; ?>>English</option>
                                <option value="ar" <?php echo $user['language'] == 'ar' ? 'selected' : ''; ?>>العربية</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="bio" class="lang-text" data-key="bio_label">دەربارەی من</label>
                            <textarea id="bio" name="bio" placeholder="کەمێک دەربارەی خۆت بنووسە..."><?php echo htmlspecialchars($user['bio'] ?? ''); ?></textarea>
                        </div>
                        
                        <button type="submit" name="update_profile" class="btn btn-primary">
                            <i class="fas fa-save"></i> <span class="lang-text" data-key="save_btn">پاشەکەوتکردن</span>
                        </button>
                    </form>
                </div>
            </div>

            <div class="tab-content" id="security">
                <div class="profile-section">
                    <h2 class="section-title">
                        <i class="fas fa-shield-alt"></i>
                        <span class="lang-text" data-key="change_password_title">گۆڕینی تێپەڕەوشە</span>
                    </h2>
                    
                    <form method="post">
                        <div class="form-group">
                            <label for="current_password" class="lang-text" data-key="current_password_label">تێپەڕەوشەی ئێستا</label>
                            <input type="password" id="current_password" name="current_password" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="new_password" class="lang-text" data-key="new_password_label">تێپەڕەوشەی نوێ</label>
                            <input type="password" id="new_password" name="new_password" required minlength="6">
                        </div>
                        
                        <div class="form-group">
                            <label for="confirm_new_password" class="lang-text" data-key="confirm_password_label">دووبارەکردنەوەی تێپەڕەوشەی نوێ</label>
                            <input type="password" id="confirm_new_password" name="confirm_new_password" required>
                        </div>
                        
                        <button type="submit" name="change_password" class="btn btn-primary">
                            <i class="fas fa-key"></i> <span class="lang-text" data-key="change_password_btn">گۆڕینی تێپەڕەوشە</span>
                        </button>
                    </form>
                    
                    <!-- Delete Account Section -->
                    <div style="margin-top: 40px; padding-top: 30px; border-top: 2px solid #e74c3c;">
                        <h2 class="section-title" style="color: #e74c3c;">
                            <i class="fas fa-exclamation-triangle"></i>
                            <span class="lang-text" data-key="delete_account_title">سڕینەوەی هەژمار</span>
                        </h2>
                        <p class="lang-text" data-key="delete_account_desc" style="color: #666; margin-bottom: 20px;">
                            ئەم کردارە هەژمارەکەت ناکەوێتە سڕینەوە یەکسەر. هەژمارەکەت بۆ 30 ڕۆژ دەهێڵرێتەوە و لەم ماوەیەدا دەتوانی بە چوونەژوورەوە هەژمارەکەت بگەڕێنیتەوە.
                        </p>
                        <button type="button" onclick="confirmDeleteAccount()" class="btn" style="background: #e74c3c; color: white;">
                            <i class="fas fa-trash"></i> <span class="lang-text" data-key="delete_account_btn">سڕینەوەی هەژمار</span>
                        </button>
                    </div>
                </div>
            </div>

            <div class="tab-content" id="activity">
                <div class="profile-section">
                    <h2 class="section-title">
                        <i class="fas fa-history"></i>
                        <span class="lang-text" data-key="recent_activity_title">چالاکیەکانی دوایین</span>
                    </h2>
                    
                    <ul class="activity-list">
                        <?php foreach ($recentTrips as $trip): ?>
                        <li class="activity-item">
                            <div class="activity-icon" style="background: linear-gradient(135deg, #4CAF50, #2E7D32);">
                                <i class="fas fa-route"></i>
                            </div>
                            <div class="activity-details">
                                <div class="activity-title"><?php echo htmlspecialchars($trip['title']); ?></div>
                                <div class="activity-time"><?php echo date('Y/m/d H:i', strtotime($trip['created_at'])); ?></div>
                            </div>
                        </li>
                        <?php endforeach; ?>
                        <li class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-sign-in-alt"></i>
                            </div>
                            <div class="activity-details">
                                <div class="activity-title lang-text" data-key="login_activity">چوونەژوورەوە</div>
                                <div class="activity-time"><?php echo date('Y/m/d H:i', strtotime($user['last_login'] ?? 'now')); ?></div>
                            </div>
                        </li>
                        <li class="activity-item">
                            <div class="activity-icon">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="activity-details">
                                <div class="activity-title lang-text" data-key="register_activity">تۆمارکردن</div>
                                <div class="activity-time"><?php echo date('Y/m/d H:i', strtotime($user['created_at'])); ?></div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="tab-content" id="favorites">
                <div class="profile-section">
                    <h2 class="section-title">
                        <i class="fas fa-heart"></i>
                        <span class="lang-text" data-key="favorites_title">شوێنە پێشنیارکراوەکان</span>
                    </h2>
                    
                    <?php if (empty($userFavorites)): ?>
                    <p class="lang-text" data-key="no_favorites" style="text-align: center; color: #999; padding: 40px 0;">
                        هێشتا هیچ شوێنێک پێشنیار نەکردووە
                    </p>
                    <?php else: ?>
                    <div class="locations-list" style="margin-top: 20px;">
                        <?php foreach ($userFavorites as $loc): ?>
                        <div class="location-item" id="favorite-<?php echo $loc['id']; ?>">
                            <div onclick="window.location.href='../index.html?location=<?php echo $loc['id']; ?>'" style="flex: 1; cursor: pointer;">
                                <h4>
                                    <span class="kurdish"><?php echo htmlspecialchars($loc['name_ku']); ?></span>
                                    <div class="location-rating">
                                        <?php echo number_format($loc['average_rating'], 1); ?> <i class="fas fa-star"></i>
                                    </div>
                                </h4>
                                <div class="location-details">
                                    <i class="fas fa-map-marker-alt"></i> <?php echo htmlspecialchars($loc['name_en']); ?>
                                </div>
                                <div class="location-meta">
                                    <span><i class="fas fa-<?php echo htmlspecialchars($loc['category_icon']); ?>"></i> Category</span>
                                    <span><?php echo htmlspecialchars($loc['gov_name']); ?></span>
                                </div>
                            </div>
                            <button type="button" onclick="event.stopPropagation(); unfavoriteLocation(<?php echo $loc['id']; ?>)" 
                                    style="background: #e74c3c; color: white; border: none; border-radius: 50%; width: 36px; height: 36px; cursor: pointer; margin-right: 10px; flex-shrink: 0;"
                                    title="لابردن لە پێشنیارەکان">
                                <i class="fas fa-heart-broken"></i>
                            </button>
                        </div>
                        <?php endforeach; ?>
                    </div>
                    <?php endif; ?>
                </div>
            </div>

            <!-- Suggest Location Tab -->
            <div class="tab-content" id="suggest-location">
                <div class="profile-section">
                    <h2 class="section-title">
                        <i class="fas fa-map-marker-alt"></i>
                        <span class="lang-text" data-key="suggest_location_title">پێشنیاری شوێنی نوێ</span>
                    </h2>

                    <form id="suggest-location-form" class="profile-form" onsubmit="return submitLocationSuggestion(event)">

                        <!-- Names -->
                        <div class="suggest-section-block" style="border-left:4px solid #667eea;">
                            <div class="suggest-section-title" style="color:#667eea;"><i class="fas fa-font"></i> ناوەکان</div>
                            <div class="form-group">
                                <label class="lang-text" data-key="location_name_ku">ناوی شوێن (کوردی) *</label>
                                <input type="text" name="name_ku" required placeholder="ناوی شوێن بە کوردی">
                            </div>
                            <div class="form-group">
                                <label class="lang-text" data-key="location_name_en">ناوی شوێن (English)</label>
                                <input type="text" name="name_en" placeholder="Location name in English">
                            </div>
                            <div class="form-group">
                                <label>ناوی شوێن (العربية)</label>
                                <input type="text" name="name_ar" placeholder="اسم الموقع بالعربية" dir="rtl">
                            </div>
                        </div>

                        <!-- Classification -->
                        <div class="suggest-section-block" style="border-left:4px solid #27ae60;">
                            <div class="suggest-section-title" style="color:#27ae60;"><i class="fas fa-tags"></i> پۆلێنکردن</div>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px;">
                                <div class="form-group">
                                    <label class="lang-text" data-key="location_gov">هەرێم *</label>
                                    <select name="government_id" required>
                                        <option value="">هەرێم هەڵبژێرە</option>
                                        <?php
                                        try {
                                            $pdo = pdo();
                                            $govs = $pdo->query("SELECT id, name_ku FROM governments ORDER BY name_ku");
                                            foreach ($govs as $gov) {
                                                echo '<option value="' . $gov['id'] . '">' . htmlspecialchars($gov['name_ku']) . '</option>';
                                            }
                                        } catch (Exception $e) {}
                                        ?>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="lang-text" data-key="location_category">جۆری شوێن *</label>
                                    <select name="category_id" required>
                                        <option value="">جۆر هەڵبژێرە</option>
                                        <?php
                                        try {
                                            $pdo = pdo();
                                            $cats = $pdo->query("SELECT id, name_ku FROM categories ORDER BY name_ku");
                                            foreach ($cats as $cat) {
                                                echo '<option value="' . $cat['id'] . '">' . htmlspecialchars($cat['name_ku']) . '</option>';
                                            }
                                        } catch (Exception $e) {}
                                        ?>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <!-- Descriptions -->
                        <div class="suggest-section-block" style="border-left:4px solid #e67e22;">
                            <div class="suggest-section-title" style="color:#e67e22;"><i class="fas fa-align-left"></i> پێناسەکان</div>
                            <div class="form-group">
                                <label class="lang-text" data-key="location_description">پێناسە (کوردی) *</label>
                                <textarea name="description_ku" rows="3" placeholder="پێناسەی شوێن بە کوردی..." required></textarea>
                            </div>
                            <div class="form-group">
                                <label>پێناسە (English)</label>
                                <textarea name="description_en" rows="3" placeholder="Location description in English..."></textarea>
                            </div>
                            <div class="form-group">
                                <label>پێناسە (العربية)</label>
                                <textarea name="description_ar" rows="3" placeholder="وصف الموقع بالعربية..." dir="rtl"></textarea>
                            </div>
                        </div>

                        <!-- Location & Coordinates -->
                        <div class="suggest-section-block" style="border-left:4px solid #e74c3c;">
                            <div class="suggest-section-title" style="color:#e74c3c;"><i class="fas fa-map-pin"></i> شوێن و کۆردینات</div>
                            <div class="form-group">
                                <label class="lang-text" data-key="location_address">ناونیشان</label>
                                <input type="text" name="address" placeholder="ناونیشانی شوێن">
                            </div>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px;">
                                <div class="form-group">
                                    <label class="lang-text" data-key="location_lat">پانی (Latitude) *</label>
                                    <input type="number" step="any" name="lat" id="suggest-lat" placeholder="36.000000" required oninput="updateSuggestMarker()">
                                </div>
                                <div class="form-group">
                                    <label class="lang-text" data-key="location_lng">درێژی (Longitude) *</label>
                                    <input type="number" step="any" name="lng" id="suggest-lng" placeholder="44.000000" required oninput="updateSuggestMarker()">
                                </div>
                            </div>
                            <div class="form-group">
                                <label><i class="fas fa-map"></i> شوێن لە نەخشەدا هەڵبژێرە</label>
                                <div id="suggest-picker-map" style="width:100%; height:250px; border-radius:10px; border:2px solid #e1e8ed; overflow:hidden;"></div>
                                <small style="color:#888; margin-top:5px; display:block;"><i class="fas fa-info-circle"></i> کلیک لەسەر نەخشە بکە بۆ دانانی کۆردینات</small>
                            </div>
                            <div class="form-group">
                                <label class="lang-text" data-key="location_directions">لینکی گووگڵ مەپس</label>
                                <input type="url" name="directions_url" placeholder="https://maps.google.com/...">
                            </div>
                        </div>

                        <!-- Contact Info -->
                        <div class="suggest-section-block" style="border-left:4px solid #9b59b6;">
                            <div class="suggest-section-title" style="color:#9b59b6;"><i class="fas fa-phone-alt"></i> زانیاری پەیوەندی</div>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px;">
                                <div class="form-group">
                                    <label class="lang-text" data-key="location_phone">ژمارەی تەلەفۆن</label>
                                    <input type="tel" name="phone" placeholder="0750 000 0000">
                                </div>
                                <div class="form-group">
                                    <label class="lang-text" data-key="location_email">ئیمەیل</label>
                                    <input type="email" name="email" placeholder="info@example.com">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="lang-text" data-key="location_website">ماڵپەڕ</label>
                                <input type="url" name="website" placeholder="https://example.com">
                            </div>
                        </div>

                        <!-- Extra Details -->
                        <div class="suggest-section-block" style="border-left:4px solid #16a085;">
                            <div class="suggest-section-title" style="color:#16a085;"><i class="fas fa-info-circle"></i> زانیاری زیادە</div>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:15px;">
                                <div class="form-group">
                                    <label class="lang-text" data-key="location_opening_hours">کاتی کارکردن</label>
                                    <input type="text" name="opening_hours" placeholder="8:00 AM – 6:00 PM">
                                </div>
                                <div class="form-group">
                                    <label class="lang-text" data-key="location_ticket_price">نرخی بلێت</label>
                                    <input type="text" name="ticket_price" placeholder="بەخۆڕایی / 5000 IQD">
                                </div>
                            </div>
                        </div>

                        <!-- Image -->
                        <div class="suggest-section-block" style="border-left:4px solid #2980b9;">
                            <div class="suggest-section-title" style="color:#2980b9;"><i class="fas fa-camera"></i> وێنەی شوێن</div>
                            <input type="file" name="location_image" id="location_image" accept="image/*" onchange="previewSuggestionImage(event)">
                            <div id="image-preview" style="margin-top:12px; max-width:220px; display:none;">
                                <img id="preview-img" src="" alt="Preview" style="max-width:100%; border-radius:10px; border:2px solid #667eea;">
                            </div>
                            <small style="display:block; margin-top:8px; color:#888;">وێنەیەکی باشی شوێنەکە باربکە (ئۆپسیۆنال)</small>
                        </div>

                        <div class="form-actions" style="margin-top:20px;">
                            <button type="submit" class="btn btn-primary" style="padding:14px 30px; font-size:1.05em;">
                                <i class="fas fa-paper-plane"></i>
                                <span class="lang-text" data-key="submit_suggestion">ناردنی پێشنیار</span>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- My Suggestions Tab -->
            <div class="tab-content" id="my-suggestions">
                <div class="profile-section">
                    <h2 class="section-title">
                        <i class="fas fa-lightbulb"></i>
                        <span class="lang-text" data-key="my_suggestions_title">پێشنیارەکانم</span>
                    </h2>
                    <div id="my-suggestions-list">
                        <p style="text-align:center;color:#999;padding:30px 0;"><i class="fas fa-spinner fa-spin"></i> چاوەڕوان بکە...</p>
                    </div>
                </div>
            </div>

            <!-- My Photos Tab -->
            <div class="tab-content" id="my-photos">
                <div class="profile-section">
                    <h2 class="section-title">
                        <i class="fas fa-camera"></i>
                        <span class="lang-text" data-key="my_photos_title">وێنەکانم</span>
                    </h2>
                    <div id="my-photos-list">
                        <p style="text-align:center;color:#999;padding:30px 0;"><i class="fas fa-spinner fa-spin"></i> چاوەڕوان بکە...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const profileLanguageData = {
            ku: {
                app_title: 'شوێنە گەشتیاریەکانی کوردستان',
                app_subtitle: 'نەخشەی شوێنە گەشتیاریەکانی کوردستان',
                member_since: 'لەگەڵمان بوو لە',
                suggestions: 'پێشنیارەکان',
                photos: 'وێنەکان',
                my_photos_tab: 'وێنەکانم',
                my_photos_title: 'وێنەکانم',
                trips: 'گەشتەکان',
                edit_profile_tab: 'دەستکاریکردنی پڕۆفایل',
                security_tab: 'ئاسایشی',
                activity_tab: 'چالاکیەکان',
                favorites_tab: 'دڵخوازەکان',
                edit_profile_title: 'دەستکاریکردنی زانیارییەکانی پڕۆفایل',
                change_avatar: 'گۆڕینی وێنە',
                full_name_label: 'ناوی تەواو',
                email_label: 'ئیمەیل',
                phone_label: 'تەلەفۆن',
                language_label: 'زمان',
                bio_label: 'کورتەیەک دەربارەی من',
                save_btn: 'پاشەکەوتکردنی گۆڕانکارییەکان',
                change_password_title: 'گۆڕینی تێپەڕەوشە',
                current_password_label: 'تێپەڕەوشەی ئێستا',
                new_password_label: 'تێپەڕەوشەی نوێ',
                confirm_password_label: 'دووبارەکردنەوەی تێپەڕەوشەی نوێ',
                change_password_btn: 'گۆڕینی تێپەڕەوشە',
                recent_activity_title: 'دوایین چالاکییەکان',
                login_activity: 'چوونەژوورەوە',
                register_activity: 'تۆمارکردن',
                favorites: 'دڵخوازەکان',
                favorites_title: 'شوێنە دڵخوازەکان',
                no_favorites: 'تائێستا هیچ شوێنێکت بۆ لیستی دڵخوازەکان زیاد نەکردووە',
                password_mismatch: 'تێپەڕەوشەکان یەک نین، تکایە دیارە بکەنەوە',
                suggest_location_tab: 'پێشنیاری شوێن',
                suggest_location_title: 'پێشنیاری شوێنی نوێ',
                location_name_ku: 'ناوی شوێن (بە کوردی)',
                location_name_en: 'ناوی شوێن (English)',
                location_gov: 'پارێزگا',
                location_category: 'پۆلی شوێن',
                location_description: 'تایبەتمەندی و زانیاری دەربارەی شوێن',
                location_lat: 'پانی (Latitude)',
                location_lng: 'درێژی (Longitude)',
                location_address: 'ناونیشان',
                location_phone: 'ژمارەی تەلەفۆن',
                location_image: 'وێنەی شوێنەکە',
                submit_suggestion: 'ناردنی پێشنیار',
                delete_account_title: 'سڕینەوەی هەژمار',
                delete_account_desc: 'ئاگاداربە! سڕینەوەی هەژمار نابێتە هۆی سڕینەوەی دەستبەجێ. هەژمارەکەت بۆ ماوەی ٣٠ ڕۆژ دەمێنێتەوە و لەو ماوەیەدا دەتوانیت بە چوونەژوورەوە بگەڕێنیتەوە.',
                delete_account_btn: 'سڕینەوەی هەژمار'
            },
            en: {
                app_title: 'Kurdish Tourism Locations',
                app_subtitle: 'Kurdish Tourism Locations Map',
                member_since: 'Member since',
                suggestions: 'Suggestions',
                photos: 'Photos',
                my_photos_tab: 'My Photos',
                my_photos_title: 'My Photos',
                trips: 'Trips',
                edit_profile_tab: 'Edit Profile',
                security_tab: 'Security',
                activity_tab: 'Activity',
                favorites_tab: 'Favorites',
                edit_profile_title: 'Edit Profile Information',
                change_avatar: 'Change Avatar',
                full_name_label: 'Full Name',
                email_label: 'Email',
                phone_label: 'Phone',
                language_label: 'Language',
                bio_label: 'About Me',
                save_btn: 'Save Changes',
                change_password_title: 'Change Password',
                current_password_label: 'Current Password',
                new_password_label: 'New Password',
                confirm_password_label: 'Confirm New Password',
                change_password_btn: 'Change Password',
                recent_activity_title: 'Recent Activity',
                login_activity: 'Logged In',
                register_activity: 'Registered',
                favorites: 'Favorites',
                favorites_title: 'Favorite Locations',
                no_favorites: 'You have not added any favorite locations yet',
                password_mismatch: 'Passwords do not match, please re-enter',
                suggest_location_tab: 'Suggest Location',
                my_suggestions_tab: 'My Suggestions',
                my_suggestions_title: 'My Submitted Suggestions',
                suggest_location_title: 'Suggest New Location',
                location_name_ku: 'Location Name (Kurdish)',
                location_name_en: 'Location Name (English)',
                location_gov: 'Governorate',
                location_category: 'Category',
                location_description: 'Description',
                location_lat: 'Latitude',
                location_lng: 'Longitude',
                location_address: 'Address',
                location_phone: 'Phone Number',
                location_image: 'Location Image',
                submit_suggestion: 'Submit Suggestion',
                delete_account_title: 'Delete Account',
                delete_account_desc: 'This action will not delete your account immediately. Your account will be kept for 30 days and during this time you can restore it by logging in.',
                delete_account_btn: 'Delete Account'
            },
            ar: {
                app_title: 'مواقع السياحة الكردية',
                app_subtitle: 'خريطة مواقع السياحة الكردية',
                member_since: 'عضو منذ',
                suggestions: 'اقتراحات',
                photos: 'صور',
                my_photos_tab: 'صوري',
                my_photos_title: 'صوري',
                trips: 'رحلات',
                edit_profile_tab: 'تعديل الملف الشخصي',
                security_tab: 'الأمان',
                activity_tab: 'النشاط',
                favorites_tab: 'المفضلة',
                edit_profile_title: 'تعديل معلومات الملف الشخصي',
                change_avatar: 'تغيير الصورة',
                full_name_label: 'الاسم الكامل',
                email_label: 'البريد الإلكتروني',
                phone_label: 'رقم الهاتف',
                language_label: 'اللغة',
                bio_label: 'نبذة عني',
                save_btn: 'حفظ التغييرات',
                change_password_title: 'تغيير كلمة المرور',
                current_password_label: 'كلمة المرور الحالية',
                new_password_label: 'كلمة المرور الجديدة',
                confirm_password_label: 'تأكيد كلمة المرور الجديدة',
                change_password_btn: 'تغيير كلمة المرور',
                recent_activity_title: 'النشاط الأخير',
                login_activity: 'تسجيل الدخول',
                register_activity: 'تم التسجيل',
                favorites: 'المفضلة',
                favorites_title: 'المواقع المفضلة',
                no_favorites: 'لم تقم بإضافة أي مواقع مفضلة بعد',
                password_mismatch: 'كلمات المرور غير متطابقة',
                suggest_location_tab: 'اقتراح موقع',
                suggest_location_title: 'اقتراح موقع جديد',
                location_name_ku: 'اسم الموقع (كردي)',
                location_name_en: 'اسم الموقع (English)',
                location_gov: 'المحافظة',
                location_category: 'الفئة',
                location_description: 'الوصف',
                location_lat: 'خط العرض',
                location_lng: 'خط الطول',
                location_address: 'العنوان',
                location_phone: 'رقم الهاتف',
                location_image: 'صورة الموقع',
                submit_suggestion: 'إرسال الاقتراح',
                delete_account_title: 'حذف الحساب',
                delete_account_desc: 'لن يؤدي هذا الإجراء إلى حذف حسابك على الفور. سيتم الاحتفاظ بحسابك لمدة 30 يومًا وخلال هذا الوقت يمكنك استعادته عن طريق تسجيل الدخول.',
                delete_account_btn: 'حذف الحساب'
            }
        };

        function showTab(tabId) {
            // Hide all tabs
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Remove active class from all nav tabs
            document.querySelectorAll('.nav-tab').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Show selected tab
            document.getElementById(tabId).classList.add('active');
            
            // Add active class to clicked nav tab
            event.target.classList.add('active');

            // Init suggestion map when that tab is opened
            if (tabId === 'suggest-location') {
                setTimeout(initSuggestMap, 150);
            }
        }
        
        // Password confirmation validation
        const pwdForm = document.querySelector('button[name="change_password"]')?.closest('form');
        if (pwdForm) {
            pwdForm.addEventListener('submit', function(e) {
                const newPassword = document.getElementById('new_password').value;
                const confirmNewPassword = document.getElementById('confirm_new_password').value;
                
                if (newPassword !== confirmNewPassword) {
                    e.preventDefault();
                    alert(profileLanguageData[document.documentElement.lang].password_mismatch);
                    return false;
                }
            });
        }
        
        // Theme toggle
        document.getElementById('theme-toggle').addEventListener('click', function () {
            document.body.classList.toggle('light-mode');
            const isLight = document.body.classList.contains('light-mode');
            localStorage.setItem('tourism_theme', isLight ? 'light' : 'dark');
            const icon = this.querySelector('i');
            if (isLight) {
                icon.classList.remove('fa-moon');
                icon.classList.add('fa-sun');
            } else {
                icon.classList.remove('fa-sun');
                icon.classList.add('fa-moon');
            }
        });
        
        // Simple language switching
        function changeLanguage(lang) {
            localStorage.setItem('tourism_language', lang);
            document.querySelectorAll('.lang-btn').forEach(btn => {
                btn.classList.remove('active');
                if (btn.dataset.lang === lang) btn.classList.add('active');
            });
            
            document.documentElement.lang = lang;
            document.documentElement.dir = lang === 'en' ? 'ltr' : 'rtl';
            
            document.querySelectorAll('[data-key]').forEach(element => {
                const key = element.getAttribute('data-key');
                if (profileLanguageData[lang] && profileLanguageData[lang][key]) {
                    if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
                        element.placeholder = profileLanguageData[lang][key];
                    } else {
                        element.textContent = profileLanguageData[lang][key];
                    }
                }
            });
        }

        // Initialize language and theme
        document.addEventListener('DOMContentLoaded', function () {
            // Load language
            const savedLang = localStorage.getItem('tourism_language') || 'ku';
            changeLanguage(savedLang);

            // Load theme
            const savedTheme = localStorage.getItem('tourism_theme') || 'dark';
            if (savedTheme === 'light') {
                document.body.classList.add('light-mode');
                const themeIcon = document.querySelector('#theme-toggle i');
                if (themeIcon) {
                    themeIcon.classList.remove('fa-moon');
                    themeIcon.classList.add('fa-sun');
                }
            }
        });
        
        // Preview image before upload
        function previewSuggestionImage(event) {
            const file = event.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('preview-img').src = e.target.result;
                    document.getElementById('image-preview').style.display = 'block';
                };
                reader.readAsDataURL(file);
            }
        }
        
        // Submit location suggestion with image
        async function submitLocationSuggestion(event) {
            event.preventDefault();
            
            const form = document.getElementById('suggest-location-form');
            const formData = new FormData(form);
            const data = Object.fromEntries(formData.entries());
            
            // Add user info
            data.suggested_by = <?php echo $user['id']; ?>;
            data.status = 'pending';
            
            // Handle image upload
            const imageInput = document.getElementById('location_image');
            if (imageInput.files && imageInput.files[0]) {
                const reader = new FileReader();
                reader.onload = async function(e) {
                    data.image_base64 = e.target.result;
                    await sendSuggestion(data);
                };
                reader.readAsDataURL(imageInput.files[0]);
            } else {
                await sendSuggestion(data);
            }
            
            return false;
        }
        
        async function sendSuggestion(data) {
            try {
                const response = await fetch('../api.php?endpoint=suggest_location', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                
                const result = await response.json();
                const lang = document.documentElement.lang;
                
                if (result.success) {
                    alert(lang === 'ku' ? 'پێشنیارەکەت بە سەرکەوتوویی نێردرا!' : 
                         lang === 'ar' ? 'تم إرسال اقتراحك بنجاح!' : 
                         'Your suggestion was submitted successfully!');
                    document.getElementById('suggest-location-form').reset();
                    document.getElementById('image-preview').style.display = 'none';
                } else {
                    alert(result.error || (lang === 'ku' ? 'هەڵە ڕوویدا' : 'Error occurred'));
                }
            } catch (error) {
                console.error('Error submitting suggestion:', error);
                alert('Error submitting suggestion');
            }
        }
        
        // Unfavorite location
        function unfavoriteLocation(locationId) {
            const lang = document.documentElement.lang;
            const messages = {
                ku: {
                    confirm: 'دڵنیایت لە لابردنی ئەم شوێنە لە پێشنیارەکان؟',
                    success: 'شوێنە لە پێشنیارەکان لابرا',
                    error: 'هەڵە ڕوویدا',
                    not_found: 'تۆمار نەبوویت'
                },
                en: {
                    confirm: 'Are you sure you want to remove this location from your favorites?',
                    success: 'Location removed from favorites',
                    error: 'Error removing from favorites'
                },
                ar: {
                    confirm: 'هل أنت متأكد أنك تريد إزالة هذا الموقع من المفضلة؟',
                    success: 'تم إزالة الموقع من المفضلة',
                    error: 'خطأ في إزالة من المفضلة'
                }
            };
            
            if (!confirm(messages[lang].confirm)) return;
            
            fetch('../api.php?endpoint=favorites', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ location_id: locationId })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Remove the item from the DOM
                    const item = document.getElementById('favorite-' + locationId);
                    if (item) {
                        item.style.transition = 'all 0.3s ease';
                        item.style.opacity = '0';
                        item.style.transform = 'translateX(100px)';
                        setTimeout(() => item.remove(), 300);
                    }
                    
                    // Check if no more favorites
                    const remaining = document.querySelectorAll('.location-item[id^="favorite-"]');
                    if (remaining.length <= 1) {
                        setTimeout(() => {
                            const container = document.querySelector('.locations-list');
                            if (container) {
                                container.innerHTML = '<p style="text-align: center; color: #999; padding: 40px 0;">' + profileLanguageData[lang].no_favorites + '</p>';
                            }
                        }, 300);
                    }
                    
                    alert(messages[lang].success);
                } else {
                    alert(data.error || messages[lang].error);
                }
            })
            .catch(err => {
                alert(messages[lang].error);
            });
        }
        
        // Delete account confirmation
        function confirmDeleteAccount() {
            const lang = document.documentElement.lang;
            const messages = {
                ku: {
                    confirm: 'دڵنیایت کە دەتەوێت هەژمارەکەت بسڕیتەوە؟\n\nئەم کردارە هەژمارەکەت ناکەوێتە سڕینەوە یەکسەر. 30 ڕۆژ کاتت هەیە بۆ گەڕانەوە.',
                    success: 'هەژمارەکەت نیشانکرا بۆ سڕینەوە. 30 ڕۆژ کاتت هەیە بۆ چوونەژوورەوە و هەڵوەشاندنەوەی.',
                    error: 'هەڵە ڕوویدا لە سڕینەوەی هەژمار'
                },
                en: {
                    confirm: 'Are you sure you want to delete your account?\n\nYour account will not be deleted immediately. You have 30 days to return.',
                    success: 'Your account has been marked for deletion. You have 30 days to login and cancel.',
                    error: 'Error deleting account'
                },
                ar: {
                    confirm: 'هل أنت متأكد أنك تريد حذف حسابك؟\n\nلن يتم حذف حسابك على الفور. لديك 30 يومًا للعودة.',
                    success: 'تم وضع علامة على حسابك للحذف. لديك 30 يومًا لتسجيل الدخول والإلغاء.',
                    error: 'خطأ في حذف الحساب'
                }
            };
            
            if (confirm(messages[lang].confirm)) {
                fetch('../api.php?endpoint=user_profile', {
                    method: 'DELETE',
                    headers: { 'Content-Type': 'application/json' }
                })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        alert(messages[lang].success);
                        window.location.href = 'logout.php';
                    } else {
                        alert(data.error || messages[lang].error);
                    }
                })
                .catch(err => {
                    alert(messages[lang].error);
                });
            }
        }
        // Load user's own suggestions with statuses
        async function loadMySuggestions() {
            const container = document.getElementById('my-suggestions-list');
            const lang = document.documentElement.lang;
            container.innerHTML = '<p style="text-align:center;color:#999;padding:30px 0;"><i class="fas fa-spinner fa-spin"></i></p>';
            
            try {
                const res = await fetch('../api.php?endpoint=user_suggestions');
                const data = await res.json();
                
                if (!data.success || !data.suggestions || data.suggestions.length === 0) {
                    container.innerHTML = `<p style="text-align:center;color:#999;padding:40px 0;">
                        ${lang === 'en' ? 'No suggestions submitted yet.' : lang === 'ar' ? 'لم تقدم أي اقتراحات بعد.' : 'هێشتا هیچ پێشنیارێک نەنێردووە.'}
                    </p>`;
                    return;
                }
                
                container.innerHTML = data.suggestions.map(s => {
                    const statusStyles = {
                        pending:  { bg: '#fff3cd', border: '#f39c12', color: '#856404', icon: 'fa-clock',      label: { ku: 'چاوەڕوانکراو', en: 'Pending',  ar: 'قيد الانتظار' } },
                        approved: { bg: '#d1e7dd', border: '#27ae60', color: '#155724', icon: 'fa-check-circle', label: { ku: 'پەسەندکرا',   en: 'Approved', ar: 'مقبول' } },
                        rejected: { bg: '#f8d7da', border: '#e74c3c', color: '#721c24', icon: 'fa-times-circle', label: { ku: 'ڕەتکرایەوە', en: 'Rejected', ar: 'مرفوض' } }
                    };
                    const st = statusStyles[s.status] || statusStyles.pending;
                    const statusLabel = st.label[lang] || st.label.en;
                    
                    const adminNote = s.admin_note && s.status === 'rejected'
                        ? `<div style="margin-top:8px;padding:8px 10px;background:#fff;border-left:3px solid #e74c3c;border-radius:4px;font-size:0.85em;color:#666;">
                            <i class="fas fa-comment-alt"></i> <strong>${lang === 'en' ? 'Admin note:' : lang === 'ar' ? 'ملاحظة المشرف:' : 'تێبینی بەڕێوەبەر:'}</strong> ${s.admin_note}
                           </div>` : '';
                    
                    const reviewedInfo = s.reviewed_at && s.status !== 'pending'
                        ? `<span style="font-size:0.8em;color:#888;"> · ${new Date(s.reviewed_at).toLocaleDateString()}</span>` : '';
                    
                    const imgHtml = s.image_path
                        ? `<img src="${s.image_path}" style="width:60px;height:60px;object-fit:cover;border-radius:8px;flex-shrink:0;">`
                        : `<div style="width:60px;height:60px;background:#f0f0f0;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0;"><i class="fas fa-image" style="color:#ccc;font-size:1.4em;"></i></div>`;
                    
                    return `
                        <div style="display:flex;gap:15px;align-items:flex-start;padding:15px;border:1px solid ${st.border};background:${st.bg};border-radius:12px;margin-bottom:12px;">
                            ${imgHtml}
                            <div style="flex:1;min-width:0;">
                                <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:4px;">
                                    <strong style="font-size:1em;">${s.name_ku}</strong>
                                    ${s.name_en ? `<span style="color:#888;font-size:0.85em;">${s.name_en}</span>` : ''}
                                    <span style="margin-left:auto;background:${st.border};color:white;padding:2px 10px;border-radius:20px;font-size:0.78em;white-space:nowrap;">
                                        <i class="fas ${st.icon}"></i> ${statusLabel}
                                    </span>
                                </div>
                                <div style="font-size:0.82em;color:#777;margin-bottom:4px;">
                                    <i class="fas fa-map-marker-alt"></i> ${s.lat}, ${s.lng}
                                    &nbsp;·&nbsp;
                                    <i class="fas fa-calendar"></i> ${new Date(s.created_at).toLocaleDateString()}
                                    ${reviewedInfo}
                                </div>
                                ${adminNote}
                            </div>
                        </div>
                    `;
                }).join('');
                
            } catch (err) {
                container.innerHTML = `<p style="text-align:center;color:#e74c3c;padding:30px 0;"><i class="fas fa-exclamation-triangle"></i> Error loading suggestions</p>`;
            }
        }
        // Load user's uploaded photos
        async function loadMyPhotos() {
            const container = document.getElementById('my-photos-list');
            const lang = document.documentElement.lang;
            container.innerHTML = '<p style="text-align:center;color:#999;padding:30px 0;"><i class="fas fa-spinner fa-spin"></i></p>';
            
            try {
                const res = await fetch(`../api.php?endpoint=photos&user_id=<?php echo $user['id']; ?>`);
                const data = await res.json();
                
                if (!data.success || !data.photos || data.photos.length === 0) {
                    container.innerHTML = `<p style="text-align:center;color:#999;padding:40px 0;">
                        ${lang === 'en' ? 'No photos uploaded yet.' : lang === 'ar' ? 'لم تقم بتحميل أي صور بعد.' : 'هێشتا هیچ وێنەیەک بارنەکراوە.'}
                    </p>`;
                    return;
                }
                
                container.innerHTML = data.photos.map(p => {
                    const date = new Date(p.created_at).toLocaleDateString();
                    const locationName = p.location_name ? p.location_name : (lang === 'en' ? 'Unknown location' : lang === 'ar' ? 'موقع غير معروف' : 'شوێنی نەناسراو');
                    return `
                        <div style="display:flex;gap:15px;align-items:flex-start;padding:15px;border:1px solid #e1e8ed;background:#f8f9fa;border-radius:12px;margin-bottom:12px;">
                            <img src="${p.image_path}" style="width:80px;height:80px;object-fit:cover;border-radius:8px;flex-shrink:0;" alt="${p.title || ''}">
                            <div style="flex:1;min-width:0;">
                                <div style="display:flex;align-items:center;gap:8px;flex-wrap:wrap;margin-bottom:4px;">
                                    <strong style="font-size:1em;">${p.title || (lang === 'en' ? 'Untitled' : lang === 'ar' ? 'بدون عنوان' : 'بێ ناو')}</strong>
                                    <span style="margin-left:auto;background:#667eea;color:white;padding:2px 10px;border-radius:20px;font-size:0.78em;white-space:nowrap;">
                                        <i class="fas fa-heart"></i> ${p.likes_count}
                                    </span>
                                </div>
                                <div style="font-size:0.82em;color:#777;margin-bottom:4px;">
                                    <i class="fas fa-map-marker-alt"></i> ${locationName}
                                    &nbsp;·&nbsp;
                                    <i class="fas fa-calendar"></i> ${date}
                                    &nbsp;·&nbsp;
                                    <i class="fas fa-eye"></i> ${p.views_count} ${lang === 'en' ? 'views' : lang === 'ar' ? 'مشاهدة' : 'بینین'}
                                </div>
                                ${p.description ? `<p style="font-size:0.9em;color:#555;margin-top:8px;">${p.description}</p>` : ''}
                            </div>
                        </div>
                    `;
                }).join('');
                
            } catch (err) {
                console.error('Error loading photos:', err);
                container.innerHTML = `<p style="text-align:center;color:#e74c3c;padding:30px 0;"><i class="fas fa-exclamation-triangle"></i> ${lang === 'en' ? 'Error loading photos' : lang === 'ar' ? 'خطأ في تحميل الصور' : 'هەڵە لە بارکردنی وێنەکان'}</p>`;
            }
        }
        // ── Suggestion mini-map picker ──────────────────────────────────
        let _suggestMap = null, _suggestMarker = null;

        function initSuggestMap() {
            if (_suggestMap) { _suggestMap.invalidateSize(); return; }
            const el = document.getElementById('suggest-picker-map');
            if (!el || typeof L === 'undefined') return;
            _suggestMap = L.map(el, { scrollWheelZoom: false }).setView([36.8665, 43.0], 8);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '© OpenStreetMap',
                maxZoom: 19
            }).addTo(_suggestMap);
            _suggestMap.on('click', function(e) {
                const lat = +e.latlng.lat.toFixed(7);
                const lng = +e.latlng.lng.toFixed(7);
                document.getElementById('suggest-lat').value = lat;
                document.getElementById('suggest-lng').value = lng;
                placeSuggestMarker(lat, lng);
            });
            setTimeout(() => _suggestMap.invalidateSize(), 200);
        }

        function placeSuggestMarker(lat, lng) {
            if (!_suggestMap) return;
            if (_suggestMarker) { _suggestMarker.setLatLng([lat, lng]); }
            else { _suggestMarker = L.marker([lat, lng]).addTo(_suggestMap); }
            _suggestMap.setView([lat, lng], Math.max(_suggestMap.getZoom(), 13));
        }

        function updateSuggestMarker() {
            const lat = parseFloat(document.getElementById('suggest-lat').value);
            const lng = parseFloat(document.getElementById('suggest-lng').value);
            if (isFinite(lat) && isFinite(lng) && lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
                placeSuggestMarker(lat, lng);
            }
        }


    </script>
</body>
</html>
