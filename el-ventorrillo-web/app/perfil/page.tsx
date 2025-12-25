// app/perfil/page.tsx
'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Image from 'next/image';
import Link from 'next/link';
import { useAuth } from '@/hooks/useAuth';
import { getUserProducts, deleteProduct } from '@/lib/firestore';
import { Product } from '@/types/product';
import { formatCurrency, formatDate } from '@/lib/utils';
import AuthGuard from '@/components/AuthGuard';
import Loading from '@/components/Loading';
import ProductCard from '@/components/ProductCard';
import toast from 'react-hot-toast';
import { 
  User, 
  Mail, 
  Calendar, 
  Package, 
  Edit, 
  Trash2, 
  Plus,
  LogOut,
  Settings,
  MessageSquare
} from 'lucide-react';
import { logoutUser } from '@/lib/auth';

export default function ProfilePage() {
  const router = useRouter();
  const { user, userProfile, loading: authLoading } = useAuth();
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const [deletingId, setDeletingId] = useState<string | null>(null);

  useEffect(() => {
    if (user) {
      loadProducts();
    }
  }, [user]);

  const loadProducts = async () => {
    if (!user) return;
    try {
      setLoading(true);
      const userProducts = await getUserProducts(user.uid);
      setProducts(userProducts);
    } catch (error: any) {
      console.error('Error cargando productos:', error);
      toast.error('Error al cargar tus productos');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (productId: string) => {
    if (!user) return;
    
    if (!confirm('¿Estás seguro de que deseas eliminar este producto?')) {
      return;
    }

    try {
      setDeletingId(productId);
      await deleteProduct(productId, user.uid);
      setProducts(products.filter(p => p.id !== productId));
      toast.success('Producto eliminado correctamente');
    } catch (error: any) {
      console.error('Error eliminando producto:', error);
      toast.error(error.message || 'Error al eliminar el producto');
    } finally {
      setDeletingId(null);
    }
  };

  const handleLogout = async () => {
    try {
      await logoutUser();
      toast.success('Sesión cerrada correctamente');
      router.push('/');
    } catch (error: any) {
      toast.error('Error al cerrar sesión');
    }
  };

  if (authLoading || loading) {
    return (
      <AuthGuard requireAuth={true}>
        <Loading fullScreen message="Cargando perfil..." />
      </AuthGuard>
    );
  }

  if (!user || !userProfile) {
    return null;
  }

  return (
    <AuthGuard requireAuth={true}>
      <div className="min-h-screen bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Header del perfil */}
          <div className="bg-white rounded-lg shadow-sm p-6 mb-6">
            <div className="flex flex-col md:flex-row items-start md:items-center gap-6">
              {/* Avatar */}
              <div className="w-24 h-24 rounded-full bg-gradient-to-br from-[#CE1126] to-[#002D62] flex items-center justify-center flex-shrink-0">
                {userProfile.photoURL ? (
                  <Image
                    src={userProfile.photoURL}
                    alt={userProfile.displayName}
                    width={96}
                    height={96}
                    className="rounded-full"
                  />
                ) : (
                  <User className="w-12 h-12 text-white" />
                )}
              </div>

              {/* Información */}
              <div className="flex-1">
                <h1 className="text-3xl font-bold text-gray-900 mb-2">
                  {userProfile.displayName}
                </h1>
                <div className="space-y-2 text-gray-600">
                  <div className="flex items-center gap-2">
                    <Mail className="w-4 h-4" />
                    <span>{userProfile.email}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <Calendar className="w-4 h-4" />
                    <span>Miembro desde {formatDate(userProfile.createdAt)}</span>
                  </div>
                </div>
              </div>

              {/* Acciones */}
              <div className="flex gap-3 flex-wrap">
                <Link
                  href="/chat"
                  className="flex items-center gap-2 px-4 py-2 bg-[#002D62] text-white rounded-lg font-semibold hover:bg-[#001d47] transition-colors"
                >
                  <MessageSquare className="w-5 h-5" />
                  Mensajes
                </Link>
                <Link
                  href="/publicar"
                  className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all"
                >
                  <Plus className="w-5 h-5" />
                  Publicar Producto
                </Link>
                <button
                  onClick={handleLogout}
                  className="flex items-center gap-2 px-4 py-2 border-2 border-gray-300 text-gray-700 rounded-lg font-semibold hover:bg-gray-50 transition-colors"
                >
                  <LogOut className="w-5 h-5" />
                  Salir
                </button>
              </div>
            </div>
          </div>

          {/* Estadísticas */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
            <div className="bg-white rounded-lg shadow-sm p-6">
              <div className="flex items-center gap-3">
                <div className="w-12 h-12 rounded-full bg-blue-100 flex items-center justify-center">
                  <Package className="w-6 h-6 text-blue-600" />
                </div>
                <div>
                  <p className="text-2xl font-bold text-gray-900">{products.length}</p>
                  <p className="text-sm text-gray-600">Productos Publicados</p>
                </div>
              </div>
            </div>
          </div>

          {/* Productos publicados */}
          <div>
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-gray-900">Mis Productos</h2>
              <Link
                href="/publicar"
                className="flex items-center gap-2 px-4 py-2 bg-[#002D62] text-white rounded-lg font-semibold hover:bg-[#001d47] transition-colors"
              >
                <Plus className="w-5 h-5" />
                Nuevo Producto
              </Link>
            </div>

            {products.length === 0 ? (
              <div className="bg-white rounded-lg shadow-sm p-12 text-center">
                <Package className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                <h3 className="text-lg font-semibold text-gray-900 mb-2">
                  No has publicado productos aún
                </h3>
                <p className="text-gray-600 mb-6">
                  Comienza a vender tus productos artesanales o de segunda mano
                </p>
                <Link
                  href="/publicar"
                  className="inline-block px-6 py-3 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all"
                >
                  Publicar mi Primer Producto
                </Link>
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                {products.map((product) => (
                  <div key={product.id} className="relative group">
                    <ProductCard product={product} />
                    <div className="absolute top-2 right-2 flex gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                      <Link
                        href={`/producto/${product.id}`}
                        className="p-2 bg-white rounded-lg shadow-md hover:bg-gray-50 transition-colors"
                        title="Ver producto"
                      >
                        <Settings className="w-4 h-4 text-gray-700" />
                      </Link>
                      <button
                        onClick={() => handleDelete(product.id)}
                        disabled={deletingId === product.id}
                        className="p-2 bg-red-500 text-white rounded-lg shadow-md hover:bg-red-600 transition-colors disabled:opacity-50"
                        title="Eliminar producto"
                      >
                        {deletingId === product.id ? (
                          <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                        ) : (
                          <Trash2 className="w-4 h-4" />
                        )}
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </AuthGuard>
  );
}

