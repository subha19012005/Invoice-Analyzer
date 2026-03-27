import React, { useState } from 'react';
import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import Sidebar from './Sidebar';
import { cn } from '@/lib/utils';
import { Loader2 } from 'lucide-react';

interface DashboardLayoutProps {
  requiredRole?: 'admin' | 'reviewer';
}

const DashboardLayout: React.FC<DashboardLayoutProps> = ({ requiredRole }) => {
  const { user, isAuthenticated, isLoading, isForbidden } = useAuth();
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);

  // Wait for /auth/me to resolve
  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <div className="flex flex-col items-center gap-4">
          <Loader2 className="w-8 h-8 animate-spin text-primary" />
          <p className="text-muted-foreground">Authenticating...</p>
        </div>
      </div>
    );
  }

  // 403 — authenticated via SSO but not authorized in this app
  if (isForbidden) {
    return <Navigate to="/not-authorized" replace />;
  }

  // 401 — useAuth already redirected to SSO; this is a safety fallback
  if (!isAuthenticated) {
    return null;
  }

  // Wrong role — send to the correct dashboard
  if (requiredRole && user?.role !== requiredRole) {
    return <Navigate to={user?.role === 'admin' ? '/admin' : '/reviewer'} replace />;
  }

  return (
    <div className="min-h-screen bg-background">
      <Sidebar collapsed={sidebarCollapsed} onToggle={() => setSidebarCollapsed(!sidebarCollapsed)} />
      <main className={cn('min-h-screen transition-all duration-300', sidebarCollapsed ? 'ml-16' : 'ml-64')}>
        <div className="p-6 lg:p-8">
          <Outlet />
        </div>
      </main>
    </div>
  );
};

export default DashboardLayout;
