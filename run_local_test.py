from datetime import date

from database.db import engine, SessionLocal, Base
from erp.models import InvoiceHeader, AuditLog
from services.invoice_processor import process_invoice


def main():
    # --------------------------------
    # Create tables
    # --------------------------------
    Base.metadata.create_all(engine)

    session = SessionLocal()

    # --------------------------------
    # Simulated OCR / Extraction Output
    # --------------------------------
    invoice_data = {
        "invoice_number": "INV-1001",
        "vendor_code": "VEND-001",
        "invoice_date": date.today(),
        "po_number": "PO-9001",
        "invoice_amount": 1180.00,
        "tax_amount": 180.00
    }

    print("\n=== First Processing ===")
    process_invoice(session, **invoice_data)

    print("\n=== Duplicate Processing ===")
    process_invoice(session, **invoice_data)

    # --------------------------------
    # Verification
    # --------------------------------
    invoices = session.query(InvoiceHeader).all()
    audits = session.query(AuditLog).all()

    print("\n=== ERP STATE ===")
    print("Invoices in ERP:", len(invoices))
    print("Audit logs:", len(audits))

    for inv in invoices:
        print(
            f"Invoice: {inv.invoice_number}, "
            f"Vendor: {inv.vendor_code}, "
            f"Total: {inv.total}"
        )

    session.close()


if __name__ == "__main__":
    main()
