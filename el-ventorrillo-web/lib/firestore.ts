// lib/firestore.ts
import { 
  collection, 
  doc, 
  getDocs, 
  getDoc, 
  query, 
  orderBy, 
  addDoc,
  deleteDoc,
  where,
  QueryDocumentSnapshot,
  DocumentData,
  Timestamp
} from 'firebase/firestore';
import { db } from './firebase';
import { Product, ProductType, ProductCategory } from '@/types/product';

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

// Convertir documento de Firestore a Product
function convertFirestoreProduct(doc: QueryDocumentSnapshot<DocumentData>): Product {
  const data = doc.data();
  return {
    id: doc.id,
    title: data.title || '',
    description: data.description || '',
    price: data.price || 0,
    imageUrls: data.imageUrls || [],
    type: data.type as ProductType,
    category: data.category as ProductCategory,
    location: data.location || '',
    sellerId: data.sellerId || '',
    sellerName: data.sellerName || '',
    createdAt: parseDate(data.createdAt),
    isNew: data.isNew ?? false,
  };
}

// Obtener todos los productos
export async function getProducts(): Promise<Product[]> {
  try {
    // Validar que db esté inicializado
    if (!db) {
      console.error('Error: Firestore db no está inicializado');
      throw new Error('Firestore no está inicializado. Verifica la configuración de Firebase.');
    }
    
    const productsRef = collection(db, 'products');
    const q = query(productsRef, orderBy('createdAt', 'desc'));
    const querySnapshot = await getDocs(q);
    
    return querySnapshot.docs.map(doc => convertFirestoreProduct(doc));
  } catch (error) {
    console.error('Error obteniendo productos:', error);
    throw error;
  }
}

// Obtener un producto por ID
export async function getProductById(id: string): Promise<Product | null> {
  try {
    // Validar que db esté inicializado
    if (!db) {
      console.error('Error: Firestore db no está inicializado');
      throw new Error('Firestore no está inicializado. Verifica la configuración de Firebase.');
    }
    
    // Validar que el ID no esté vacío
    if (!id || typeof id !== 'string') {
      console.error('Error: ID de producto inválido:', id);
      return null;
    }
    
    const productRef = doc(db, 'products', id);
    const productSnap = await getDoc(productRef);
    
    if (!productSnap.exists()) {
      return null;
    }
    
    return convertFirestoreProduct(productSnap as QueryDocumentSnapshot<DocumentData>);
  } catch (error) {
    console.error('Error obteniendo producto por ID:', error);
    throw error;
  }
}

// Crear nuevo producto
export async function createProduct(
  productData: Omit<Product, 'id' | 'createdAt'>
): Promise<string> {
  try {
    // Validar que db esté inicializado
    if (!db) {
      console.error('Error: Firestore db no está inicializado');
      throw new Error('Firestore no está inicializado. Verifica la configuración de Firebase.');
    }

    // Validaciones
    if (!productData.title || productData.title.trim().length < 3) {
      throw new Error('El título debe tener al menos 3 caracteres');
    }
    if (!productData.description || productData.description.trim().length < 10) {
      throw new Error('La descripción debe tener al menos 10 caracteres');
    }
    if (!productData.price || productData.price <= 0) {
      throw new Error('El precio debe ser mayor a 0');
    }
    if (!productData.imageUrls || productData.imageUrls.length === 0) {
      throw new Error('Debes subir al menos una imagen');
    }
    if (!productData.location || productData.location.trim().length === 0) {
      throw new Error('Debes especificar una ubicación');
    }
    if (!productData.sellerId || !productData.sellerName) {
      throw new Error('Información del vendedor requerida');
    }

    // Preparar datos para Firestore
    const productToSave = {
      title: productData.title.trim(),
      description: productData.description.trim(),
      price: productData.price,
      imageUrls: productData.imageUrls,
      type: productData.type,
      category: productData.category,
      location: productData.location.trim(),
      sellerId: productData.sellerId,
      sellerName: productData.sellerName.trim(),
      isNew: productData.isNew ?? false,
      createdAt: Timestamp.now(),
    };

    // Guardar en Firestore
    const docRef = await addDoc(collection(db, 'products'), productToSave);
    
    return docRef.id;
  } catch (error: any) {
    console.error('Error creando producto:', error);
    if (error.message) {
      throw error;
    }
    throw new Error('Error al crear el producto. Por favor, intenta de nuevo.');
  }
}

// Eliminar producto
export async function deleteProduct(productId: string, userId: string): Promise<void> {
  try {
    if (!db) {
      throw new Error('Firestore no está inicializado');
    }

    // Verificar que el producto existe y pertenece al usuario
    const productRef = doc(db, 'products', productId);
    const productSnap = await getDoc(productRef);

    if (!productSnap.exists()) {
      throw new Error('El producto no existe');
    }

    const productData = productSnap.data();
    if (productData.sellerId !== userId) {
      throw new Error('No tienes permiso para eliminar este producto');
    }

    // Eliminar producto
    await deleteDoc(productRef);
  } catch (error: any) {
    console.error('Error eliminando producto:', error);
    if (error.message) {
      throw error;
    }
    throw new Error('Error al eliminar el producto');
  }
}

// Obtener productos del usuario
export async function getUserProducts(userId: string): Promise<Product[]> {
  try {
    if (!db) {
      throw new Error('Firestore no está inicializado');
    }

    const productsRef = collection(db, 'products');
    const q = query(
      productsRef,
      where('sellerId', '==', userId),
      orderBy('createdAt', 'desc')
    );
    const querySnapshot = await getDocs(q);

    return querySnapshot.docs.map(doc => convertFirestoreProduct(doc));
  } catch (error) {
    console.error('Error obteniendo productos del usuario:', error);
    throw error;
  }
}

