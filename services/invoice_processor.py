from erp.models import (
    InvoiceHeader,
    InvoiceLineItem,
    InvoiceAttachment,
    AuditLog
)


def process_invoice(
    session,
    invoice_number,
    vendor_code,
    invoice_date,
    po_number,
    invoice_amount,
    tax_amount
):
    try:
        existing_invoice = session.query(InvoiceHeader).filter(
            InvoiceHeader.invoice_number == invoice_number,
            InvoiceHeader.vendor_code == vendor_code
        ).first()

        if existing_invoice:
            invoice_id = existing_invoice.id

            session.query(InvoiceLineItem).filter_by(invoice_id=invoice_id).delete()
            session.query(InvoiceAttachment).filter_by(invoice_id=invoice_id).delete()
            session.delete(existing_invoice)

            audit = AuditLog(
                invoice_id=invoice_id,
                action="DUPLICATE_REPLACED",
                new_value={
                    "invoice_number": invoice_number,
                    "vendor_code": vendor_code,
                    "invoice_amount": invoice_amount,
                    "tax_amount": tax_amount
                }
            )
            session.add(audit)

        subtotal = invoice_amount - tax_amount

        new_invoice = InvoiceHeader(
            invoice_number=invoice_number,
            vendor_code=vendor_code,
            po_number=po_number,
            invoice_date=invoice_date,
            subtotal=subtotal,
            tax=tax_amount,
            total=invoice_amount
        )

        session.add(new_invoice)
        session.commit()

    except Exception:
        session.rollback()
        raise
