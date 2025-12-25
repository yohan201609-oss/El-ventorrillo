// app/not-found.tsx
import Link from 'next/link';
import { Home, Search, Package } from 'lucide-react';

export default function NotFound() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-[#CE1126] via-[#002D62] to-[#CE1126] flex items-center justify-center p-4">
      <div className="max-w-md w-full text-center">
        <div className="bg-white rounded-2xl shadow-2xl p-8">
          {/* 404 Icon */}
          <div className="mb-6">
            <div className="inline-flex items-center justify-center w-24 h-24 bg-gradient-to-br from-[#CE1126] to-[#002D62] rounded-full mb-4">
              <Package className="w-12 h-12 text-white" />
            </div>
            <h1 className="text-6xl font-bold text-gray-900 mb-2">404</h1>
            <h2 className="text-2xl font-semibold text-gray-800 mb-2">
              Página no encontrada
            </h2>
            <p className="text-gray-600">
              Lo sentimos, la página que buscas no existe o ha sido movida.
            </p>
          </div>

          {/* Action Buttons */}
          <div className="space-y-3">
            <Link
              href="/"
              className="w-full flex items-center justify-center gap-2 px-6 py-3 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all"
            >
              <Home className="w-5 h-5" />
              Ir al Inicio
            </Link>
            <Link
              href="/productos"
              className="w-full flex items-center justify-center gap-2 px-6 py-3 border-2 border-[#002D62] text-[#002D62] rounded-lg font-semibold hover:bg-[#002D62] hover:text-white transition-all"
            >
              <Search className="w-5 h-5" />
              Buscar Productos
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}

