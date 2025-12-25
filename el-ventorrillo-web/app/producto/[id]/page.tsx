// app/producto/[id]/page.tsx
import { notFound } from 'next/navigation';
import Image from 'next/image';
import Link from 'next/link';
import { getProductById } from '@/lib/firestore';
import { formatCurrency, formatDate, getCategoryLabel, getTypeColor, getTypeLabel } from '@/lib/utils';
import { ProductType } from '@/types/product';
import ContactSellerButton from '@/components/ContactSellerButton';
import ShareButton from '@/components/ShareButton';
import FavoriteButton from '@/components/FavoriteButton';
import type { Metadata } from 'next';

interface PageProps {
  params: Promise<{
    id: string;
  }>;
}

export default async function ProductDetailPage({ params }: PageProps) {
  const { id } = await params;
  
  // Validar que el ID existe
  if (!id) {
    notFound();
  }
  
  const product = await getProductById(id);

  if (!product) {
    notFound();
  }

  const typeColor = getTypeColor(product.type);
  const typeLabel = getTypeLabel(product.type);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header con botón de volver */}
      <header className="sticky top-0 z-10 bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center h-16">
            <Link
              href="/"
              className="flex items-center text-gray-600 hover:text-gray-900 transition-colors"
            >
              <svg
                className="w-6 h-6 mr-2"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M15 19l-7-7 7-7"
                />
              </svg>
              Volver
            </Link>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* Galería de imágenes */}
          <div className="space-y-4">
            {product.imageUrls.length > 0 ? (
              <>
                {/* Imagen principal */}
                <div className="relative aspect-square bg-gray-200 rounded-lg overflow-hidden">
                  <Image
                    src={product.imageUrls[0]}
                    alt={product.title}
                    fill
                    className="object-cover"
                    priority
                    sizes="(max-width: 1024px) 100vw, 50vw"
                  />
                </div>
                
                {/* Miniaturas (si hay más de una imagen) */}
                {product.imageUrls.length > 1 && (
                  <div className="grid grid-cols-4 gap-4">
                    {product.imageUrls.slice(1, 5).map((url, index) => (
                      <div
                        key={index}
                        className="relative aspect-square bg-gray-200 rounded-lg overflow-hidden"
                      >
                        <Image
                          src={url}
                          alt={`${product.title} - Imagen ${index + 2}`}
                          fill
                          className="object-cover"
                          sizes="(max-width: 1024px) 25vw, 12.5vw"
                        />
                      </div>
                    ))}
                  </div>
                )}
              </>
            ) : (
              <div className="relative aspect-square bg-gray-200 rounded-lg overflow-hidden flex items-center justify-center">
                <svg
                  className="w-24 h-24 text-gray-400"
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
          </div>

          {/* Información del producto */}
          <div className="space-y-6">
            {/* Badge de tipo */}
            <div>
              <span
                className="inline-block px-4 py-2 rounded-full text-sm font-semibold text-white"
                style={{ backgroundColor: typeColor }}
              >
                {typeLabel}
              </span>
            </div>

            {/* Título con acciones */}
            <div className="flex items-start justify-between gap-4">
              <h1 className="text-3xl font-bold text-gray-900 flex-1">{product.title}</h1>
              <div className="flex items-center gap-2 flex-shrink-0">
                <FavoriteButton productId={product.id} />
                <ShareButton productId={product.id} productTitle={product.title} />
              </div>
            </div>

            {/* Precio */}
            <div>
              <p
                className="text-4xl font-bold"
                style={{ color: typeColor }}
              >
                {formatCurrency(product.price)}
              </p>
            </div>

            {/* Información adicional */}
            <div className="grid grid-cols-2 gap-4 py-4 border-t border-b border-gray-200">
              <div>
                <p className="text-sm text-gray-500 mb-1">Categoría</p>
                <p className="font-medium text-gray-900">
                  {getCategoryLabel(product.category)}
                </p>
              </div>
              <div>
                <p className="text-sm text-gray-500 mb-1">Ubicación</p>
                <div className="flex items-center">
                  <svg
                    className="w-4 h-4 mr-1 text-gray-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"
                    />
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"
                    />
                  </svg>
                  <p className="font-medium text-gray-900">{product.location}</p>
                </div>
              </div>
            </div>

            {/* Fecha de publicación */}
            <div className="flex items-center text-sm text-gray-500">
              <svg
                className="w-4 h-4 mr-2"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
                />
              </svg>
              Publicado {formatDate(product.createdAt)}
            </div>

            {/* Descripción */}
            <div className="bg-white border-2 border-blue-500 rounded-lg p-6">
              <h2 className="text-xl font-bold text-gray-900 mb-4">Descripción</h2>
              <div className="bg-yellow-50 p-4 rounded">
                <p className="text-gray-700 whitespace-pre-wrap leading-relaxed">
                  {product.description}
                </p>
              </div>
            </div>

            {/* Información del vendedor */}
            <div className="bg-white rounded-lg p-6 border border-gray-200 space-y-4">
              <h2 className="text-xl font-bold text-gray-900">Vendedor</h2>
              <div className="flex items-center">
                <div
                  className="w-12 h-12 rounded-full flex items-center justify-center mr-4"
                  style={{ backgroundColor: `${typeColor}20` }}
                >
                  <svg
                    className="w-6 h-6"
                    style={{ color: typeColor }}
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"
                    />
                  </svg>
                </div>
                <div className="flex-1">
                  <p className="font-semibold text-gray-900">{product.sellerName}</p>
                  <p
                    className="text-sm"
                    style={{ color: typeColor }}
                  >
                    Ver perfil
                  </p>
                </div>
                <svg
                  className="w-5 h-5 text-gray-400"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M9 5l7 7-7 7"
                  />
                </svg>
              </div>
              
              {/* Botón de contactar */}
              <ContactSellerButton
                sellerId={product.sellerId}
                sellerName={product.sellerName}
                productId={product.id}
                productTitle={product.title}
                productImageUrl={product.imageUrls[0]}
              />
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}

