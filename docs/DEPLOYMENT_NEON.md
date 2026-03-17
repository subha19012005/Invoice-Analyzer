# Neon Deployment Checklist (Invoice Hub)

## 1) Required Environment Variables

Set these in your deployment platform (Render/Railway/Fly.io/etc):

- `DATABASE_URL=postgresql://<user>:<password>@<host>/<db>?sslmode=require&channel_binding=require`
- `SECRET_KEY=<strong-random-secret>`
- `API_KEY=<api-key-for-trigger-endpoints>`
- `EMAIL_USER=<gmail-address>`
- `EMAIL_PASS=<gmail-app-password>`
- `IMAP_SERVER=imap.gmail.com`
- `PROCESSED_LABEL=Processed_Invoices`
- `MINDEE_V2_API_KEY=<mindee-key>`
- `MINDEE_MODEL_ID=<model-id>`
- `GOOGLE_DRIVE_FOLDER_ID=<drive-folder-id>`
- `CREDENTIALS_FILE=credentials.json`
- `EXCEL_FILE=Invoice_Log_Highlighted.xlsx`

## 2) Database Behavior in This Codebase

- App uses `DATABASE_URL` first (Neon-ready).
- If `DATABASE_URL` is absent, it falls back to `DB_*` local settings.

## 3) Pre-Deployment Validation

From project root:

```powershell
python -m compileall backend
python backend/test_connection.py
npm run build
```

Expected:
- Python compile passes.
- `test_connection.py` shows success with `DATABASE_URL` mode.
- Frontend build completes.

## 4) Start Commands

Backend:

```powershell
cd backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000
```

Frontend (Vite dev only):

```powershell
npm run dev -- --host 0.0.0.0 --port 8080
```

## 5) Post-Deploy Smoke Checks

```powershell
Invoke-RestMethod -Uri "https://<your-backend-domain>/" -Method Get
Invoke-RestMethod -Uri "https://<your-backend-domain>/metrics/admin" -Method Get
```

Login check (`admin`):

```powershell
$body = @{ username = 'admin'; password = 'admin123' } | ConvertTo-Json
Invoke-RestMethod -Uri "https://<your-backend-domain>/auth/login" -Method Post -ContentType "application/json" -Body $body
```

## 6) Security Notes

- Rotate any credentials shared in chat or logs.
- Never commit real `.env` secrets to Git.
- Use platform secret manager for all production credentials.
