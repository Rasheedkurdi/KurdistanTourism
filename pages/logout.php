<?php
session_start();
require_once __DIR__ . '/../config/user_auth.php';

$auth = new UserAuth();
$auth->logout();

header('Location: ../index.html');
exit;
?>
