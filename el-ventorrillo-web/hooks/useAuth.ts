// hooks/useAuth.ts
import { useAuthContext } from '@/contexts/AuthContext';

export function useAuth() {
  const { user, userProfile, loading } = useAuthContext();
  
  return {
    user,
    userProfile,
    loading,
    isAuthenticated: !!user,
  };
}

