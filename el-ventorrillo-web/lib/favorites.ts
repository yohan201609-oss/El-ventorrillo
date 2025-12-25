// lib/favorites.ts
import {
  collection,
  doc,
  setDoc,
  deleteDoc,
  getDoc,
  getDocs,
  query,
  where,
  Timestamp,
} from 'firebase/firestore';
import { db } from './firebase';

export interface Favorite {
  id: string;
  userId: string;
  productId: string;
  createdAt: Date;
}

// Agregar a favoritos
export async function addToFavorites(userId: string, productId: string): Promise<void> {
  try {
    const favoriteId = `${userId}_${productId}`;
    const favoriteRef = doc(db, 'favorites', favoriteId);
    
    await setDoc(favoriteRef, {
      userId,
      productId,
      createdAt: Timestamp.now(),
    });
  } catch (error: any) {
    console.error('Error agregando a favoritos:', error);
    throw new Error('Error al agregar a favoritos');
  }
}

// Eliminar de favoritos
export async function removeFromFavorites(userId: string, productId: string): Promise<void> {
  try {
    const favoriteId = `${userId}_${productId}`;
    const favoriteRef = doc(db, 'favorites', favoriteId);
    await deleteDoc(favoriteRef);
  } catch (error: any) {
    console.error('Error eliminando de favoritos:', error);
    throw new Error('Error al eliminar de favoritos');
  }
}

// Verificar si está en favoritos
export async function isFavorite(userId: string, productId: string): Promise<boolean> {
  try {
    const favoriteId = `${userId}_${productId}`;
    const favoriteRef = doc(db, 'favorites', favoriteId);
    const favoriteSnap = await getDoc(favoriteRef);
    return favoriteSnap.exists();
  } catch (error) {
    console.error('Error verificando favorito:', error);
    return false;
  }
}

// Obtener favoritos del usuario
export async function getUserFavorites(userId: string): Promise<string[]> {
  try {
    const q = query(
      collection(db, 'favorites'),
      where('userId', '==', userId)
    );
    const snapshot = await getDocs(q);
    return snapshot.docs.map((doc) => doc.data().productId);
  } catch (error) {
    console.error('Error obteniendo favoritos:', error);
    return [];
  }
}

