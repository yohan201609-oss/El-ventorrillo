// components/ProductCard.tsx
'use client';

import Link from 'next/link';
import Image from 'next/image';
import { ProductCardProps } from '@/types/product';
import { formatCurrency, formatDate, getTypeColor, getTypeLabel } from '@/lib/utils';

export default function ProductCard({ product }: ProductCardProps) {
  const typeColor = getTypeColor(product.type);
  const typeLabel = getTypeLabel(product.type);

  return (
    <Link 
      href={`/producto/${product.id}`}
      className="group block bg-white rounded-lg shadow-sm hover:shadow-md transition-all duration-200 overflow-hidden"
    >
      {/* Imagen del producto */}
      <div className="relative aspect-square bg-gray-200 overflow-hidden">
        {product.imageUrls.length > 0 ? (
          <Image
            src={product.imageUrls[0]}
            alt={product.title}
            fill
            className="object-cover group-hover:scale-105 transition-transform duration-200"
            sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center">
            <svg 
              className="w-16 h-16 text-gray-400" 
              fill="none" 
              stroke="currentColor" 
              viewBox="0 0 24 24"
            >
              <path 
                strokeLinecap="round" 
                strokeLinejoin="round" 
                strokeWidth={2} 
                d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" 
              />
            </svg>
          </div>
        )}
        
        {/* Badge de tipo */}
        <div className="absolute top-2 left-2">
          <span 
            className="px-3 py-1 rounded-full text-xs font-semibold text-white"
            style={{ backgroundColor: typeColor }}
          >
            {typeLabel}
          </span>
        </div>
      </div>

      {/* Información del producto */}
      <div className="p-4">
        <h3 className="font-semibold text-gray-900 line-clamp-2 mb-2 group-hover:text-gray-700">
          {product.title}
        </h3>
        
        <p className="text-2xl font-bold mb-2" style={{ color: typeColor }}>
          {formatCurrency(product.price)}
        </p>

        <div className="flex items-center text-sm text-gray-500 mb-1">
          <svg className="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
          <span className="line-clamp-1">{product.location}</span>
        </div>

        <div className="flex items-center text-xs text-gray-400">
          <svg className="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          {formatDate(product.createdAt)}
        </div>
      </div>
    </Link>
  );
}

