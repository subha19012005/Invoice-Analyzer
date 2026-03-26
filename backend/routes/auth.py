import os
from fastapi import APIRouter, Depends, HTTPException, status, Request
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session
from database import get_db
from models import User
from config import SECRET_KEY, ALGORITHM, ACCESS_TOKEN_EXPIRE_MINUTES
import bcrypt
import jwt
from datetime import datetime, timedelta
from typing import Optional

router = APIRouter()
bearer_scheme = HTTPBearer(auto_error=False)


def is_local_dev_fallback_enabled() -> bool:
    env = os.getenv("APP_ENV", os.getenv("ENV", "development")).strip().lower()
    enabled = os.getenv("ALLOW_LOCAL_LOGIN")
    if enabled is not None:
        return enabled.strip().lower() in {"1", "true", "yes", "on"}
    return env in {"dev", "development", "local"}


def _extract_sso_identity(request: Request) -> tuple[Optional[str], Optional[str], Optional[str]]:
    headers = request.headers

    username = (
        headers.get("x-auth-request-user")
        or headers.get("x-forwarded-user")
        or headers.get("x-user")
    )
    email = (
        headers.get("x-auth-request-email")
        or headers.get("x-forwarded-email")
        or headers.get("x-user-email")
    )
    role = headers.get("x-auth-request-role") or headers.get("x-user-role")

    return username, email, role


def _get_user_from_legacy_token(
    token: str,
    db: Session,
) -> Optional[User]:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
    except jwt.PyJWTError:
        return None

    username = payload.get("sub")
    if not username:
        return None

    return db.query(User).filter(User.username == username).first()


def get_current_user_sso(
    request: Request,
    credentials: HTTPAuthorizationCredentials = Depends(bearer_scheme),
    db: Session = Depends(get_db),
) -> User:
    """
    Resolve current user from trusted SSO headers.

    Local-dev fallback:
    - If ENABLE_LOCAL_DEV_LOGIN=true (or APP_ENV=development), accept legacy JWT bearer tokens.
    """
    sso_username, sso_email, sso_role = _extract_sso_identity(request)

    if sso_email:
        user = db.query(User).filter(User.email == sso_email).first()
    elif sso_username:
        user = db.query(User).filter(User.username == sso_username).first()
    else:
        user = None

    if user:
        if sso_role and sso_role != user.role:
            user.role = sso_role
            db.commit()
            db.refresh(user)
        return user

    if is_local_dev_fallback_enabled() and credentials and credentials.scheme.lower() == "bearer":
        dev_user = _get_user_from_legacy_token(credentials.credentials, db)
        if dev_user:
            return dev_user

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="SSO identity not found or not authorized",
    )


def require_admin_sso(current_user: User = Depends(get_current_user_sso)) -> User:
    if current_user.role != "admin":
        raise HTTPException(status_code=403, detail="Admin access required")
    return current_user

def verify_password(plain_password, hashed_password):
    # Use direct bcrypt to avoid passlib issues
    password_bytes = plain_password.encode('utf-8')[:72]  # Truncate to 72 chars
    hash_bytes = hashed_password.encode('utf-8')
    return bcrypt.checkpw(password_bytes, hash_bytes)

def get_password_hash(password):
    # Use direct bcrypt to avoid passlib issues
    password_bytes = password.encode('utf-8')[:72]  # Truncate to 72 chars
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(password_bytes, salt).decode('utf-8')

def authenticate_user(db: Session, username: str, password: str):
    user = db.query(User).filter(User.username == username).first()
    if not user or not verify_password(password, user.password):
        return None
    return user

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

@router.post("/auth/login")
async def login(credentials: dict, db: Session = Depends(get_db)):
    if not is_local_dev_fallback_enabled():
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Local login is disabled. Use SSO and /auth/me.",
        )

    username = credentials.get('username')
    password = credentials.get('password')
    
    if not username or not password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username and password are required"
        )
    
    # Check if user exists first
    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="User not found",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Check password
    if not verify_password(password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username, "role": user.role}, expires_delta=access_token_expires
    )
    
    return {
        "user": {
            "id": user.id,
            "username": user.username,
            "email": user.email,
            "role": user.role,
            "created_at": user.created_at.isoformat() if user.created_at else None
        },
        "token": access_token
    }


@router.get("/auth/me")
async def auth_me(current_user: User = Depends(get_current_user_sso)):
    return {
        "user": {
            "id": current_user.id,
            "username": current_user.username,
            "email": current_user.email,
            "role": current_user.role,
            "created_at": current_user.created_at.isoformat() if current_user.created_at else None,
        }
    }
