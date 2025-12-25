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

// Validar que las variables de entorno estén configuradas
if (!firebaseConfig.apiKey || !firebaseConfig.projectId) {
  console.error('Error: Las variables de entorno de Firebase no están configuradas correctamente.');
  console.error('Verifica que el archivo .env.local existe y contiene las variables NEXT_PUBLIC_FIREBASE_*');
}

// Inicializar Firebase solo si no está ya inicializado
let app: FirebaseApp;
if (getApps().length === 0) {
  try {
    app = initializeApp(firebaseConfig);
    console.log('Firebase inicializado correctamente');
  } catch (error) {
    console.error('Error inicializando Firebase:', error);
    throw error;
  }
} else {
  app = getApps()[0];
}

// Exportar servicios de Firebase con validación
let authInstance: Auth;
let dbInstance: Firestore;
let storageInstance: FirebaseStorage;

try {
  authInstance = getAuth(app);
  dbInstance = getFirestore(app);
  storageInstance = getStorage(app);
  
  // Validar que las instancias se crearon correctamente
  if (!dbInstance) {
    console.error('Error: No se pudo inicializar Firestore');
    throw new Error('Firestore no se pudo inicializar');
  }
} catch (error) {
  console.error('Error creando instancias de Firebase:', error);
  throw error;
}

export const auth: Auth = authInstance;
export const db: Firestore = dbInstance;
export const storage: FirebaseStorage = storageInstance;

export default app;

