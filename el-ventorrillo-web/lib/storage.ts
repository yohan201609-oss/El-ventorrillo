// lib/storage.ts
import { ref, uploadBytes, getDownloadURL } from 'firebase/storage';
import { storage } from './firebase';

/**
 * Sube múltiples imágenes de producto a Firebase Storage
 * @param files Array de archivos de imagen
 * @param userId ID del usuario que está subiendo las imágenes
 * @returns Array de URLs de las imágenes subidas
 */
export async function uploadProductImages(
  files: File[],
  userId: string
): Promise<string[]> {
  if (!files || files.length === 0) {
    throw new Error('Debes seleccionar al menos una imagen');
  }

  if (files.length > 5) {
    throw new Error('No puedes subir más de 5 imágenes');
  }

  const uploadPromises = files.map(async (file, index) => {
    // Validar que sea una imagen
    if (!file.type.startsWith('image/')) {
      throw new Error(`El archivo ${file.name} no es una imagen válida`);
    }

    // Validar tamaño (máximo 5MB por imagen)
    const maxSize = 5 * 1024 * 1024; // 5MB
    if (file.size > maxSize) {
      throw new Error(`La imagen ${file.name} es demasiado grande. Máximo 5MB`);
    }

    // Crear nombre único para la imagen
    const timestamp = Date.now();
    const fileName = `products/${userId}/${timestamp}_${index}_${file.name}`;
    
    // Crear referencia en Storage
    const storageRef = ref(storage, fileName);
    
    // Subir archivo
    await uploadBytes(storageRef, file);
    
    // Obtener URL de descarga
    const downloadURL = await getDownloadURL(storageRef);
    
    return downloadURL;
  });

  try {
    const urls = await Promise.all(uploadPromises);
    return urls;
  } catch (error: any) {
    console.error('Error subiendo imágenes:', error);
    throw new Error(error.message || 'Error al subir las imágenes');
  }
}

