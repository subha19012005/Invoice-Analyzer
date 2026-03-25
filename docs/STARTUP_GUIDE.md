# 🚀 Startup Guide (Companion)

This file is a concise companion guide.

> Canonical startup/run instructions live in `QUICKSTART.md`.

## Recommended Startup

```bash
npm run start:all
```

Alternative on Windows:

```powershell
powershell -ExecutionPolicy Bypass -File start-servers.ps1
python trigger_ingestion.py
```

## Quick Access

- Frontend: `http://localhost:8080`
- Backend docs: `http://localhost:8000/docs`

## Troubleshooting Shortlist

- Port check: `netstat -ano | findstr :8000`
- Verify Python: `python --version`
- Verify Node: `node --version`
- Manual ingestion: `python trigger_ingestion.py`

For full setup, environment details, and workflow steps, use `QUICKSTART.md`.
