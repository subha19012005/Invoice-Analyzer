import React, { createContext, useContext, useState, useEffect, useCallback, useRef } from 'react';
import { User } from '@/types';
import { fetchCurrentUser, logout as logoutService } from '@/services/authService';

// NiFo SSO login URL — backend redirects to SSO provider
// Configurable via VITE_SSO_LOGIN_URL env var
const SSO_LOGIN_URL = import.meta.env.VITE_SSO_LOGIN_URL || '/auth/sso/login';
const SSO_LOGOUT_URL = import.meta.env.VITE_SSO_LOGOUT_URL || '/auth/sso/logout';
const ALLOW_LOCAL_LOGIN = String(import.meta.env.VITE_ALLOW_LOCAL_LOGIN || 'false').toLowerCase() === 'true';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  isForbidden: boolean;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isForbidden, setIsForbidden] = useState(false);
  const initialized = useRef(false); // guard against React StrictMode double-invoke

  useEffect(() => {
    if (initialized.current) return;
    initialized.current = true;

    const initAuth = async () => {
      try {
        const currentUser = await fetchCurrentUser();

        if (currentUser === null) {
          if (ALLOW_LOCAL_LOGIN) {
            if (!window.location.pathname.startsWith('/login')) {
              window.location.replace('/login');
              return;
            }
          } else {
            window.location.replace(SSO_LOGIN_URL);
            return;
          }
          return; // don't setIsLoading(false) — page is navigating away
        }

        setUser(currentUser);
      } catch (error: any) {
        if (error.response?.status === 403) {
          setIsForbidden(true);
        } else {
          if (ALLOW_LOCAL_LOGIN) {
            window.location.replace('/login');
            return;
          }
          window.location.replace(SSO_LOGIN_URL);
          return;
        }
      } finally {
        setIsLoading(false);
      }
    };

    initAuth();
  }, []);

  const logout = useCallback(async () => {
    setIsLoading(true);
    try {
      const centralLogoutUrl = await logoutService();
      const redirectUrl = centralLogoutUrl || SSO_LOGOUT_URL;

      setUser(null);
      setIsForbidden(false);
      setIsLoading(false);

      if (ALLOW_LOCAL_LOGIN) {
        window.location.replace('/login');
        return;
      }

      window.location.replace(redirectUrl);
      return;
    } finally {
      setUser(null);
      setIsForbidden(false);
      setIsLoading(false);
    }
  }, []);

  return (
    <AuthContext.Provider value={{ user, isAuthenticated: !!user, isLoading, isForbidden, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within an AuthProvider');
  return context;
};
