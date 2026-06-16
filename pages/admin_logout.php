<?php
require_once __DIR__ . '/../config/admin_auth.php';

$auth = new AdminAuth();
$auth->logout();

header('Location: admin_login.php');
exit();
?>