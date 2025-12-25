// components/ChatButton.tsx
'use client';

import Link from 'next/link';
import { useAuth } from '@/hooks/useAuth';
import { MessageSquare } from 'lucide-react';

export default function ChatButton() {
  const { isAuthenticated, loading } = useAuth();

  if (loading || !isAuthenticated) {
    return null;
  }

  return (
    <Link
      href="/chat"
      className="inline-flex items-center gap-2 px-6 py-3 bg-white/10 backdrop-blur-sm border-2 border-white/30 text-white rounded-lg font-semibold hover:bg-white/20 transition-all"
    >
      <MessageSquare className="w-5 h-5" />
      <span>Mis Mensajes</span>
    </Link>
  );
}

