// components/FavoriteButton.tsx
'use client';

import { useState, useEffect } from 'react';
import { Heart } from 'lucide-react';
import { useAuth } from '@/hooks/useAuth';
import { addToFavorites, removeFromFavorites, isFavorite } from '@/lib/favorites';
import toast from 'react-hot-toast';

interface FavoriteButtonProps {
  productId: string;
  className?: string;
}

export default function FavoriteButton({ productId, className = '' }: FavoriteButtonProps) {
  const { user } = useAuth();
  const [favorited, setFavorited] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      checkFavorite();
    } else {
      setLoading(false);
    }
  }, [user, productId]);

  const checkFavorite = async () => {
    if (!user) return;
    try {
      const favorite = await isFavorite(user.uid, productId);
      setFavorited(favorite);
    } catch (error) {
      console.error('Error verificando favorito:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleToggle = async () => {
    if (!user) {
      toast.error('Debes iniciar sesión para agregar a favoritos');
      return;
    }

    try {
      if (favorited) {
        await removeFromFavorites(user.uid, productId);
        setFavorited(false);
        toast.success('Eliminado de favoritos');
      } else {
        await addToFavorites(user.uid, productId);
        setFavorited(true);
        toast.success('Agregado a favoritos');
      }
    } catch (error: any) {
      console.error('Error actualizando favorito:', error);
      toast.error(error.message || 'Error al actualizar favoritos');
    }
  };

  if (loading) {
    return (
      <button
        className={`p-2 rounded-lg bg-gray-100 ${className}`}
        disabled
      >
        <Heart className="w-5 h-5 text-gray-400" />
      </button>
    );
  }

  return (
    <button
      onClick={handleToggle}
      className={`p-2 rounded-lg transition-colors ${
        favorited
          ? 'bg-red-50 text-red-600 hover:bg-red-100'
          : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
      } ${className}`}
      aria-label={favorited ? 'Eliminar de favoritos' : 'Agregar a favoritos'}
    >
      <Heart className={`w-5 h-5 ${favorited ? 'fill-current' : ''}`} />
    </button>
  );
}

