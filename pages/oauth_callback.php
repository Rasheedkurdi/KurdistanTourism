<?php
require_once __DIR__ . '/../config/oauth.php';
require_once __DIR__ . '/../config/user_auth.php';

$provider = strtolower(trim($_GET['provider'] ?? 'google'));
$state = (string) ($_GET['state'] ?? '');
$code = (string) ($_GET['code'] ?? '');
$error = (string) ($_GET['error'] ?? '');
$sessionState = $_SESSION['oauth_state'] ?? [];

function oauth_finish_with_error(string $message): void
{
    unset($_SESSION['oauth_state']);
    header('Location: login.php?oauth_error=' . rawurlencode($message));
    exit;
}

if ($error !== '') {
    oauth_finish_with_error('Sign-in was cancelled or denied.');
}

if ($code === '' || $state === '') {
    oauth_finish_with_error('Missing sign-in response from provider.');
}

if (!is_array($sessionState)
    || ($sessionState['provider'] ?? '') !== $provider
    || empty($sessionState['state'])
    || !hash_equals((string) $sessionState['state'], $state)
    || (int) ($sessionState['created_at'] ?? 0) < time() - 600
) {
    oauth_finish_with_error('Sign-in session expired. Please try again.');
}

if ($provider !== 'google') {
    oauth_finish_with_error('Unsupported sign-in provider.');
}

$profile = oauth_google_profile($code, (string) ($sessionState['nonce'] ?? ''));
if (!empty($profile['error'])) {
    oauth_finish_with_error($profile['error']);
}

$auth = new UserAuth();
$result = $auth->loginWithOAuthProfile($profile);
unset($_SESSION['oauth_state']);

if (!$result['success']) {
    oauth_finish_with_error(implode(' ', $result['errors'] ?? ['Could not complete social sign-in.']));
}

header('Location: ../index.html');
exit;
