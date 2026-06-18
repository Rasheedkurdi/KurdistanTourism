<?php
require_once __DIR__ . '/bootstrap.php';

function oauth_providers(): array
{
    return [
        'google' => [
            'name' => 'Google',
            'client_id' => getenv('GOOGLE_OAUTH_CLIENT_ID') ?: '',
            'client_secret' => getenv('GOOGLE_OAUTH_CLIENT_SECRET') ?: '',
            'authorize_url' => 'https://accounts.google.com/o/oauth2/v2/auth',
            'token_url' => 'https://oauth2.googleapis.com/token',
            'tokeninfo_url' => 'https://oauth2.googleapis.com/tokeninfo',
            'scope' => 'openid email profile',
        ],
    ];
}

function oauth_provider(string $provider): ?array
{
    $providers = oauth_providers();
    return $providers[$provider] ?? null;
}

function oauth_provider_is_configured(string $provider): bool
{
    $config = oauth_provider($provider);
    return $config !== null && $config['client_id'] !== '' && $config['client_secret'] !== '';
}

function oauth_redirect_uri(string $provider): string
{
    $base = rtrim(getenv('OAUTH_REDIRECT_BASE_URL') ?: app_url(), '/');
    return $base . '/pages/oauth_callback.php?provider=' . rawurlencode($provider);
}

function oauth_http_post(string $url, array $fields): array
{
    $body = http_build_query($fields, '', '&', PHP_QUERY_RFC3986);
    $context = stream_context_create([
        'http' => [
            'method' => 'POST',
            'header' => "Content-Type: application/x-www-form-urlencoded\r\nAccept: application/json\r\n",
            'content' => $body,
            'ignore_errors' => true,
            'timeout' => 10,
        ],
    ]);

    $response = @file_get_contents($url, false, $context);
    if ($response === false) {
        return [];
    }

    $decoded = json_decode($response, true);
    return is_array($decoded) ? $decoded : [];
}

function oauth_http_get_json(string $url, array $query): array
{
    $separator = strpos($url, '?') === false ? '?' : '&';
    $context = stream_context_create([
        'http' => [
            'method' => 'GET',
            'header' => "Accept: application/json\r\n",
            'ignore_errors' => true,
            'timeout' => 10,
        ],
    ]);

    $response = @file_get_contents($url . $separator . http_build_query($query, '', '&', PHP_QUERY_RFC3986), false, $context);
    if ($response === false) {
        return [];
    }

    $decoded = json_decode($response, true);
    return is_array($decoded) ? $decoded : [];
}

function oauth_google_profile(string $code, string $expectedState): array
{
    $config = oauth_provider('google');
    if (!$config) {
        return ['error' => 'Unsupported sign-in provider.'];
    }

    $token = oauth_http_post($config['token_url'], [
        'code' => $code,
        'client_id' => $config['client_id'],
        'client_secret' => $config['client_secret'],
        'redirect_uri' => oauth_redirect_uri('google'),
        'grant_type' => 'authorization_code',
    ]);

    if (empty($token['id_token'])) {
        return ['error' => 'Google did not return a valid identity token.'];
    }

    $profile = oauth_http_get_json($config['tokeninfo_url'], ['id_token' => $token['id_token']]);
    if (($profile['aud'] ?? '') !== $config['client_id']) {
        return ['error' => 'Google identity token audience is invalid.'];
    }
    if (($profile['iss'] ?? '') !== 'https://accounts.google.com' && ($profile['iss'] ?? '') !== 'accounts.google.com') {
        return ['error' => 'Google identity token issuer is invalid.'];
    }
    if (!empty($profile['exp']) && (int) $profile['exp'] < time()) {
        return ['error' => 'Google identity token expired.'];
    }
    if (!empty($profile['nonce']) && !hash_equals($expectedState, (string) $profile['nonce'])) {
        return ['error' => 'Google identity token nonce is invalid.'];
    }
    if (($profile['email_verified'] ?? '') !== 'true' && ($profile['email_verified'] ?? false) !== true) {
        return ['error' => 'Google account email is not verified.'];
    }
    if (empty($profile['sub']) || empty($profile['email'])) {
        return ['error' => 'Google account profile is incomplete.'];
    }

    return [
        'provider' => 'google',
        'provider_user_id' => (string) $profile['sub'],
        'email' => strtolower((string) $profile['email']),
        'name' => (string) ($profile['name'] ?? $profile['email']),
        'avatar_url' => (string) ($profile['picture'] ?? ''),
    ];
}
