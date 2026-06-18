# KurdistanTourism

## Google sign-in setup

The app supports password login plus Google OAuth sign-in. Create OAuth credentials in Google Cloud Console and configure these environment variables on the server:

```bash
export APP_URL="https://your-domain.example"
export GOOGLE_OAUTH_CLIENT_ID="your-google-client-id"
export GOOGLE_OAUTH_CLIENT_SECRET="your-google-client-secret"
```

Add this authorized redirect URI to the Google OAuth client:

```text
https://your-domain.example/pages/oauth_callback.php?provider=google
```

For local development, use the same variables with `APP_URL=http://127.0.0.1:8000` and add `http://127.0.0.1:8000/pages/oauth_callback.php?provider=google` as an authorized redirect URI.

## Security defaults

- Sessions use HTTP-only, same-site, strict cookie mode.
- Public forms use CSRF tokens.
- Login forms include session-based throttling.
- Security headers restrict framing, MIME sniffing, referrers, and sensitive browser permissions.
- Uploaded images are validated by MIME type and stored with random file names.
