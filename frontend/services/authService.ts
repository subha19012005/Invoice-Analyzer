import { LoginCredentials, User } from '@/types';
import { apiClient } from './api';

/**
 * Call GET /auth/me — resolves current SSO session.
 * Backend returns { user: { id, username, email, role, created_at } }
 *
 * Returns:
 *   User   — authenticated (200)
 *   null   — not authenticated (401)
 *   throws — forbidden (403) or other error
 */
export const fetchCurrentUser = async (): Promise<User | null> => {
  try {
    const response = await apiClient.get('/auth/me');
    const data = response.data;
    if (!data?.authenticated || !data?.authorized || !data?.user) {
      return null;
    }
    const raw = data.user;
    return {
      id: String(raw.id),
      username: raw.username ?? raw.name,
      email: raw.email,
      role: raw.role,
      createdAt: raw.created_at ?? raw.createdAt ?? '',
    } as User;
  } catch (error: any) {
    if (error.response?.status === 401) return null;
    throw error; // 403 or network — let useAuth handle
  }
};

export const loginLocal = async (credentials: LoginCredentials): Promise<User> => {
  const response = await apiClient.post('/auth/login', credentials);
  const raw = response.data?.user;
  return {
    id: String(raw.id),
    username: raw.username,
    email: raw.email,
    role: raw.role,
    createdAt: raw.created_at ?? raw.createdAt ?? '',
  } as User;
};

/**
 * POST /auth/logout — best-effort server-side session clear.
 */
export const logout = async (): Promise<string | null> => {
  try {
    const response = await apiClient.post('/auth/logout');
    return response.data?.logoutUrl ?? null;
  } catch {
    return null;
  }
};
