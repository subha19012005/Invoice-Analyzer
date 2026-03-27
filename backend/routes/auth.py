import os
import re
from datetime import datetime, timedelta
from typing import Optional

import bcrypt
import jwt
from fastapi import APIRouter, Depends, HTTPException, Request, Response, status
from fastapi.responses import RedirectResponse
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy import func
from sqlalchemy.orm import Session

from auth import validate_shared_sso_cookie
from config import (
    ACCESS_TOKEN_EXPIRE_MINUTES,
    ALGORITHM,
    ALLOW_LOCAL_LOGIN,
    SECRET_KEY,
    SSO_COOKIE_NAME,
    SSO_ENABLED,
    SSO_LOGIN_URL,
    SSO_LOGOUT_URL,
)
from database import get_db
from models import User

router = APIRouter()
bearer_scheme = HTTPBearer(auto_error=False)

FRONTEND_URL = os.getenv("FRONTEND_URL", "http://localhost:8080")


# ── helpers ───────────────────────────────────────────────────────────────────

def is_local_dev_fallback_enabled() -> bool:
    return ALLOW_LOCAL_LOGIN


def _get_user_from_legacy_token(token: str, db: Session) -> Optional[User]:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    except jwt.PyJWTError:
        return None
    username = payload.get("sub")
    if not username:
        return None
    return db.query(User).filter(User.username == username).first()


def verify_password(plain: str, hashed: str) -> bool:
    return bcrypt.checkpw(plain.encode("utf-8")[:72], hashed.encode("utf-8"))


def get_password_hash(password: str) -> str:
    return bcrypt.hashpw(password.encode("utf-8")[:72], bcrypt.gensalt()).decode("utf-8")


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    to_encode["exp"] = datetime.utcnow() + (expires_delta or timedelta(minutes=15))
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def _user_payload(user: User) -> dict:
    return {
        "id": user.id,
        "name": user.username,
        "username": user.username,
        "email": user.email,
        "role": user.role,
        "created_at": user.created_at.isoformat() if user.created_at else None,
    }


# ── SSO user resolution ───────────────────────────────────────────────────────

async def get_current_user_from_sso(
    request: Request,
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> User:
    """
    Resolve current user using shared SSO cookie validated by central SSO.
    Local login bearer token is accepted only when ALLOW_LOCAL_LOGIN=true.
    """
    if SSO_ENABLED:
        user_payload = await validate_shared_sso_cookie(request)
        email = (user_payload.get("email") or user_payload.get("user_email") or "").strip().lower()
        if not email:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Central SSO identity is missing email",
            )

        user = db.query(User).filter(func.lower(User.email) == email).first()
        if not user:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Logged in centrally but not onboarded in Invoice app",
            )
        return user

    if is_local_dev_fallback_enabled() and credentials and credentials.scheme.lower() == "bearer":
        dev_user = _get_user_from_legacy_token(credentials.credentials, db)
        if dev_user:
            return dev_user

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Authentication required",
    )


def require_admin_sso(current_user: User = Depends(get_current_user_from_sso)) -> User:
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Admin access required")
    return current_user


def require_reviewer_or_admin(current_user: User = Depends(get_current_user_from_sso)) -> User:
    if current_user.role not in {"reviewer", "admin"}:
        raise HTTPException(status_code=403, detail="Reviewer or admin access required")
    return current_user


# ── routes ────────────────────────────────────────────────────────────────────

@router.get("/auth/me")
async def auth_me(current_user: User = Depends(get_current_user_from_sso)):
    """Return current authenticated + authorized user profile."""
    user_data = _user_payload(current_user)
    return {
        "authenticated": True,
        "authorized": True,
        "user": {
            "email": user_data["email"],
            "name": user_data["name"],
            "role": user_data["role"],
            "username": user_data["username"],
            "id": user_data["id"],
            "created_at": user_data["created_at"],
        },
    }


@router.get("/auth/sso/login")
async def sso_login_redirect():
    """Redirect to NiFo SSO login (or dev-login in development)."""
    if not SSO_LOGIN_URL:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="SSO_LOGIN_URL is not configured.",
        )
    return RedirectResponse(url=SSO_LOGIN_URL, status_code=302)


@router.post("/auth/logout")
async def logout(response: Response):
    """Clear the SSO session cookie."""
    response.delete_cookie(
        key=SSO_COOKIE_NAME,
        path="/",
        samesite="lax",
    )
    return {
        "message": "Logged out successfully.",
        "logoutUrl": SSO_LOGOUT_URL or SSO_LOGIN_URL,
    }


@router.get("/auth/sso/logout")
async def sso_logout_redirect():
    if not SSO_LOGOUT_URL:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="SSO_LOGOUT_URL is not configured.",
        )
    return RedirectResponse(url=SSO_LOGOUT_URL, status_code=302)


# ── Dev SSO simulation (development only) ────────────────────────────────────

@router.get("/dev-login")
async def dev_login():
    """
    Simulates NiFo SSO login for local development.
    Sets sso_session cookie and redirects back to frontend.
    """
    if not is_local_dev_fallback_enabled():
        raise HTTPException(status_code=404, detail="Dev login is disabled")

    from dotenv import load_dotenv
    from pathlib import Path
    env_path = Path(__file__).resolve().parent.parent.parent / ".env"
    if env_path.exists():
        load_dotenv(env_path, override=True)

    response = RedirectResponse(url=FRONTEND_URL, status_code=302)
    response.set_cookie(
        key=SSO_COOKIE_NAME,
        value="dev-session",
        httponly=True,
        secure=False,
        samesite="lax",
        path="/",
        max_age=3600,
    )
    return response


@router.get("/dev-switch")
async def dev_switch(role: str = "admin"):
    """
    Dev-only: switch role without clearing cookies manually.
    Updates DEV_SSO_ROLE in .env and resets the session cookie.
    Usage: GET /dev-switch?role=reviewer  or  GET /dev-switch?role=admin
    """
    if not is_local_dev_fallback_enabled():
        raise HTTPException(status_code=404, detail="Dev switch is disabled")

    from pathlib import Path
    from dotenv import load_dotenv

    # .env is at invoice/invoice/.env — three levels up from routes/auth.py
    env_path = Path(__file__).resolve().parent.parent.parent / ".env"

    if not env_path.exists():
        raise HTTPException(status_code=500, detail=f".env not found at: {env_path}")

    content = env_path.read_text(encoding="utf-8")

    if re.search(r"^DEV_SSO_ROLE\s*=", content, re.MULTILINE):
        content = re.sub(r"^DEV_SSO_ROLE\s*=.*$", f"DEV_SSO_ROLE={role}", content, flags=re.MULTILINE)
    else:
        content += f"\nDEV_SSO_ROLE={role}\n"

    env_path.write_text(content, encoding="utf-8")
    load_dotenv(env_path, override=True)

    response = RedirectResponse(url=FRONTEND_URL, status_code=302)
    response.set_cookie(
        key=SSO_COOKIE_NAME,
        value="dev-session",
        httponly=True,
        secure=False,
        samesite="lax",
        path="/",
        max_age=3600,
    )
    return response


@router.get("/dev-validate")
async def dev_validate(request: Request, db: Session = Depends(get_db)):
    """
    Simulates NiFo SSO validation for local development.
    Set DEV_SSO_ROLE=reviewer in .env to test reviewer dashboard.
    Reloads .env on every call so changes take effect without restart.
    """
    if not is_local_dev_fallback_enabled():
        raise HTTPException(status_code=404, detail="Dev validate is disabled")

    cookie = request.cookies.get(SSO_COOKIE_NAME)
    if cookie != "dev-session":
        raise HTTPException(status_code=401, detail="Invalid dev session cookie")

    # Reload .env every time so changes take effect without restarting
    from dotenv import load_dotenv
    from pathlib import Path
    env_path = Path(__file__).resolve().parent.parent.parent / ".env"
    if env_path.exists():
        load_dotenv(env_path, override=True)

    dev_role = os.getenv("DEV_SSO_ROLE", "admin").strip().lower()

    user = db.query(User).filter(User.role == dev_role).first()
    if user:
        return {"authenticated": True, "user": _user_payload(user)}

    return {
        "authenticated": True,
        "user": {
            "id": 2 if dev_role == "reviewer" else 1,
            "username": dev_role,
            "email": f"{dev_role}@test.com",
            "role": dev_role,
            "created_at": "2024-01-01T00:00:00",
        },
    }


# ── Local login (dev fallback, disabled in production) ───────────────────────

@router.post("/auth/login")
async def login(credentials: dict, db: Session = Depends(get_db)):
    if not is_local_dev_fallback_enabled():
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Local login is disabled. Use SSO.",
        )

    username = credentials.get("username", "").strip()
    password = credentials.get("password", "").strip()

    if not username or not password:
        raise HTTPException(status_code=400, detail="Username and password are required")

    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(status_code=401, detail="User not found")
    if not verify_password(password, user.password):
        raise HTTPException(status_code=401, detail="Incorrect password")

    token = create_access_token(
        data={"sub": user.username, "role": user.role},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES),
    )
    return {"user": _user_payload(user), "token": token}
