"""
Create sample invoices directly in database for testing (ARCHIVED COPY)
This file was moved to `backend/archive/` to preserve the sample data script.
"""

# Archived copy of the original seed script. Kept for reference.

from database import SessionLocal
from models import Invoice, LineItem
from datetime import datetime


def main():
    print("This is an archived copy of seed_sample_invoices.py")


if __name__ == '__main__':
    main()
