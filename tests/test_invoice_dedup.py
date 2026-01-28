from datetime import date
from database.db import engine, SessionLocal, Base
from erp.models import InvoiceHeader, AuditLog
from services.invoice_processor import process_invoice

Base.metadata.create_all(engine)
session = SessionLocal()

data = {
    "invoice_number": "INV-001",
    "vendor_code": "VEND-01",
    "invoice_date": date.today(),
    "po_number": "PO-01",
    "invoice_amount": 1000,
    "tax_amount": 180
}

process_invoice(session, **data)
process_invoice(session, **data)

print("Invoices:", session.query(InvoiceHeader).count())
print("Audit logs:", session.query(AuditLog).count())
