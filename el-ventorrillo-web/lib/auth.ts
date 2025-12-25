// lib/auth.ts
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  sendPasswordResetEmail,
  updateProfile,
  User,
  onAuthStateChanged as firebaseOnAuthStateChanged,
  NextOrObserver,
  signInWithPopup,
  GoogleAuthProvider,
} from 'firebase/auth';
import { auth } from './firebase';
import { doc, setDoc, getDoc } from 'firebase/firestore';
import { db } from './firebase';
import { Timestamp } from 'firebase/firestore';

export interface UserProfile {
  uid: string;
  email: string;
  displayName: string;
  photoURL?: string;
  createdAt: Date;
}

// Traducir errores de Firebase a español
export function getAuthErrorMessage(errorCode: string): string {
  const errorMessages: Record<string, string> = {
    'auth/email-already-in-use': 'Este correo electrónico ya está registrado.',
    'auth/invalid-email': 'El correo electrónico no es válido.',
    'auth/operation-not-allowed': 'Esta operación no está permitida.',
    'auth/weak-password': 'La contraseña es muy débil. Debe tener al menos 6 caracteres.',
    'auth/user-disabled': 'Esta cuenta ha sido deshabilitada.',
    'auth/user-not-found': 'No existe una cuenta con este correo electrónico.',
    'auth/wrong-password': 'La contraseña es incorrecta.',
    'auth/invalid-credential': 'Las credenciales son incorrectas.',
    'auth/too-many-requests': 'Demasiados intentos fallidos. Por favor, intenta más tarde.',
    'auth/network-request-failed': 'Error de conexión. Verifica tu internet.',
    'auth/popup-closed-by-user': 'La ventana de autenticación fue cerrada.',
    'auth/cancelled-popup-request': 'La solicitud de autenticación fue cancelada.',
  };

  return errorMessages[errorCode] || 'Ocurrió un error inesperado. Por favor, intenta de nuevo.';
}

// Registrar nuevo usuario
export async function registerUser(
  email: string,
  password: string,
  displayName: string
): Promise<User> {
  try {
    // Validaciones
    if (!email || !email.includes('@')) {
      throw new Error('Por favor, ingresa un correo electrónico válido.');
    }
    if (!password || password.length < 6) {
      throw new Error('La contraseña debe tener al menos 6 caracteres.');
    }
    if (!displayName || displayName.trim().length < 2) {
      throw new Error('El nombre debe tener al menos 2 caracteres.');
    }

    // Crear usuario en Firebase Auth
    const userCredential = await createUserWithEmailAndPassword(auth, email, password);
    const user = userCredential.user;

    // Actualizar perfil con el nombre
    await updateProfile(user, {
      displayName: displayName.trim(),
    });

    // Crear perfil en Firestore
    const userProfile: UserProfile = {
      uid: user.uid,
      email: user.email || email,
      displayName: displayName.trim(),
      photoURL: user.photoURL || undefined,
      createdAt: new Date(),
    };

    await setDoc(doc(db, 'users', user.uid), userProfile);

    return user;
  } catch (error: any) {
    if (error.code) {
      throw new Error(getAuthErrorMessage(error.code));
    }
    throw error;
  }
}

// Iniciar sesión
export async function loginUser(email: string, password: string): Promise<User> {
  try {
    // Validaciones
    if (!email || !email.includes('@')) {
      throw new Error('Por favor, ingresa un correo electrónico válido.');
    }
    if (!password) {
      throw new Error('Por favor, ingresa tu contraseña.');
    }

    const userCredential = await signInWithEmailAndPassword(auth, email, password);
    return userCredential.user;
  } catch (error: any) {
    if (error.code) {
      throw new Error(getAuthErrorMessage(error.code));
    }
    throw error;
  }
}

// Cerrar sesión
export async function logoutUser(): Promise<void> {
  try {
    await signOut(auth);
  } catch (error: any) {
    if (error.code) {
      throw new Error(getAuthErrorMessage(error.code));
    }
    throw error;
  }
}

// Recuperar contraseña
export async function resetPassword(email: string): Promise<void> {
  try {
    if (!email || !email.includes('@')) {
      throw new Error('Por favor, ingresa un correo electrónico válido.');
    }

    await sendPasswordResetEmail(auth, email);
  } catch (error: any) {
    if (error.code) {
      throw new Error(getAuthErrorMessage(error.code));
    }
    throw error;
  }
}

// Helper para convertir diferentes formatos de fecha a Date
function parseDate(value: any): Date {
  if (!value) {
    return new Date();
  }
  
  // Si es un Timestamp de Firestore
  if (value instanceof Timestamp) {
    return value.toDate();
  }
  
  // Si tiene el método toDate (otro tipo de Timestamp)
  if (typeof value.toDate === 'function') {
    return value.toDate();
  }
  
  // Si ya es un Date
  if (value instanceof Date) {
    return value;
  }
  
  // Si es un string ISO8601
  if (typeof value === 'string') {
    const parsed = new Date(value);
    if (!isNaN(parsed.getTime())) {
      return parsed;
    }
  }
  
  // Si es un número (timestamp en milisegundos)
  if (typeof value === 'number') {
    return new Date(value);
  }
  
  // Fallback: fecha actual
  return new Date();
}

// Obtener perfil del usuario desde Firestore
export async function getUserProfile(uid: string): Promise<UserProfile | null> {
  try {
    const userDoc = await getDoc(doc(db, 'users', uid));
    if (userDoc.exists()) {
      const data = userDoc.data();
      return {
        uid: data.uid,
        email: data.email,
        displayName: data.displayName,
        photoURL: data.photoURL,
        createdAt: parseDate(data.createdAt),
      };
    }
    return null;
  } catch (error) {
    console.error('Error obteniendo perfil de usuario:', error);
    return null;
  }
}

// Iniciar sesión con Google
export async function loginWithGoogle(): Promise<User> {
  try {
    const provider = new GoogleAuthProvider();
    const result = await signInWithPopup(auth, provider);
    const user = result.user;

    // Verificar si el usuario ya existe en Firestore
    const userDoc = await getDoc(doc(db, 'users', user.uid));
    
    // Si no existe, crear su perfil en Firestore
    if (!userDoc.exists()) {
      const userProfile: UserProfile = {
        uid: user.uid,
        email: user.email || '',
        displayName: user.displayName || 'Usuario',
        photoURL: user.photoURL || undefined,
        createdAt: new Date(),
      };

      await setDoc(doc(db, 'users', user.uid), userProfile);
    } else {
      // Si existe, actualizar la foto de perfil si cambió
      const existingData = userDoc.data();
      if (user.photoURL && existingData.photoURL !== user.photoURL) {
        await setDoc(
          doc(db, 'users', user.uid),
          { photoURL: user.photoURL },
          { merge: true }
        );
      }
    }

    return user;
  } catch (error: any) {
    if (error.code) {
      throw new Error(getAuthErrorMessage(error.code));
    }
    throw error;
  }
}

// Observar cambios en el estado de autenticación
export function onAuthStateChanged(callback: NextOrObserver<User>) {
  return firebaseOnAuthStateChanged(auth, callback);
}

