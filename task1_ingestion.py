import imaplib
import email
import datetime
from email.header import decode_header
import io
import os

from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
from googleapiclient.http import MediaIoBaseUpload

# ================= CONFIGURATION =================
EMAIL_USER = "invoice.project01@gmail.com"
EMAIL_PASS = "pend sdym nkzx hrzg"   # Gmail App Password
IMAP_SERVER = "imap.gmail.com"

GOOGLE_DRIVE_FOLDER_ID = "1LoRbKdiCsO4UpC2ahXcjdS4O5Nz3-ua_"
SERVICE_ACCOUNT_FILE = "credentials.json"

INVOICE_TERMS = [
    "invoice", "bill", "payment", "receipt",
    "total", "amount", "due", "credit note", "statement"
]
# =================================================


# ---------- GOOGLE DRIVE SETUP ----------
SCOPES = ["https://www.googleapis.com/auth/drive"]

def get_drive_service():
    if not os.path.exists(SERVICE_ACCOUNT_FILE):
        raise FileNotFoundError("❌ credentials.json not found")

    creds = Credentials.from_service_account_file(
        SERVICE_ACCOUNT_FILE,
        scopes=SCOPES
    )
    return build("drive", "v3", credentials=creds)

drive_service = get_drive_service()


def upload_to_drive(file_bytes, filename):
    media = MediaIoBaseUpload(
        io.BytesIO(file_bytes),
        mimetype="application/octet-stream",
        resumable=False
    )

    metadata = {
        "name": filename,
        "parents": [GOOGLE_DRIVE_FOLDER_ID]
    }

    uploaded = drive_service.files().create(
        body=metadata,
        media_body=media,
        fields="id"
    ).execute()

    return uploaded["id"]


# ---------- MAIN LOGIC ----------
def connect_and_fetch():
    print("Connecting to Gmail...")

    mail = imaplib.IMAP4_SSL(IMAP_SERVER)
    mail.login(EMAIL_USER, EMAIL_PASS)

    # ✅ Always select INBOX (mandatory for IMAP)
    status, _ = mail.select("INBOX")
    if status != "OK":
        raise RuntimeError("❌ Failed to select INBOX")

    # ✅ UPDATED: fetch ALL unread emails (no label filtering)
    status, messages = mail.search(None, "UNSEEN")

    if status != "OK" or not messages[0]:
        print("No unread emails found.")
        mail.logout()
        return

    email_ids = messages[0].split()
    print(f"Found {len(email_ids)} unread emails")

    for e_id in email_ids:
        _, msg_data = mail.fetch(e_id, "(RFC822)")
        msg = email.message_from_bytes(msg_data[0][1])

        # ----- SUBJECT -----
        subject, encoding = decode_header(msg.get("Subject", ""))[0]
        if isinstance(subject, bytes):
            subject = subject.decode(encoding or "utf-8", errors="ignore")

        subject_lower = subject.lower()

        # ----- BODY -----
        body = ""
        if msg.is_multipart():
            for part in msg.walk():
                if part.get_content_type() == "text/plain" and part.get_content_disposition() is None:
                    body = part.get_payload(decode=True).decode(errors="ignore")
                    break
        else:
            body = msg.get_payload(decode=True).decode(errors="ignore")

        body_lower = body.lower()

        # ----- KEYWORD MATCH -----
        found_terms = [
            term for term in INVOICE_TERMS
            if term in subject_lower or term in body_lower
        ]

        # ----- ATTACHMENTS -----
        attachments = []
        for part in msg.walk():
            if part.get_content_disposition() == "attachment":
                filename = part.get_filename()
                if filename:
                    attachments.append((filename, part))

        # ----- CLASSIFICATION -----
        is_invoice = bool(found_terms and attachments)

        print(f"\n📧 {subject}")
        print(f"   Keywords found: {found_terms}")
        print(f"   Attachments: {len(attachments)}")
        print(f"   Invoice? {'YES' if is_invoice else 'NO'}")

        # ----- UPLOAD -----
        if is_invoice:
            for filename, part in attachments:
                clean_name = "".join(c for c in filename if c.isalnum() or c in "._- ")
                new_name = f"{int(datetime.datetime.now().timestamp())}_{clean_name}"

                file_bytes = part.get_payload(decode=True)
                drive_id = upload_to_drive(file_bytes, new_name)

                print(f"   ☁ Uploaded to Drive | File ID: {drive_id}")

            # ✅ mark email as read after successful processing
            mail.store(e_id, "+FLAGS", "\\Seen")

    mail.logout()
    print("\nDone.")


if __name__ == "__main__":
    connect_and_fetch()
