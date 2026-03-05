"""Fix Google Drive permissions for existing invoice files"""
import logging
from database import SessionLocal
from models import Invoice
from services.email_ingestion import get_drive_service

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def make_files_public():
    """Make all existing Drive files publicly viewable"""
    db = SessionLocal()
    drive_service = get_drive_service()
    
    try:
        invoices = db.query(Invoice).filter(Invoice.drive_file_id.isnot(None)).all()
        logger.info(f"Found {len(invoices)} invoices with Drive files")
        
        success_count = 0
        for invoice in invoices:
            try:
                # Set public permission
                permission = {
                    'type': 'anyone',
                    'role': 'reader'
                }
                drive_service.permissions().create(
                    fileId=invoice.drive_file_id,
                    body=permission,
                    fields='id'
                ).execute()
                
                logger.info(f"✓ Invoice {invoice.id} (File: {invoice.drive_file_id}) - Made public")
                success_count += 1
            except Exception as e:
                logger.error(f"✗ Invoice {invoice.id} - Failed: {str(e)}")
        
        logger.info(f"\n=== COMPLETE ===")
        logger.info(f"Successfully updated {success_count}/{len(invoices)} files")
        
    finally:
        db.close()

if __name__ == "__main__":
    make_files_public()
