import os
from typing import Any, Dict
from functools import lru_cache
from fastapi import HTTPException, status, Header, Request
import httpx
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("API_KEY", "invoice-hub-secret-key-2024")
SSO_SHARED_COOKIE_NAME = os.getenv("SSO_SHARED_COOKIE_NAME", "sso_session")
SSO_VALIDATE_URL = os.getenv("SSO_VALIDATE_URL", "").strip()
SSO_VALIDATE_TIMEOUT_SECONDS = float(os.getenv("SSO_VALIDATE_TIMEOUT_SECONDS", "5"))

@lru_cache(maxsize=1)
def get_api_key():
    return API_KEY


@lru_cache(maxsize=1)
def get_sso_settings() -> Dict[str, Any]:
    return {
        "cookie_name": SSO_SHARED_COOKIE_NAME,
        "validate_url": SSO_VALIDATE_URL,
        "timeout_seconds": SSO_VALIDATE_TIMEOUT_SECONDS,
    }

async def verify_api_key(x_api_key: str = Header(None)):
    """Verify API key from request header"""
    if not x_api_key:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Missing API key in header (x-api-key)"
        )
    
    if x_api_key != get_api_key():
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Invalid API key"
        )
    
    return x_api_key


async def validate_shared_sso_cookie(request: Request) -> Dict[str, Any]:
    """
    Validate shared SSO cookie against central SSO service and return user payload.

    Expected central SSO response formats:
    1) {"authenticated": true, "user": {...}}
    2) {"user": {...}}
    3) {...user fields...}
    """
    settings = get_sso_settings()
    cookie_name = settings["cookie_name"]
    validate_url = settings["validate_url"]

    if not validate_url:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="SSO validation URL is not configured"
        )

    shared_cookie_value = request.cookies.get(cookie_name)
    if not shared_cookie_value:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Missing shared SSO cookie: {cookie_name}"
        )

    headers = {
        "User-Agent": request.headers.get("user-agent", "invoice-hub-backend"),
        "X-Forwarded-For": request.client.host if request.client else "unknown",
    }

    try:
        async with httpx.AsyncClient(timeout=settings["timeout_seconds"]) as client:
            response = await client.get(
                validate_url,
                cookies={cookie_name: shared_cookie_value},
                headers=headers,
            )
    except httpx.TimeoutException:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="SSO validation timed out"
        )
    except httpx.HTTPError as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Failed to contact SSO validation service: {str(exc)}"
        )

    if response.status_code in (401, 403):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired SSO session"
        )

    if response.status_code != 200:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"SSO validation failed with status {response.status_code}"
        )

    try:
        payload = response.json()
    except ValueError:
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="SSO validation service returned invalid JSON"
        )

    if not isinstance(payload, dict):
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="SSO validation response format is invalid"
        )

    if payload.get("authenticated") is False:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="SSO session is not authenticated"
        )

    user_payload = payload.get("user") if isinstance(payload.get("user"), dict) else payload

    if not isinstance(user_payload, dict):
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail="SSO validation response missing user payload"
        )

    has_identity = any(user_payload.get(key) for key in ("id", "sub", "username", "email"))
    if not has_identity:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="SSO response did not include a valid user identity"
        )

    return user_payload
