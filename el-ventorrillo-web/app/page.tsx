// app/page.tsx
import { getProducts } from '@/lib/firestore';
import ProductCard from '@/components/ProductCard';
import Link from 'next/link';
import type { Metadata } from 'next';
import ChatButton from '@/components/ChatButton';

export const metadata: Metadata = {
  title: 'El Ventorrillo - Marketplace de Artesanías y Segunda Mano',
  description: 'Plataforma de compra y venta de productos artesanales y de segunda mano en República Dominicana. Descubre artesanías únicas y productos usados.',
  openGraph: {
    title: 'El Ventorrillo - Marketplace de Artesanías y Segunda Mano',
    description: 'Plataforma de compra y venta de productos artesanales y de segunda mano en República Dominicana',
    type: 'website',
  },
};

export default async function Home() {
  let products = [];
  let error = null;

  try {
    products = await getProducts();
  } catch (err) {
    error = err;
    console.error('Error cargando productos:', err);
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero Section */}
      <section className="relative bg-gradient-to-br from-[#CE1126] via-[#6B1839] to-[#002D62] text-white overflow-hidden">
        {/* Textura/Noise */}
        <div 
          className="absolute inset-0 opacity-[0.15]" 
          style={{
            backgroundImage: `url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' /%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)' /%3E%3C/svg%3E")`,
          }}
        ></div>
        {/* Brillo sutil */}
        <div className="absolute inset-0 bg-gradient-to-t from-transparent via-white/5 to-white/10"></div>
        {/* Contenido */}
        <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
          <div className="text-center">
            <h2 className="text-4xl font-bold mb-4">
              Bienvenido a El Ventorrillo
            </h2>
            <p className="text-xl mb-8 text-green-50">
              Tu marketplace de artesanías y productos de segunda mano en República Dominicana
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                href="/productos"
                className="bg-white text-green-600 px-6 py-3 rounded-lg font-semibold hover:bg-gray-100 transition-colors"
              >
                Ver Productos
              </Link>
              <Link
                href="/publicar"
                className="bg-transparent border-2 border-white text-white px-6 py-3 rounded-lg font-semibold hover:bg-white hover:text-green-600 transition-colors"
              >
                Vender Producto
              </Link>
            </div>
            {/* Botón de Mensajes - Solo visible si está autenticado */}
            <div className="mt-6">
              <ChatButton />
            </div>
          </div>
        </div>
      </section>

      {/* Products Section */}
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-8">
          <h2 className="text-3xl font-bold text-gray-900 mb-2">
            Productos Destacados
          </h2>
          <p className="text-gray-600">
            Descubre artesanías únicas y productos de segunda mano
          </p>
        </div>

        {error ? (
          <div className="bg-red-50 border border-red-200 rounded-lg p-6 text-center">
            <p className="text-red-800 font-medium mb-2">
              Error al cargar los productos
            </p>
            <p className="text-red-600 text-sm">
              Por favor, verifica tu conexión a Firebase
            </p>
          </div>
        ) : products.length === 0 ? (
          <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-12 text-center">
            <svg
              className="w-16 h-16 text-yellow-400 mx-auto mb-4"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"
              />
            </svg>
            <p className="text-yellow-800 font-medium mb-2">
              No hay productos disponibles
            </p>
            <p className="text-yellow-600 text-sm">
              Sé el primero en publicar un producto
            </p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {products.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>
        )}
      </main>

      {/* Footer */}
      <footer className="bg-white border-t border-gray-200 mt-16">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="text-center text-gray-600">
            <p className="font-semibold text-gray-900 mb-2">El Ventorrillo</p>
            <p className="text-sm">
              Marketplace de artesanías y productos de segunda mano
            </p>
            <p className="text-xs mt-4 text-gray-500">
              © {new Date().getFullYear()} El Ventorrillo. Todos los derechos reservados.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
