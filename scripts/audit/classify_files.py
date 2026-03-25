import os
from pathlib import Path

root = Path('.').resolve()
exclude_dirs = {'.git','node_modules','venv','__pycache__','backups','.vscode','.git_corrupt_backup_20260305_213335','dist'}

runtime_prefixes = [
    'backend/main.py','backend/routes/','backend/services/','backend/models.py','backend/database.py','backend/config.py','backend/security.py','backend/auth.py',
    'frontend/App.tsx','frontend/main.tsx','frontend/components/','frontend/pages/','frontend/services/','frontend/hooks/','frontend/lib/','frontend/types/',
    'package.json','requirements.txt','vite.config.ts','tsconfig.json','tsconfig.app.json','tsconfig.node.json','tailwind.config.ts','postcss.config.js','eslint.config.js','components.json'
]

startup_files = {'start-servers.ps1','trigger_ingestion.py','HOW_TO_RUN.txt','QUICKSTART.md','README.md','docs/DEPLOYMENT_NEON.md'}

likely_legacy = {
    'scripts/legacy/check_db.py','scripts/legacy/invoice_ocr.py','scripts/legacy/mark_unread.py','scripts/legacy/startup.py',
    'scripts/deprecated/backend/seed_sample_invoices.py','scripts/deprecated/backend/check_attachments.py','scripts/deprecated/backend/check_db.py',
    'scripts/deprecated/backend/check_env.py','scripts/deprecated/backend/check_invoices.py','scripts/deprecated/backend/task1_ingestion.py',
    'scripts/deprecated/backend/test_ingestion.py','scripts/deprecated/backend/test_ocr.py',
    'scripts/deprecated/legacy/check_db.py','scripts/deprecated/legacy/invoice_ocr.py','scripts/deprecated/legacy/mark_unread.py','scripts/deprecated/legacy/startup.py',
    'backend/check_db.py','backend/check_attachments.py','backend/check_env.py','backend/check_invoices.py',
    'backend/task1_ingestion.py','backend/test_ocr.py','backend/test_ingestion.py','backend/test_connection.py'
}

rows = []
for p in root.rglob('*'):
    if p.is_dir():
        continue
    rel = p.relative_to(root).as_posix()
    parts = set(rel.split('/'))
    if parts & exclude_dirs:
        continue

    status = 'Support'
    reason = 'Project/support file'

    if rel in startup_files:
        status = 'Used'
        reason = 'Referenced startup/deployment flow'
    elif any(rel == rp or rel.startswith(rp) for rp in runtime_prefixes):
        status = 'Used'
        reason = 'Runtime build/server path'
    elif rel in likely_legacy:
        status = 'Likely-Unused'
        reason = 'Standalone utility/diagnostic script not in runtime path'
    elif rel.startswith('backend/archive/'):
        status = 'Likely-Unused'
        reason = 'Archived script location'
    elif rel.endswith('.md'):
        status = 'Support'
        reason = 'Documentation'
    elif rel.endswith('.bat') or rel.endswith('.ps1'):
        status = 'Support'
        reason = 'Operational script'
    elif rel.endswith('.test.ts') or '/test/' in rel:
        status = 'Support'
        reason = 'Test-only file'

    rows.append((rel, status, reason))

rows.sort(key=lambda x: x[0])

out = ['# File Usage Classification', '', 'Status legend: `Used` = runtime/startup path, `Support` = docs/tests/ops, `Likely-Unused` = candidate cleanup.', '', '| File | Status | Reason |', '|---|---|---|']
for rel, status, reason in rows:
    out.append(f'| `{rel}` | {status} | {reason} |')

Path('FILE_USAGE_CLASSIFICATION.md').write_text('\n'.join(out), encoding='utf-8')
print(f'Wrote {len(rows)} entries to FILE_USAGE_CLASSIFICATION.md')
