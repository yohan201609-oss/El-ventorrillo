// lib/chat.ts
import {
  collection,
  doc,
  addDoc,
  setDoc,
  updateDoc,
  query,
  where,
  orderBy,
  onSnapshot,
  Timestamp,
  getDoc,
  getDocs,
  writeBatch,
  QueryDocumentSnapshot,
  DocumentData,
} from 'firebase/firestore';
import { db } from './firebase';
import { Timestamp as FirestoreTimestamp } from 'firebase/firestore';

// Helper para convertir diferentes formatos de fecha a Date
function parseDate(value: any): Date {
  if (!value) {
    return new Date();
  }
  
  // Si es un Timestamp de Firestore
  if (value instanceof FirestoreTimestamp) {
    return value.toDate();
  }
  
  // Si tiene el método toDate (otro tipo de Timestamp)
  if (typeof value.toDate === 'function') {
    return value.toDate();
  }
  
  // Si ya es un Date
  if (value instanceof Date) {
    return value;
  }
  
  // Si es un string ISO8601
  if (typeof value === 'string') {
    const parsed = new Date(value);
    if (!isNaN(parsed.getTime())) {
      return parsed;
    }
  }
  
  // Si es un número (timestamp en milisegundos)
  if (typeof value === 'number') {
    return new Date(value);
  }
  
  // Fallback: fecha actual
  return new Date();
}

export interface ChatMessage {
  id: string;
  senderId: string;
  senderName: string;
  text: string;
  createdAt: Date;
  read: boolean;
}

export interface Conversation {
  id: string;
  participants: string[];
  participantNames: Record<string, string>;
  lastMessage: string;
  lastMessageAt: Date;
  productId?: string;
  productTitle?: string;
  productImageUrl?: string;
  createdAt: Date;
  unreadCount?: Record<string, number>;
}

// Crear o obtener conversación existente
export async function createOrGetConversation(
  userId1: string,
  userId2: string,
  userName1: string,
  userName2: string,
  productId?: string,
  productTitle?: string,
  productImageUrl?: string
): Promise<string> {
  try {
    if (!db) {
      throw new Error('Firestore no está inicializado');
    }

    // Validar que los usuarios sean diferentes
    if (userId1 === userId2) {
      throw new Error('No puedes crear una conversación contigo mismo');
    }

    // Crear ID único basado en participantes ordenados
    const participants = [userId1, userId2].sort();
    const conversationId = participants.join('_');

    // Verificar si ya existe
    const conversationRef = doc(db, 'conversations', conversationId);
    const conversationSnap = await getDoc(conversationRef);

    if (conversationSnap.exists()) {
      return conversationId;
    }

    // Crear nueva conversación
    const conversationData = {
      participants,
      participantNames: {
        [userId1]: userName1,
        [userId2]: userName2,
      },
      lastMessage: '',
      lastMessageAt: Timestamp.now(),
      createdAt: Timestamp.now(),
      productId: productId || null,
      productTitle: productTitle || null,
      productImageUrl: productImageUrl || null,
      unreadCount: {
        [userId1]: 0,
        [userId2]: 0,
      },
    };

    // Log para depuración
    console.log('Creando conversación con datos:', {
      conversationId,
      participants,
      currentUserId: userId1,
      conversationData
    });

    await setDoc(conversationRef, conversationData);

    return conversationId;
  } catch (error: any) {
    console.error('Error creando conversación:', error);
    console.error('Código de error:', error.code);
    console.error('Mensaje de error:', error.message);
    
    // Proporcionar mensajes de error más específicos
    if (error.code === 'permission-denied' || error.code === 'PERMISSION_DENIED') {
      throw new Error('No tienes permisos para crear conversaciones. Verifica que estés autenticado y que las reglas de Firestore estén configuradas correctamente.');
    } else if (error.message) {
      throw error;
    }
    
    throw new Error('Error al crear la conversación. Por favor, intenta de nuevo.');
  }
}

// Obtener conversaciones del usuario
export function getConversations(
  userId: string,
  callback: (conversations: Conversation[]) => void
): () => void {
  const q = query(
    collection(db, 'conversations'),
    where('participants', 'array-contains', userId),
    orderBy('lastMessageAt', 'desc')
  );

  return onSnapshot(q, (snapshot) => {
    const conversations: Conversation[] = snapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        id: doc.id,
        participants: data.participants || [],
        participantNames: data.participantNames || {},
        lastMessage: data.lastMessage || '',
        lastMessageAt: parseDate(data.lastMessageAt),
        productId: data.productId,
        productTitle: data.productTitle,
        productImageUrl: data.productImageUrl,
        createdAt: parseDate(data.createdAt),
        unreadCount: data.unreadCount || {},
      };
    });
    callback(conversations);
  });
}

// Obtener conversación por ID
export async function getConversationById(conversationId: string): Promise<Conversation | null> {
  try {
    const conversationRef = doc(db, 'conversations', conversationId);
    const conversationSnap = await getDoc(conversationRef);

    if (!conversationSnap.exists()) {
      return null;
    }

    const data = conversationSnap.data();
    return {
      id: conversationSnap.id,
      participants: data.participants || [],
      participantNames: data.participantNames || {},
      lastMessage: data.lastMessage || '',
      lastMessageAt: parseDate(data.lastMessageAt),
      productId: data.productId,
      productTitle: data.productTitle,
      productImageUrl: data.productImageUrl,
      createdAt: parseDate(data.createdAt),
      unreadCount: data.unreadCount || {},
    };
  } catch (error) {
    console.error('Error obteniendo conversación:', error);
    return null;
  }
}

// Obtener mensajes en tiempo real
export function getMessages(
  conversationId: string,
  callback: (messages: ChatMessage[]) => void
): () => void {
  const messagesRef = collection(db, 'conversations', conversationId, 'messages');
  const q = query(messagesRef, orderBy('createdAt', 'asc'));

  return onSnapshot(q, (snapshot) => {
    const messages: ChatMessage[] = snapshot.docs.map((doc) => {
      const data = doc.data();
      return {
        id: doc.id,
        senderId: data.senderId,
        senderName: data.senderName,
        text: data.text,
        createdAt: parseDate(data.createdAt),
        read: data.read || false,
      };
    });
    callback(messages);
  });
}

// Enviar mensaje
export async function sendMessage(
  conversationId: string,
  senderId: string,
  senderName: string,
  text: string
): Promise<void> {
  try {
    const batch = writeBatch(db);

    // Crear mensaje
    const messagesRef = collection(db, 'conversations', conversationId, 'messages');
    const messageRef = doc(messagesRef);
    batch.set(messageRef, {
      senderId,
      senderName,
      text: text.trim(),
      createdAt: Timestamp.now(),
      read: false,
    });

    // Actualizar conversación
    const conversationRef = doc(db, 'conversations', conversationId);
    batch.update(conversationRef, {
      lastMessage: text.trim(),
      lastMessageAt: Timestamp.now(),
    });

    await batch.commit();
  } catch (error: any) {
    console.error('Error enviando mensaje:', error);
    throw new Error('Error al enviar el mensaje');
  }
}

// Marcar mensajes como leídos
export async function markMessagesAsRead(
  conversationId: string,
  userId: string
): Promise<void> {
  try {
    const messagesRef = collection(db, 'conversations', conversationId, 'messages');
    const q = query(
      messagesRef,
      where('senderId', '!=', userId),
      where('read', '==', false)
    );

    const snapshot = await getDocs(q);
    const batch = writeBatch(db);

    snapshot.docs.forEach((doc) => {
      batch.update(doc.ref, { read: true });
    });

    // Actualizar contador de no leídos
    const conversationRef = doc(db, 'conversations', conversationId);
    batch.update(conversationRef, {
      [`unreadCount.${userId}`]: 0,
    });

    await batch.commit();
  } catch (error) {
    console.error('Error marcando mensajes como leídos:', error);
  }
}

