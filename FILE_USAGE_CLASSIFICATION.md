# File Usage Classification

Status legend: `Used` = runtime/startup path, `Support` = docs/tests/ops, `Likely-Unused` = candidate cleanup.

| File | Status | Reason |
|---|---|---|
| `.env` | Support | Project/support file |
| `.env.example` | Support | Project/support file |
| `.gitignore` | Support | Project/support file |
| `FILE_USAGE_CLASSIFICATION.md` | Support | Documentation |
| `HOW_TO_RUN.txt` | Used | Referenced startup/deployment flow |
| `QUICKSTART.md` | Used | Referenced startup/deployment flow |
| `README.md` | Used | Referenced startup/deployment flow |
| `START.bat` | Used | Referenced startup/deployment flow |
| `backend/.env` | Support | Project/support file |
| `backend/Ingestion_Log.xlsx` | Support | Project/support file |
| `backend/Invoice_Log_Highlighted.xlsx` | Support | Project/support file |
| `backend/auth.py` | Used | Runtime build/server path |
| `backend/config.py` | Used | Runtime build/server path |
| `backend/create_proper_users.py` | Support | Project/support file |
| `backend/create_sample_invoices.py` | Support | Project/support file |
| `backend/create_tables.py` | Support | Project/support file |
| `backend/create_users.py` | Support | Project/support file |
| `backend/credentials.json` | Support | Project/support file |
| `backend/database.py` | Used | Runtime build/server path |
| `backend/email_ocr.py` | Support | Project/support file |
| `backend/fix_drive_permissions.py` | Support | Project/support file |
| `backend/ingestion.py` | Support | Project/support file |
| `backend/main.py` | Used | Runtime build/server path |
| `backend/manual_upload_smoke.csv` | Support | Project/support file |
| `backend/mark_unread.py` | Support | Project/support file |
| `backend/migrate_add_review_fields.py` | Support | Project/support file |
| `backend/models.py` | Used | Runtime build/server path |
| `backend/reset_postgres_password.bat` | Support | Operational script |
| `backend/routes/__init__.py` | Used | Runtime build/server path |
| `backend/routes/auth.py` | Used | Runtime build/server path |
| `backend/routes/invoices.py` | Used | Runtime build/server path |
| `backend/routes/logs.py` | Used | Runtime build/server path |
| `backend/routes/metrics.py` | Used | Runtime build/server path |
| `backend/routes/users.py` | Used | Runtime build/server path |
| `backend/security.py` | Used | Runtime build/server path |
| `backend/seed_invoices.py` | Support | Project/support file |
| `backend/services/__init__.py` | Used | Runtime build/server path |
| `backend/services/email_ingestion.py` | Used | Runtime build/server path |
| `backend/services/email_ingestion_state.json` | Used | Runtime build/server path |
| `backend/setup_users.py` | Support | Project/support file |
| `backend/test_connection.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `backend/token.pickle` | Support | Project/support file |
| `components.json` | Used | Runtime build/server path |
| `docs/BACKEND_SETUP.md` | Support | Documentation |
| `docs/CODE_CLEANUP_SUMMARY.md` | Support | Documentation |
| `docs/DEPLOYMENT_NEON.md` | Used | Referenced startup/deployment flow |
| `docs/EMAIL_INGESTION_API.md` | Support | Documentation |
| `docs/STARTUP_GUIDE.md` | Support | Documentation |
| `docs/SYSTEM_ANALYSIS.md` | Support | Documentation |
| `docs/SYSTEM_STATUS.md` | Support | Documentation |
| `eslint.config.js` | Used | Runtime build/server path |
| `frontend/.gitkeep` | Support | Project/support file |
| `frontend/App.css` | Support | Project/support file |
| `frontend/App.tsx` | Used | Runtime build/server path |
| `frontend/components/NavLink.tsx` | Used | Runtime build/server path |
| `frontend/components/admin/EmailIngestionPanel.tsx` | Used | Runtime build/server path |
| `frontend/components/admin/ManualInvoiceUploadPanel.tsx` | Used | Runtime build/server path |
| `frontend/components/dashboard/DataTable.tsx` | Used | Runtime build/server path |
| `frontend/components/dashboard/MetricCard.tsx` | Used | Runtime build/server path |
| `frontend/components/dashboard/PageHeader.tsx` | Used | Runtime build/server path |
| `frontend/components/dashboard/StatusBadge.tsx` | Used | Runtime build/server path |
| `frontend/components/invoice/InvoiceForm.tsx` | Used | Runtime build/server path |
| `frontend/components/invoice/InvoicePreview.tsx` | Used | Runtime build/server path |
| `frontend/components/layout/DashboardLayout.tsx` | Used | Runtime build/server path |
| `frontend/components/layout/Sidebar.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/accordion.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/alert-dialog.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/alert.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/aspect-ratio.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/avatar.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/badge.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/breadcrumb.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/button.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/calendar.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/card.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/carousel.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/chart.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/checkbox.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/collapsible.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/command.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/context-menu.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/dialog.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/drawer.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/dropdown-menu.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/form.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/hover-card.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/input-otp.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/input.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/label.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/menubar.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/navigation-menu.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/pagination.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/popover.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/progress.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/radio-group.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/resizable.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/scroll-area.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/select.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/separator.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/sheet.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/sidebar.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/skeleton.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/slider.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/sonner.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/switch.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/table.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/tabs.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/textarea.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/toast.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/toaster.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/toggle-group.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/toggle.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/tooltip.tsx` | Used | Runtime build/server path |
| `frontend/components/ui/use-toast.ts` | Used | Runtime build/server path |
| `frontend/data/mockData.ts` | Support | Project/support file |
| `frontend/hooks/use-mobile.tsx` | Used | Runtime build/server path |
| `frontend/hooks/use-toast.ts` | Used | Runtime build/server path |
| `frontend/hooks/useAuth.tsx` | Used | Runtime build/server path |
| `frontend/index.css` | Support | Project/support file |
| `frontend/index.html` | Support | Project/support file |
| `frontend/lib/dateUtils.ts` | Used | Runtime build/server path |
| `frontend/lib/utils.ts` | Used | Runtime build/server path |
| `frontend/main.tsx` | Used | Runtime build/server path |
| `frontend/pages/Index.tsx` | Used | Runtime build/server path |
| `frontend/pages/Login.tsx` | Used | Runtime build/server path |
| `frontend/pages/NotFound.tsx` | Used | Runtime build/server path |
| `frontend/pages/admin/AdminDashboard.tsx` | Used | Runtime build/server path |
| `frontend/pages/admin/SystemLogs.tsx` | Used | Runtime build/server path |
| `frontend/pages/admin/UserManagement.tsx` | Used | Runtime build/server path |
| `frontend/pages/reviewer/DecisionHistory.tsx` | Used | Runtime build/server path |
| `frontend/pages/reviewer/InvoiceReview.tsx` | Used | Runtime build/server path |
| `frontend/pages/reviewer/ReviewQueue.tsx` | Used | Runtime build/server path |
| `frontend/pages/reviewer/ReviewerDashboard.tsx` | Used | Runtime build/server path |
| `frontend/public/favicon.ico` | Support | Project/support file |
| `frontend/public/favicon.svg` | Support | Project/support file |
| `frontend/services/api.ts` | Used | Runtime build/server path |
| `frontend/services/authService.ts` | Used | Runtime build/server path |
| `frontend/services/emailService.ts` | Used | Runtime build/server path |
| `frontend/services/ingestionService.ts` | Used | Runtime build/server path |
| `frontend/services/invoiceService.ts` | Used | Runtime build/server path |
| `frontend/services/logService.ts` | Used | Runtime build/server path |
| `frontend/services/metricsService.ts` | Used | Runtime build/server path |
| `frontend/services/userService.ts` | Used | Runtime build/server path |
| `frontend/test/example.test.ts` | Support | Test-only file |
| `frontend/test/setup.ts` | Support | Test-only file |
| `frontend/types/index.ts` | Used | Runtime build/server path |
| `frontend/vite-env.d.ts` | Support | Project/support file |
| `index.html` | Support | Project/support file |
| `package-lock.json` | Support | Project/support file |
| `package.json` | Used | Runtime build/server path |
| `postcss.config.js` | Used | Runtime build/server path |
| `requirements.txt` | Used | Runtime build/server path |
| `scripts/audit/classify_files.py` | Support | Project/support file |
| `scripts/deprecated/backend/check_attachments.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/backend/check_db.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/backend/check_env.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/backend/check_invoices.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/backend/seed_sample_invoices.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/backend/task1_ingestion.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/backend/test_ingestion.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/backend/test_ocr.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/legacy/check_db.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/legacy/invoice_ocr.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/legacy/mark_unread.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `scripts/deprecated/legacy/startup.py` | Likely-Unused | Standalone utility/diagnostic script not in runtime path |
| `start-servers.bat` | Used | Referenced startup/deployment flow |
| `start-servers.ps1` | Used | Referenced startup/deployment flow |
| `tailwind.config.ts` | Used | Runtime build/server path |
| `trigger_ingestion.py` | Used | Referenced startup/deployment flow |
| `tsconfig.app.json` | Used | Runtime build/server path |
| `tsconfig.json` | Used | Runtime build/server path |
| `tsconfig.node.json` | Used | Runtime build/server path |
| `vite.config.ts` | Used | Runtime build/server path |
| `vitest.config.ts` | Support | Project/support file |