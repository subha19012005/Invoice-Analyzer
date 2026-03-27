import axios from 'axios';

// Exported for legacy imports (e.g. ReviewQueue file URL construction)
export const API_BASE_URL = '';

// Single axios instance — all requests use relative paths via Vite proxy
// withCredentials sends cookies; SSO identity comes from proxy-injected headers
export const apiClient = axios.create({
  baseURL: '',
  withCredentials: true,
  timeout: 30000,
  headers: { 'Content-Type': 'application/json' },
});

// Strip Content-Type for FormData uploads
apiClient.interceptors.request.use(
  (config) => {
    if (typeof FormData !== 'undefined' && config.data instanceof FormData) {
      delete (config.headers as any)['Content-Type'];
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor — skip /auth/* routes (handled by useAuth)
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    const url: string = error.config?.url || '';
    const isAuthRoute = url.includes('/auth/');

    if (!isAuthRoute) {
      if (error.response?.status === 401) {
        // Redirect to NiFo SSO login via backend
        const ssoUrl = import.meta.env.VITE_SSO_LOGIN_URL || '/auth/sso/login';
        window.location.replace(ssoUrl);
      } else if (error.response?.status === 403) {
        window.location.replace('/not-authorized');
      }
    }
    return Promise.reject(error);
  }
);

export default apiClient;
