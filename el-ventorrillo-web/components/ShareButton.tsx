// components/ShareButton.tsx
'use client';

import { useState } from 'react';
import { Share2, Copy, Check } from 'lucide-react';
import toast from 'react-hot-toast';

interface ShareButtonProps {
  productId: string;
  productTitle: string;
  className?: string;
}

export default function ShareButton({ productId, productTitle, className = '' }: ShareButtonProps) {
  const [copied, setCopied] = useState(false);

  const shareUrl = typeof window !== 'undefined' 
    ? `${window.location.origin}/producto/${productId}`
    : '';

  const handleShare = async () => {
    if (navigator.share) {
      try {
        await navigator.share({
          title: productTitle,
          text: `Mira este producto en El Ventorrillo: ${productTitle}`,
          url: shareUrl,
        });
        toast.success('¡Producto compartido!');
      } catch (error: any) {
        if (error.name !== 'AbortError') {
          console.error('Error compartiendo:', error);
          handleCopy();
        }
      }
    } else {
      handleCopy();
    }
  };

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(shareUrl);
      setCopied(true);
      toast.success('¡Link copiado al portapapeles!');
      setTimeout(() => setCopied(false), 2000);
    } catch (error) {
      console.error('Error copiando:', error);
      toast.error('Error al copiar el link');
    }
  };

  return (
    <button
      onClick={handleShare}
      className={`flex items-center gap-2 px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors ${className}`}
      aria-label="Compartir producto"
    >
      {copied ? (
        <>
          <Check className="w-4 h-4 text-green-600" />
          <span className="text-sm text-green-600">Copiado</span>
        </>
      ) : (
        <>
          <Share2 className="w-4 h-4 text-gray-700" />
          <span className="text-sm text-gray-700">Compartir</span>
        </>
      )}
    </button>
  );
}

