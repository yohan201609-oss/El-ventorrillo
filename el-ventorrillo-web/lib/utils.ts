// lib/utils.ts
import { format } from 'date-fns';
import { es } from 'date-fns/locale/es';
import { ProductType, ProductCategory } from '@/types/product';

// Formatear moneda en pesos dominicanos (DOP)
export function formatCurrency(amount: number): string {
  return new Intl.NumberFormat('es-DO', {
    style: 'currency',
    currency: 'DOP',
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
}

// Formatear fecha en español
export function formatDate(date: Date | string): string {
  const dateObj = typeof date === 'string' ? new Date(date) : date;
  
  // Si la fecha es de hoy, mostrar "Hoy"
  const today = new Date();
  if (
    dateObj.getDate() === today.getDate() &&
    dateObj.getMonth() === today.getMonth() &&
    dateObj.getFullYear() === today.getFullYear()
  ) {
    return 'Hoy';
  }
  
  // Si es de ayer, mostrar "Ayer"
  const yesterday = new Date(today);
  yesterday.setDate(yesterday.getDate() - 1);
  if (
    dateObj.getDate() === yesterday.getDate() &&
    dateObj.getMonth() === yesterday.getMonth() &&
    dateObj.getFullYear() === yesterday.getFullYear()
  ) {
    return 'Ayer';
  }
  
  // Si es de esta semana, mostrar el día de la semana
  const daysDiff = Math.floor((today.getTime() - dateObj.getTime()) / (1000 * 60 * 60 * 24));
  if (daysDiff < 7) {
    return format(dateObj, 'EEEE', { locale: es });
  }
  
  // Si es de este año, mostrar día y mes
  if (dateObj.getFullYear() === today.getFullYear()) {
    return format(dateObj, 'd MMM', { locale: es });
  }
  
  // Si es de otro año, mostrar fecha completa
  return format(dateObj, 'd MMM yyyy', { locale: es });
}

// Obtener etiqueta de categoría en español
export function getCategoryLabel(category: ProductCategory): string {
  const labels: Record<ProductCategory, string> = {
    [ProductCategory.JOYERIA]: 'Joyería',
    [ProductCategory.DULCES]: 'Dulces',
    [ProductCategory.ARTE_TAINO]: 'Arte Taíno',
    [ProductCategory.PINTURAS]: 'Pinturas',
    [ProductCategory.ARTESANIA_GENERAL]: 'Artesanía General',
    [ProductCategory.ROPA]: 'Ropa',
    [ProductCategory.ELECTRONICA]: 'Electrónica',
    [ProductCategory.MUEBLES]: 'Muebles',
    [ProductCategory.LIBROS]: 'Libros',
    [ProductCategory.DEPORTES]: 'Deportes',
    [ProductCategory.OTROS]: 'Otros',
  };
  
  return labels[category] || 'Otros';
}

// Obtener color según el tipo de producto
export function getTypeColor(type: ProductType): string {
  return type === ProductType.ARTESANAL 
    ? '#F59E0B' // Amber para artesanal (Lo Nuestro)
    : '#10B981'; // Green para segunda mano (El Reguero)
}

// Obtener etiqueta del tipo de producto
export function getTypeLabel(type: ProductType): string {
  return type === ProductType.ARTESANAL 
    ? 'Artesanal'
    : 'Segunda Mano';
}

