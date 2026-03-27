import React from 'react';
import { useAuth } from '@/hooks/useAuth';

/**
 * Dev-only role switcher — visible only in development mode.
 * Click a button to switch roles without touching DevTools.
 * Calls /dev-switch?role=X which updates .env, resets cookie, and redirects back.
 */
const DevRoleSwitcher: React.FC = () => {
  if (!import.meta.env.DEV) return null;

  const { user } = useAuth();

  const switchRole = (role: 'admin' | 'reviewer') => {
    // Full page navigation — backend sets new cookie and redirects back
    window.location.href = `/dev-switch?role=${role}`;
  };

  return (
    <div
      style={{
        position: 'fixed',
        bottom: '16px',
        right: '16px',
        zIndex: 9999,
        background: '#1e1e2e',
        border: '1px solid #444',
        borderRadius: '8px',
        padding: '8px 12px',
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        fontSize: '12px',
        color: '#cdd6f4',
        boxShadow: '0 4px 12px rgba(0,0,0,0.4)',
      }}
    >
      <span style={{ opacity: 0.6 }}>DEV</span>
      <span>Role: <strong style={{ color: user?.role === 'admin' ? '#89b4fa' : '#a6e3a1' }}>{user?.role ?? '...'}</strong></span>
      <button
        onClick={() => switchRole('admin')}
        disabled={user?.role === 'admin'}
        style={{
          padding: '2px 8px',
          borderRadius: '4px',
          border: 'none',
          background: user?.role === 'admin' ? '#313244' : '#89b4fa',
          color: user?.role === 'admin' ? '#6c7086' : '#1e1e2e',
          cursor: user?.role === 'admin' ? 'default' : 'pointer',
          fontWeight: 600,
          fontSize: '11px',
        }}
      >
        Admin
      </button>
      <button
        onClick={() => switchRole('reviewer')}
        disabled={user?.role === 'reviewer'}
        style={{
          padding: '2px 8px',
          borderRadius: '4px',
          border: 'none',
          background: user?.role === 'reviewer' ? '#313244' : '#a6e3a1',
          color: user?.role === 'reviewer' ? '#6c7086' : '#1e1e2e',
          cursor: user?.role === 'reviewer' ? 'default' : 'pointer',
          fontWeight: 600,
          fontSize: '11px',
        }}
      >
        Reviewer
      </button>
    </div>
  );
};

export default DevRoleSwitcher;
