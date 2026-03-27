# Invoice Hub

Invoice Hub is a FastAPI + React application for invoice ingestion, review, and admin operations.

## What changed in this version

- Production auth is **SSO-first** (NiFo/TYN cookie validation).
- Business APIs are protected on backend with role checks.
- Frontend auth bootstraps from `GET /auth/me` (not local storage).
- Local username/password login is available only when `ALLOW_LOCAL_LOGIN=true`.
- Single shared env file: `invoice/.env`.
- Mindee import compatibility added for Python 3.8 environments where `ClientV2` is unavailable.
- Primary UI blue updated to `#0070C0`.

## Authentication model

### Production

1. User logs in on NiFo/TYN.
2. Shared SSO cookie is sent to Invoice backend.
3. Backend validates cookie using central endpoint (`SSO_VALIDATE_URL`).
4. Backend maps central email to local `users` table.
5. If no local user exists, backend returns `403`.

### Local development fallback

- Set `ALLOW_LOCAL_LOGIN=true` (and `VITE_ALLOW_LOCAL_LOGIN=true`) to enable `/login` page and `/auth/login`.
- Keep this disabled in production.

## Required `/auth/me` contract

`GET /auth/me`

- `200`: authenticated + authorized
- `401`: not logged in centrally
- `403`: logged in centrally but not onboarded locally

Sample success:

```json
{
  "authenticated": true,
  "authorized": true,
  "user": {
    "email": "user@company.com",
    "name": "Ravi",
    "role": "admin"
  }
}
```

## Single `.env` usage

Use only one env file at:

- `invoice/.env`

### Minimum env keys

```env
# Frontend
VITE_SSO_LOGIN_URL=/auth/sso/login
VITE_SSO_LOGOUT_URL=/auth/sso/logout
VITE_ALLOW_LOCAL_LOGIN=false

# Backend auth
SSO_ENABLED=true
SSO_LOGIN_URL=https://<central>/login
SSO_VALIDATE_URL=https://<central>/api/sso/me
SSO_COOKIE_NAME=sso_session
SSO_LOGOUT_URL=https://<central>/logout
ALLOW_LOCAL_LOGIN=false

# DB (Neon recommended)
DATABASE_URL=postgresql://<user>:<password>@<host>/<db>?sslmode=require

# Local DB fallback (used only if DATABASE_URL is empty)
DB_USER=postgres
DB_PASSWORD=postgres123
DB_HOST=localhost
DB_PORT=5432
DB_NAME=invoice
```

## Neon DB integration

The backend already prioritizes `DATABASE_URL`.

If `DATABASE_URL` is set, it is used directly (Neon recommended). If not set, backend falls back to `DB_*` values.

## Setup and run

### Install frontend dependencies

```powershell
Set-Location "c:\Users\USER\Desktop\YZone\invoice(Gayathri)\invoice"
npm install
```

### Create Python venv and install backend dependencies

```powershell
Set-Location "c:\Users\USER\Desktop\YZone\invoice(Gayathri)\invoice"
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### Run project

```powershell
Set-Location "c:\Users\USER\Desktop\YZone\invoice(Gayathri)\invoice"
npm run start:all
```

- Frontend: `http://localhost:8080`
- Backend: `http://localhost:8000`
- API docs: `http://localhost:8000/docs`

## Mindee note for Python 3.8

If your installed Mindee SDK does not expose `ClientV2`, backend startup no longer crashes on import. OCR ingestion logs a compatibility error until a compatible SDK is used.

## Security reminders

- Do not trust role or auth state from frontend.
- Do not open invoice APIs without backend auth.
- Do not pass auth token in query string.
- Use one production auth system (central SSO cookie validation).
