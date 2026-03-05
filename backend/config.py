"""
Centralized configuration management for Invoice Hub backend
"""
import os
from dotenv import load_dotenv

load_dotenv()

# ============= DATABASE =============
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres123@localhost:5432/invoice")

# ============= EMAIL =============
EMAIL_USER = os.getenv("EMAIL_USER", "invoice.project01@gmail.com")
EMAIL_PASS = os.getenv("EMAIL_PASS", "pend sdym nkzx hrzg")
IMAP_SERVER = os.getenv("IMAP_SERVER", "imap.gmail.com")
PROCESSED_LABEL = os.getenv("PROCESSED_LABEL", "Processed_Invoices")

# ============= MINDEE OCR =============
MINDEE_API_KEY = os.getenv("MINDEE_V2_API_KEY")
MINDEE_MODEL_ID = os.getenv("MINDEE_MODEL_ID", "1cd90980-2c6c-4d30-8952-af92c6db8786")

# ============= GOOGLE DRIVE =============
GOOGLE_DRIVE_FOLDER_ID = os.getenv("GOOGLE_DRIVE_FOLDER_ID", "1LoRbKdiCsO4UpC2ahXcjdS4O5Nz3-ua_")
CREDENTIALS_FILE = os.getenv("CREDENTIALS_FILE", "credentials.json")
TOKEN_FILE = "token.pickle"
SCOPES = ["https://www.googleapis.com/auth/drive"]

# ============= API SECURITY =============
API_KEY = os.getenv("API_KEY", "invoice-hub-secret-key-2024")
SECRET_KEY = os.getenv("SECRET_KEY", "your-secret-key-change-in-production")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

# ============= CORS =============
ALLOWED_ORIGINS = [
    "http://localhost:5173",
    "http://localhost:8080",
    "http://localhost:8081",
    "http://localhost:8082",
    "http://localhost:3000"
]

# ============= INVOICE DETECTION =============
INVOICE_TERMS = [
    "invoice", "bill", "payment", "receipt", "total", "due",
    "order", "statement", "quote", "estimate", "contract",
    "subscription", "purchase", "transaction", "amount", "inv"
]

ALLOWED_EXTENSIONS = ('.pdf', '.jpg', '.jpeg', '.png', '.webp', '.docx', '.doc', '.xlsx', '.csv')

# ============= EXCEL LOGGING =============
EXCEL_FILE = os.getenv("EXCEL_FILE", "Invoice_Log_Highlighted.xlsx")

# ============= LOGGING =============
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
