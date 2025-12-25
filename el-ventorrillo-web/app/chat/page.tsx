// app/chat/page.tsx
'use client';

import { useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/hooks/useAuth';
import { getConversations, Conversation } from '@/lib/chat';
import { formatDate } from '@/lib/utils';
import AuthGuard from '@/components/AuthGuard';
import { MessageSquare, Package, User } from 'lucide-react';

// Forzar renderizado dinámico (no prerenderizar)
export const dynamic = 'force-dynamic';

export default function ChatListPage() {
  const router = useRouter();
  const { user, loading: authLoading } = useAuth();
  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!user) return;

    setLoading(true);
    const unsubscribe = getConversations(user.uid, (convs) => {
      setConversations(convs);
      setLoading(false);
    });

    return () => unsubscribe();
  }, [user]);

  const getOtherParticipant = (conversation: Conversation) => {
    if (!user) return null;
    const otherId = conversation.participants.find((id) => id !== user.uid);
    if (!otherId) return null;
    return {
      id: otherId,
      name: conversation.participantNames[otherId] || 'Usuario',
    };
  };

  const getUnreadCount = (conversation: Conversation): number => {
    if (!user) return 0;
    return conversation.unreadCount?.[user.uid] || 0;
  };

  if (authLoading || loading) {
    return (
      <AuthGuard requireAuth={true}>
        <div className="min-h-screen bg-gray-50 flex items-center justify-center">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#002D62] mx-auto mb-4"></div>
            <p className="text-gray-600">Cargando conversaciones...</p>
          </div>
        </div>
      </AuthGuard>
    );
  }

  return (
    <AuthGuard requireAuth={true}>
      <div className="min-h-screen bg-gray-50">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Header */}
          <div className="mb-6">
            <h1 className="text-3xl font-bold text-gray-900 mb-2">Mensajes</h1>
            <p className="text-gray-600">Tus conversaciones</p>
          </div>

          {/* Lista de conversaciones */}
          {conversations.length === 0 ? (
            <div className="bg-white rounded-lg shadow-sm p-12 text-center">
              <MessageSquare className="w-16 h-16 text-gray-400 mx-auto mb-4" />
              <h3 className="text-lg font-semibold text-gray-900 mb-2">
                No tienes conversaciones
              </h3>
              <p className="text-gray-600 mb-6">
                Inicia una conversación desde la página de un producto
              </p>
              <Link
                href="/productos"
                className="inline-block px-6 py-3 bg-gradient-to-r from-[#CE1126] to-[#002D62] text-white rounded-lg font-semibold hover:shadow-lg transition-all"
              >
                Ver Productos
              </Link>
            </div>
          ) : (
            <div className="bg-white rounded-lg shadow-sm overflow-hidden">
              {conversations.map((conversation) => {
                const otherUser = getOtherParticipant(conversation);
                const unreadCount = getUnreadCount(conversation);

                if (!otherUser) return null;

                return (
                  <Link
                    key={conversation.id}
                    href={`/chat/${conversation.id}`}
                    className="block border-b border-gray-200 hover:bg-gray-50 transition-colors"
                  >
                    <div className="p-4 flex items-center gap-4">
                      {/* Avatar */}
                      <div className="w-12 h-12 rounded-full bg-[#002D62] flex items-center justify-center flex-shrink-0">
                        <User className="w-6 h-6 text-white" />
                      </div>

                      {/* Contenido */}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between mb-1">
                          <h3 className="font-semibold text-gray-900 truncate">
                            {otherUser.name}
                          </h3>
                          <span className="text-xs text-gray-500 flex-shrink-0 ml-2">
                            {formatDate(conversation.lastMessageAt)}
                          </span>
                        </div>

                        {/* Producto relacionado */}
                        {conversation.productTitle && (
                          <div className="flex items-center gap-1 mb-1">
                            <Package className="w-3 h-3 text-gray-400" />
                            <span className="text-xs text-gray-500 truncate">
                              {conversation.productTitle}
                            </span>
                          </div>
                        )}

                        {/* Último mensaje */}
                        <div className="flex items-center justify-between">
                          <p
                            className={`text-sm truncate ${
                              unreadCount > 0 ? 'font-semibold text-gray-900' : 'text-gray-600'
                            }`}
                          >
                            {conversation.lastMessage || 'Sin mensajes'}
                          </p>
                          {unreadCount > 0 && (
                            <span className="bg-[#CE1126] text-white text-xs font-semibold px-2 py-1 rounded-full flex-shrink-0 ml-2">
                              {unreadCount}
                            </span>
                          )}
                        </div>
                      </div>
                    </div>
                  </Link>
                );
              })}
            </div>
          )}
        </div>
      </div>
    </AuthGuard>
  );
}

