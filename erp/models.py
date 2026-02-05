from sqlalchemy import Column, Integer, String, Float, Date, DateTime, ForeignKey, JSON
from sqlalchemy.sql import func
from database.db import Base


class Vendor(Base):
    __tablename__ = "vendor_master"

    id = Column(Integer, primary_key=True)
    vendor_code = Column(String, unique=True, nullable=False)
    vendor_name = Column(String, nullable=False)


class PurchaseOrder(Base):
    __tablename__ = "purchase_orders"

    id = Column(Integer, primary_key=True)
    po_number = Column(String, unique=True, nullable=False)
    vendor_code = Column(String, nullable=False)
    po_total = Column(Float)
    po_balance = Column(Float)


class InvoiceHeader(Base):
    __tablename__ = "invoice_header"

    id = Column(Integer, primary_key=True)
    invoice_number = Column(String, nullable=False)
    vendor_code = Column(String, nullable=False)
    po_number = Column(String)
    invoice_date = Column(Date)
    subtotal = Column(Float)
    tax = Column(Float)
    total = Column(Float)
    status = Column(String, default="POSTED")
    created_at = Column(DateTime, server_default=func.now())


class InvoiceLineItem(Base):
    __tablename__ = "invoice_line_items"

    id = Column(Integer, primary_key=True)
    invoice_id = Column(Integer, ForeignKey("invoice_header.id"))
    description = Column(String)
    quantity = Column(Float)
    unit_price = Column(Float)
    line_total = Column(Float)


class InvoiceAttachment(Base):
    __tablename__ = "invoice_attachments"

    id = Column(Integer, primary_key=True)
    invoice_id = Column(Integer)
    file_name = Column(String)
    file_path = Column(String)


class AuditLog(Base):
    __tablename__ = "invoice_audit_log"

    id = Column(Integer, primary_key=True)
    invoice_id = Column(Integer)
    action = Column(String)
    new_value = Column(JSON)
    timestamp = Column(DateTime, server_default=func.now())
