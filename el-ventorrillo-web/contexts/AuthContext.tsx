// contexts/AuthContext.tsx
'use client';

import { createContext, useContext, useEffect, useState, ReactNode } from 'react';
import { User } from 'firebase/auth';
import { onAuthStateChanged, getUserProfile, UserProfile } from '@/lib/auth';

interface AuthContextType {
  user: User | null;
  userProfile: UserProfile | null;
  loading: boolean;
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  userProfile: null,
  loading: true,
});

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Solo ejecutar en el cliente
    if (typeof window === 'undefined') {
      setLoading(false);
      return;
    }

    let mounted = true;

    const unsubscribe = onAuthStateChanged(async (firebaseUser) => {
      if (!mounted) return;
      
      setUser(firebaseUser);
      
      if (firebaseUser) {
        // Obtener perfil del usuario desde Firestore
        try {
          const profile = await getUserProfile(firebaseUser.uid);
          if (mounted) {
            setUserProfile(profile);
          }
        } catch (error) {
          console.error('Error obteniendo perfil:', error);
          if (mounted) {
            setUserProfile(null);
          }
        }
      } else {
        setUserProfile(null);
      }
      
      if (mounted) {
        setLoading(false);
      }
    });

    return () => {
      mounted = false;
      unsubscribe();
    };
  }, []);

  return (
    <AuthContext.Provider value={{ user, userProfile, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuthContext() {
  return useContext(AuthContext);
}

