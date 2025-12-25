// lib/firebase.ts
import { initializeApp, getApps, FirebaseApp } from 'firebase/app';
import { getAuth, Auth } from 'firebase/auth';
import { getFirestore, Firestore } from 'firebase/firestore';
import { getStorage, FirebaseStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY || '',
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID || '',
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID || '',
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID || '',
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN || '',
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET || '',
  measurementId: process.env.NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID || '',
};

// Cache para las instancias
let app: FirebaseApp | null = null;
let authInstance: Auth | null = null;
let dbInstance: Firestore | null = null;
let storageInstance: FirebaseStorage | null = null;

function getFirebaseApp(): FirebaseApp {
  if (app) {
    return app;
  }

  // Si hay apps inicializadas, usar la primera
  const existingApps = getApps();
  if (existingApps.length > 0) {
    app = existingApps[0];
    return app;
  }

  // Validar configuración
  if (!firebaseConfig.apiKey || !firebaseConfig.projectId) {
    throw new Error('Firebase no está configurado. Verifica las variables de entorno NEXT_PUBLIC_FIREBASE_* en Vercel.');
  }

  try {
    app = initializeApp(firebaseConfig);
    return app;
  } catch (error) {
    console.error('Error inicializando Firebase:', error);
    throw error;
  }
}

// Lazy getters usando Proxy para evitar inicialización durante import
function createLazyGetter<T>(getter: () => T): T {
  let value: T | null = null;
  return new Proxy({} as any, {
    get(_target, prop) {
      if (!value) {
        value = getter();
      }
      const val = value as any;
      if (typeof val[prop] === 'function') {
        return val[prop].bind(val);
      }
      return val[prop];
    }
  }) as T;
}

// Exportar instancias lazy (solo se inicializan cuando se usan)
export const auth = createLazyGetter<Auth>(() => {
  if (!authInstance) {
    authInstance = getAuth(getFirebaseApp());
  }
  return authInstance;
});

export const db = createLazyGetter<Firestore>(() => {
  if (!dbInstance) {
    dbInstance = getFirestore(getFirebaseApp());
    if (!dbInstance) {
      throw new Error('Firestore no se pudo inicializar');
    }
  }
  return dbInstance;
});

export const storage = createLazyGetter<FirebaseStorage>(() => {
  if (!storageInstance) {
    storageInstance = getStorage(getFirebaseApp());
  }
  return storageInstance;
});

// Export default también lazy
const getDefaultApp = () => getFirebaseApp();
export default getDefaultApp;
