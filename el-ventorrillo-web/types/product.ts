// types/product.ts
export enum ProductType {
  ARTESANAL = 'artesanal',
  SEGUNDA_MANO = 'segundaMano',
}

export enum ProductCategory {
  // Artesanales
  JOYERIA = 'joyeria',
  DULCES = 'dulces',
  ARTE_TAINO = 'arteTaino',
  PINTURAS = 'pinturas',
  ARTESANIA_GENERAL = 'artesaniaGeneral',
  // Segunda Mano
  ROPA = 'ropa',
  ELECTRONICA = 'electronica',
  MUEBLES = 'muebles',
  LIBROS = 'libros',
  DEPORTES = 'deportes',
  OTROS = 'otros',
}

export interface Product {
  id: string;
  title: string;
  description: string;
  price: number;
  imageUrls: string[];
  type: ProductType;
  category: ProductCategory;
  location: string;
  sellerId: string;
  sellerName: string;
  createdAt: Date;
  isNew: boolean;
}

export interface ProductCardProps {
  product: Product;
}

