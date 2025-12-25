// components/Navbar.tsx
'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { 
  Menu, 
  X, 
  Search, 
  User, 
  ShoppingBag,
  Home,
  Sparkles,
  Package,
  LogOut
} from 'lucide-react';
import Image from 'next/image';
import { ProductType } from '@/types/product';
import { useAuth } from '@/hooks/useAuth';
import { logoutUser } from '@/lib/auth';

export default function Navbar() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const pathname = usePathname();
  const router = useRouter();
  const { isAuthenticated, userProfile, loading } = useAuth();

  const handleLogout = async () => {
    try {
      await logoutUser();
      router.push('/');
    } catch (error) {
      console.error('Error al cerrar sesión:', error);
    }
  };

  // Detectar scroll para agregar shadow
  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 10);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  // Cerrar menú móvil al cambiar de ruta
  useEffect(() => {
    setIsMobileMenuOpen(false);
  }, [pathname]);

  // Manejar búsqueda
  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      router.push(`/productos?search=${encodeURIComponent(searchQuery.trim())}`);
      setSearchQuery('');
    }
  };

  const isActive = (path: string) => pathname === path;

  return (
    <nav
      className={`sticky top-0 z-50 bg-white transition-shadow duration-200 ${
        isScrolled ? 'shadow-md' : 'shadow-sm'
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo y Brand */}
          <div className="flex items-center flex-shrink-0">
            <Link href="/" className="flex items-center space-x-2 group">
              <div className="relative w-10 h-10 flex-shrink-0">
                <div className="relative w-full h-full rounded-full overflow-hidden">
                  <Image
                    src="/logo_ventorrillo.png"
                    alt="El Ventorrillo Logo"
                    fill
                    className="object-cover"
                    priority
                    sizes="40px"
                  />
                </div>
              </div>
              <div className="flex flex-col">
                <span className="text-xl font-bold text-gray-900">El Ventorrillo</span>
                <span className="text-xs text-[#002D62] font-semibold -mt-1">Marketplace</span>
              </div>
            </Link>
          </div>

          {/* Barra de búsqueda - Desktop */}
          <div className="hidden md:flex flex-1 max-w-lg mx-8">
            <form onSubmit={handleSearch} className="w-full">
              <div className="relative">
                <input
                  type="text"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  placeholder="Buscar productos..."
                  className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#002D62] focus:border-[#002D62] transition-colors"
                />
                <Search className="absolute left-3 top-2.5 w-5 h-5 text-gray-400" />
                <button
                  type="submit"
                  className="absolute right-2 top-1.5 px-3 py-1 bg-[#002D62] text-white text-sm rounded-md hover:bg-[#001d47] transition-colors"
                >
                  Buscar
                </button>
              </div>
            </form>
          </div>

          {/* Links de navegación - Desktop */}
          <div className="hidden lg:flex items-center space-x-1">
            <Link
              href="/"
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                isActive('/')
                  ? 'bg-[#002D62] text-white'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              <div className="flex items-center space-x-2">
                <Home className="w-4 h-4" />
                <span>Inicio</span>
              </div>
            </Link>
            <Link
              href="/productos?type=artesanal"
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                pathname.includes('/productos') && pathname.includes('artesanal')
                  ? 'bg-[#F59E0B] text-white'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              <div className="flex items-center space-x-2">
                <Sparkles className="w-4 h-4" />
                <span>Lo Nuestro</span>
              </div>
            </Link>
            <Link
              href="/productos?type=segundaMano"
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                pathname.includes('/productos') && pathname.includes('segundaMano')
                  ? 'bg-[#10B981] text-white'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              <div className="flex items-center space-x-2">
                <Package className="w-4 h-4" />
                <span>El Reguero</span>
              </div>
            </Link>
            <Link
              href="/productos"
              className={`px-4 py-2 rounded-lg font-medium transition-colors ${
                isActive('/productos')
                  ? 'bg-[#002D62] text-white'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              Productos
            </Link>
          </div>

          {/* Botones de acción - Desktop */}
          <div className="hidden lg:flex items-center space-x-3 ml-4">
            <Link
              href="/publicar"
              className="px-4 py-2 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all duration-200 hover:scale-105"
            >
              Vender Producto
            </Link>
            {!loading && (
              <>
                {isAuthenticated ? (
                  <div className="flex items-center space-x-3">
                    <Link
                      href="/perfil"
                      className="px-4 py-2 border-2 border-[#002D62] text-[#002D62] rounded-lg font-medium hover:bg-[#002D62] hover:text-white transition-colors"
                    >
                      <div className="flex items-center space-x-2">
                        <User className="w-4 h-4" />
                        <span>{userProfile?.displayName || 'Perfil'}</span>
                      </div>
                    </Link>
                    <button
                      onClick={handleLogout}
                      className="px-4 py-2 text-gray-700 rounded-lg font-medium hover:bg-gray-100 transition-colors"
                      title="Cerrar sesión"
                    >
                      <LogOut className="w-4 h-4" />
                    </button>
                  </div>
                ) : (
                  <Link
                    href="/login"
                    className="px-4 py-2 border-2 border-[#002D62] text-[#002D62] rounded-lg font-medium hover:bg-[#002D62] hover:text-white transition-colors"
                  >
                    <div className="flex items-center space-x-2">
                      <User className="w-4 h-4" />
                      <span>Login</span>
                    </div>
                  </Link>
                )}
              </>
            )}
          </div>

          {/* Botón menú hamburguesa - Mobile */}
          <button
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            className="lg:hidden p-2 rounded-lg text-gray-700 hover:bg-gray-100 transition-colors"
            aria-label="Toggle menu"
          >
            {isMobileMenuOpen ? (
              <X className="w-6 h-6" />
            ) : (
              <Menu className="w-6 h-6" />
            )}
          </button>
        </div>

        {/* Barra de búsqueda - Mobile */}
        <div className="md:hidden pb-4">
          <form onSubmit={handleSearch} className="w-full">
            <div className="relative">
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Buscar productos..."
                className="w-full pl-10 pr-20 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-[#002D62] focus:border-[#002D62]"
              />
              <Search className="absolute left-3 top-2.5 w-5 h-5 text-gray-400" />
              <button
                type="submit"
                className="absolute right-2 top-1.5 px-3 py-1 bg-[#002D62] text-white text-sm rounded-md hover:bg-[#001d47] transition-colors"
              >
                Buscar
              </button>
            </div>
          </form>
        </div>
      </div>

      {/* Menú móvil */}
      {isMobileMenuOpen && (
        <div className="lg:hidden border-t border-gray-200 bg-white">
          <div className="px-4 py-4 space-y-2">
            <Link
              href="/"
              onClick={() => setIsMobileMenuOpen(false)}
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-colors ${
                isActive('/')
                  ? 'bg-[#002D62] text-white'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              <Home className="w-5 h-5" />
              <span>Inicio</span>
            </Link>
            <Link
              href="/productos?type=artesanal"
              onClick={() => setIsMobileMenuOpen(false)}
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-colors ${
                pathname.includes('/productos') && pathname.includes('artesanal')
                  ? 'bg-[#F59E0B] text-white'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              <Sparkles className="w-5 h-5" />
              <span>Lo Nuestro</span>
            </Link>
            <Link
              href="/productos?type=segundaMano"
              onClick={() => setIsMobileMenuOpen(false)}
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-colors ${
                pathname.includes('/productos') && pathname.includes('segundaMano')
                  ? 'bg-[#10B981] text-white'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              <Package className="w-5 h-5" />
              <span>El Reguero</span>
            </Link>
            <Link
              href="/productos"
              onClick={() => setIsMobileMenuOpen(false)}
              className={`flex items-center space-x-3 px-4 py-3 rounded-lg font-medium transition-colors ${
                isActive('/productos')
                  ? 'bg-[#002D62] text-white'
                  : 'text-gray-700 hover:bg-gray-100'
              }`}
            >
              <ShoppingBag className="w-5 h-5" />
              <span>Productos</span>
            </Link>
            <div className="pt-4 border-t border-gray-200 space-y-2">
              <Link
                href="/publicar"
                onClick={() => setIsMobileMenuOpen(false)}
                className="flex items-center justify-center w-full px-4 py-3 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all"
              >
                Vender Producto
              </Link>
              {!loading && (
                <>
                  {isAuthenticated ? (
                    <>
                      <Link
                        href="/perfil"
                        onClick={() => setIsMobileMenuOpen(false)}
                        className="flex items-center justify-center space-x-2 w-full px-4 py-3 border-2 border-[#002D62] text-[#002D62] rounded-lg font-medium hover:bg-[#002D62] hover:text-white transition-colors"
                      >
                        <User className="w-5 h-5" />
                        <span>{userProfile?.displayName || 'Perfil'}</span>
                      </Link>
                      <button
                        onClick={() => {
                          handleLogout();
                          setIsMobileMenuOpen(false);
                        }}
                        className="flex items-center justify-center space-x-2 w-full px-4 py-3 text-gray-700 rounded-lg font-medium hover:bg-gray-100 transition-colors"
                      >
                        <LogOut className="w-5 h-5" />
                        <span>Cerrar Sesión</span>
                      </button>
                    </>
                  ) : (
                    <Link
                      href="/login"
                      onClick={() => setIsMobileMenuOpen(false)}
                      className="flex items-center justify-center space-x-2 w-full px-4 py-3 border-2 border-[#002D62] text-[#002D62] rounded-lg font-medium hover:bg-[#002D62] hover:text-white transition-colors"
                    >
                      <User className="w-5 h-5" />
                      <span>Login</span>
                    </Link>
                  )}
                </>
              )}
            </div>
          </div>
        </div>
      )}
    </nav>
  );
}

