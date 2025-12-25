// components/ContactSellerButton.tsx
'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/hooks/useAuth';
import { createOrGetConversation } from '@/lib/chat';
import { MessageSquare, Loader2 } from 'lucide-react';
import toast from 'react-hot-toast';

interface ContactSellerButtonProps {
  sellerId: string;
  sellerName: string;
  productId: string;
  productTitle: string;
  productImageUrl?: string;
}

export default function ContactSellerButton({
  sellerId,
  sellerName,
  productId,
  productTitle,
  productImageUrl,
}: ContactSellerButtonProps) {
  const router = useRouter();
  const { user, userProfile } = useAuth();
  const [loading, setLoading] = useState(false);

  const handleContact = async () => {
    if (!user || !userProfile) {
      router.push(`/login?redirect=/producto/${productId}`);
      return;
    }

    if (user.uid === sellerId) {
      toast.error('No puedes contactarte contigo mismo');
      return;
    }

    setLoading(true);
    try {
      // Verificar autenticación antes de crear
      if (!user || !user.uid) {
        throw new Error('Usuario no autenticado');
      }

      console.log('Intentando crear conversación:', {
        userId: user.uid,
        sellerId,
        userName: userProfile.displayName,
        sellerName
      });

      const conversationId = await createOrGetConversation(
        user.uid,
        sellerId,
        userProfile.displayName,
        sellerName,
        productId,
        productTitle,
        productImageUrl
      );
      toast.success('Conversación creada');
      router.push(`/chat/${conversationId}`);
    } catch (error: any) {
      console.error('Error creando conversación:', error);
      console.error('Error completo:', JSON.stringify(error, null, 2));
      
      // Mensajes de error más específicos
      let errorMessage = 'Error al crear la conversación';
      if (error.message?.includes('permission') || error.message?.includes('Permission') || error.code === 'permission-denied') {
        errorMessage = 'No tienes permisos. Verifica que estés autenticado y que las reglas de Firestore estén publicadas.';
      } else if (error.message) {
        errorMessage = error.message;
      }
      
      toast.error(errorMessage);
      setLoading(false);
    }
  };

  return (
    <button
      onClick={handleContact}
      disabled={loading}
      className="w-full flex items-center justify-center gap-2 px-6 py-3 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed"
    >
      {loading ? (
        <>
          <Loader2 className="w-5 h-5 animate-spin" />
          <span>Creando conversación...</span>
        </>
      ) : (
        <>
          <MessageSquare className="w-5 h-5" />
          <span>Contactar Vendedor</span>
        </>
      )}
    </button>
  );
}

