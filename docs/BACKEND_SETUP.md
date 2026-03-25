# Invoice Hub - Backend Setup Guide

## Prerequisites
- Python 3.8+
- PostgreSQL database
- Node.js 16+ (for frontend)

## Backend Setup

### 1. Create Virtual Environment
```bash
python -m venv venv
# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate
```

### 2. Install Dependencies
```bash
pip install -r requirements.txt
```

### 3. Database Setup
```bash
# Create PostgreSQL database
createdb invoice_hub

# Use environment variable (preferred):
export DATABASE_URL="postgresql://username:password@localhost:5432/invoice_hub"
```

### 3A. Use Neon (Managed PostgreSQL)
1. Create a Neon project and copy the connection string.
2. Set `DATABASE_URL` in your `.env` file (project root):

```bash
DATABASE_URL=postgresql://<user>:<password>@<your-neon-host>/<db>?sslmode=require
```

Notes:
- Backend now prioritizes `DATABASE_URL` automatically.
- If the URL is Neon and `sslmode` is missing, the backend adds `sslmode=require`.
- `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`, `DB_NAME` are only used when `DATABASE_URL` is not set.

### 3B. Migrate Local PostgreSQL Data to Neon
Use PostgreSQL client tools (`pg_dump`, `psql`) from PowerShell:

```powershell
# 1) Export your current local database
pg_dump --no-owner --no-privileges -h localhost -p 5432 -U postgres -d invoice_hub -f invoice_hub_dump.sql

# 2) Import into Neon (replace placeholders)
psql "postgresql://<user>:<password>@<your-neon-host>/<db>?sslmode=require" -f invoice_hub_dump.sql
```

Optional schema-only / data-only:

```powershell
pg_dump --schema-only -h localhost -p 5432 -U postgres -d invoice_hub -f schema.sql
pg_dump --data-only -h localhost -p 5432 -U postgres -d invoice_hub -f data.sql
```

### 4. Initialize Database
```bash
cd backend
python create_tables.py
python setup_users.py  # Create initial users
```

### 5. Start Backend Server
```bash
cd backend
python main.py
```

Server will run on: http://localhost:8000

## Frontend Setup

### 1. Install Dependencies
```bash
npm install
```

### 2. Start Development Server
```bash
npm run dev
```

Frontend will run on: http://localhost:5173

## Environment Variables

Create `.env` file in project root:
```
DATABASE_URL=postgresql://username:password@localhost:5432/invoice_hub
SECRET_KEY=your-secret-key-here
JWT_ALGORITHM=HS256
```

Neon example:
```
DATABASE_URL=postgresql://<user>:<password>@<your-neon-host>/<db>?sslmode=require
SECRET_KEY=your-secret-key-here
JWT_ALGORITHM=HS256
```

## Default Users

After running `backend/setup_users.py`:
- **Admin**: username `admin`, password `admin123`
- **Reviewer**: username `reviewer`, password `reviewer123`

## API Documentation

Once backend is running, visit:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
