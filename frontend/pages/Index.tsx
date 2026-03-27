import { useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { Loader2 } from 'lucide-react';

const ALLOW_LOCAL_LOGIN = String(import.meta.env.VITE_ALLOW_LOCAL_LOGIN || 'false').toLowerCase() === 'true';
const SSO_LOGIN_URL = import.meta.env.VITE_SSO_LOGIN_URL || '/auth/sso/login';

const Index = () => {
  const navigate = useNavigate();
  const { user, isAuthenticated, isLoading } = useAuth();

  useEffect(() => {
    if (!isLoading) {
      if (isAuthenticated && user) {
        // Redirect based on role
        if (user.role === 'admin') {
          navigate('/admin', { replace: true });
        } else {
          navigate('/reviewer', { replace: true });
        }
      } else {
        if (ALLOW_LOCAL_LOGIN) {
          navigate('/login', { replace: true });
        } else {
          window.location.replace(SSO_LOGIN_URL);
        }
      }
    }
  }, [isAuthenticated, user, isLoading, navigate]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-background">
      <div className="flex flex-col items-center gap-4">
        <Loader2 className="w-8 h-8 animate-spin text-primary" />
        <p className="text-muted-foreground">Redirecting...</p>
      </div>
    </div>
  );
};

export default Index;
