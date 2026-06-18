<?php
require_once __DIR__ . '/../config/oauth.php';

$provider = strtolower(trim($_GET['provider'] ?? 'google'));
$config = oauth_provider($provider);

if (!$config) {
    header('Location: login.php?oauth_error=' . rawurlencode('Unsupported sign-in provider.'));
    exit;
}

if (!oauth_provider_is_configured($provider)) {
    header('Location: login.php?oauth_error=' . rawurlencode($config['name'] . ' sign-in is not configured yet.'));
    exit;
}

$state = bin2hex(random_bytes(32));
$_SESSION['oauth_state'] = [
    'provider' => $provider,
    'state' => $state,
    'nonce' => $state,
    'created_at' => time(),
];

$params = [
    'client_id' => $config['client_id'],
    'redirect_uri' => oauth_redirect_uri($provider),
    'response_type' => 'code',
    'scope' => $config['scope'],
    'state' => $state,
    'nonce' => $state,
    'prompt' => 'select_account',
];

header('Location: ' . $config['authorize_url'] . '?' . http_build_query($params, '', '&', PHP_QUERY_RFC3986));
exit;
