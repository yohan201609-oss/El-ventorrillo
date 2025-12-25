// app/chat/[conversationId]/page.tsx
'use client';

import { useState, useEffect, useRef } from 'react';
import { useParams, useRouter } from 'next/navigation';
import Link from 'next/link';
import Image from 'next/image';
import { useAuth } from '@/hooks/useAuth';
import { getConversationById, getMessages, sendMessage, markMessagesAsRead, Conversation, ChatMessage } from '@/lib/chat';
import ChatMessageComponent from '@/components/ChatMessage';
import ChatInput from '@/components/ChatInput';
import AuthGuard from '@/components/AuthGuard';
import { ArrowLeft, Package, User, Loader2, MessageSquare } from 'lucide-react';

// Forzar renderizado dinámico (no prerenderizar)
export const dynamic = 'force-dynamic';

export default function ChatPage() {
  const params = useParams();
  const router = useRouter();
  const { user, userProfile, loading: authLoading } = useAuth();
  const conversationId = params.conversationId as string;

  const [conversation, setConversation] = useState<Conversation | null>(null);
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [loading, setLoading] = useState(true);
  const [sending, setSending] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const messagesContainerRef = useRef<HTMLDivElement>(null);

  // Scroll automático al último mensaje
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  // Cargar conversación
  useEffect(() => {
    if (!conversationId) return;

    async function loadConversation() {
      try {
        const conv = await getConversationById(conversationId);
        setConversation(conv);
      } catch (error) {
        console.error('Error cargando conversación:', error);
      }
    }

    loadConversation();
  }, [conversationId]);

  // Cargar mensajes en tiempo real
  useEffect(() => {
    if (!conversationId || !user) return;

    setLoading(true);
    const unsubscribe = getMessages(conversationId, (msgs) => {
      setMessages(msgs);
      setLoading(false);

      // Marcar mensajes como leídos
      if (user) {
        markMessagesAsRead(conversationId, user.uid);
      }
    });

    return () => unsubscribe();
  }, [conversationId, user]);

  // Obtener información del otro usuario
  const getOtherUser = () => {
    if (!user || !conversation) return null;
    const otherId = conversation.participants.find((id) => id !== user.uid);
    if (!otherId) return null;
    return {
      id: otherId,
      name: conversation.participantNames[otherId] || 'Usuario',
    };
  };

  const handleSendMessage = async (text: string) => {
    if (!user || !userProfile || !conversationId || sending) return;

    setSending(true);
    try {
      await sendMessage(conversationId, user.uid, userProfile.displayName, text);
    } catch (error: any) {
      console.error('Error enviando mensaje:', error);
      alert(error.message || 'Error al enviar el mensaje');
    } finally {
      setSending(false);
    }
  };

  const otherUser = getOtherUser();

  if (authLoading || loading) {
    return (
      <AuthGuard requireAuth={true}>
        <div className="min-h-screen bg-gray-50 flex items-center justify-center">
          <div className="text-center">
            <Loader2 className="w-12 h-12 animate-spin text-[#002D62] mx-auto mb-4" />
            <p className="text-gray-600">Cargando conversación...</p>
          </div>
        </div>
      </AuthGuard>
    );
  }

  if (!conversation || !otherUser) {
    return (
      <AuthGuard requireAuth={true}>
        <div className="min-h-screen bg-gray-50 flex items-center justify-center">
          <div className="text-center">
            <p className="text-gray-600 mb-4">Conversación no encontrada</p>
            <Link
              href="/chat"
              className="px-6 py-3 bg-[#002D62] text-white rounded-lg font-semibold hover:bg-[#001d47] transition-colors"
            >
              Volver a Mensajes
            </Link>
          </div>
        </div>
      </AuthGuard>
    );
  }

  return (
    <AuthGuard requireAuth={true}>
      <div className="min-h-screen bg-gray-50 flex flex-col">
        {/* Header */}
        <header className="bg-white border-b border-gray-200 sticky top-0 z-10">
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center h-16 gap-4">
              <Link
                href="/chat"
                className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
              >
                <ArrowLeft className="w-6 h-6 text-gray-600" />
              </Link>

              {/* Avatar */}
              <div className="w-10 h-10 rounded-full bg-[#002D62] flex items-center justify-center flex-shrink-0">
                <User className="w-5 h-5 text-white" />
              </div>

              {/* Información del usuario */}
              <div className="flex-1 min-w-0">
                <h2 className="font-semibold text-gray-900 truncate">{otherUser.name}</h2>
                {conversation.productTitle && (
                  <div className="flex items-center gap-1">
                    <Package className="w-3 h-3 text-gray-400" />
                    <Link
                      href={`/producto/${conversation.productId}`}
                      className="text-xs text-[#002D62] hover:underline truncate"
                    >
                      {conversation.productTitle}
                    </Link>
                  </div>
                )}
              </div>
            </div>
          </div>
        </header>

        {/* Área de mensajes */}
        <div
          ref={messagesContainerRef}
          className="flex-1 overflow-y-auto bg-gray-100"
          style={{ backgroundImage: 'url("data:image/svg+xml,%3Csvg width=\'60\' height=\'60\' viewBox=\'0 0 60 60\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cg fill=\'none\' fill-rule=\'evenodd\'%3E%3Cg fill=\'%23e5e7eb\' fill-opacity=\'0.4\'%3E%3Cpath d=\'M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z\'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")' }}
        >
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
            {messages.length === 0 ? (
              <div className="text-center py-12">
                <MessageSquare className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                <p className="text-gray-600">No hay mensajes aún</p>
                <p className="text-sm text-gray-500 mt-2">Envía el primer mensaje</p>
              </div>
            ) : (
              messages.map((message) => (
                <ChatMessageComponent
                  key={message.id}
                  message={message}
                  isOwn={message.senderId === user?.uid}
                />
              ))
            )}
            <div ref={messagesEndRef} />
          </div>
        </div>

        {/* Input de mensaje */}
        <ChatInput
          onSend={handleSendMessage}
          disabled={sending}
          placeholder="Escribe un mensaje..."
        />
      </div>
    </AuthGuard>
  );
}

