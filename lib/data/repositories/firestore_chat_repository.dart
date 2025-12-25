import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:el_ventorrillo/data/repositories/chat_repository.dart';
import 'package:el_ventorrillo/domain/models/chat_conversation.dart';
import 'package:el_ventorrillo/domain/models/chat_message.dart';

class FirestoreChatRepository implements ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Colecciones
  static const String _chatsCollection = 'chats';
  static const String _messagesCollection = 'messages';

  @override
  Stream<List<ChatConversation>> getConversations(String userId) {
    return _firestore
        .collection(_chatsCollection)
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return _conversationFromMap(doc.id, data, userId);
      }).toList();
    });
  }

  @override
  Future<ChatConversation?> getConversationById(String chatId) async {
    try {
      final doc = await _firestore.collection(_chatsCollection).doc(chatId).get();
      if (!doc.exists) return null;

      final userId = _auth.currentUser?.uid ?? '';
      return _conversationFromMap(doc.id, doc.data()!, userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> createConversation({
    required String userId1,
    required String userId2,
    required String userName1,
    required String userName2,
    String? productId,
    String? productTitle,
    String? productImageUrl,
  }) async {
    // Crear ID único para la conversación basado en los participantes
    final participants = [userId1, userId2]..sort();
    final chatId = participants.join('_');

    // Verificar si ya existe una conversación
    final existingDoc = await _firestore
        .collection(_chatsCollection)
        .doc(chatId)
        .get();

    if (existingDoc.exists) {
      return chatId;
    }

    // Crear nueva conversación
    await _firestore.collection(_chatsCollection).doc(chatId).set({
      'participants': participants,
      'participantNames': {
        userId1: userName1,
        userId2: userName2,
      },
      'productId': productId,
      'productTitle': productTitle,
      'productImageUrl': productImageUrl,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
      'unreadCount': {
        userId1: 0,
        userId2: 0,
      },
    });

    return chatId;
  }

  @override
  Stream<List<ChatMessage>> getMessages(String chatId) {
    return _firestore
        .collection(_chatsCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  }) async {
    final batch = _firestore.batch();

    // Crear el mensaje
    final messageRef = _firestore
        .collection(_chatsCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .doc();

    final message = {
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    };

    batch.set(messageRef, message);

    // Actualizar la conversación
    final chatRef = _firestore.collection(_chatsCollection).doc(chatId);
    final chatDoc = await chatRef.get();
    final chatData = chatDoc.data()!;
    final participants = List<String>.from(chatData['participants']);

    // Incrementar contador de no leídos para el otro participante
    final otherUserId = participants.firstWhere((id) => id != senderId);
    final unreadCount = Map<String, dynamic>.from(chatData['unreadCount'] ?? {});
    unreadCount[otherUserId] = (unreadCount[otherUserId] ?? 0) + 1;

    batch.update(chatRef, {
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'unreadCount': unreadCount,
    });

    await batch.commit();
  }

  @override
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    final batch = _firestore.batch();

    // Marcar mensajes como leídos
    final messagesSnapshot = await _firestore
        .collection(_chatsCollection)
        .doc(chatId)
        .collection(_messagesCollection)
        .where('senderId', isNotEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in messagesSnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    // Actualizar contador de no leídos
    final chatRef = _firestore.collection(_chatsCollection).doc(chatId);
    final chatDoc = await chatRef.get();
    if (chatDoc.exists) {
      final unreadCount = Map<String, dynamic>.from(
        chatDoc.data()!['unreadCount'] ?? {},
      );
      unreadCount[userId] = 0;

      batch.update(chatRef, {'unreadCount': unreadCount});
    }

    await batch.commit();
  }

  @override
  Future<int> getUnreadCount(String chatId, String userId) async {
    try {
      final doc = await _firestore.collection(_chatsCollection).doc(chatId).get();
      if (!doc.exists) return 0;

      final unreadCount = doc.data()!['unreadCount'] as Map<String, dynamic>?;
      return (unreadCount?[userId] as int?) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Helper para convertir Map a ChatConversation
  ChatConversation _conversationFromMap(
    String id,
    Map<String, dynamic> data,
    String currentUserId,
  ) {
    final participants = List<String>.from(data['participants'] ?? []);
    final participantNames =
        Map<String, String>.from(data['participantNames'] ?? {});
    final otherUserId = participants.firstWhere((id) => id != currentUserId,
        orElse: () => participants.first);
    final recipientName = participantNames[otherUserId] ?? 'Usuario';

    final unreadCount = Map<String, dynamic>.from(data['unreadCount'] ?? {});
    final userUnreadCount = (unreadCount[currentUserId] as int?) ?? 0;

    final lastMessageTime = data['lastMessageTime'];
    DateTime timestamp;
    if (lastMessageTime is Timestamp) {
      timestamp = lastMessageTime.toDate();
    } else if (lastMessageTime is String) {
      timestamp = DateTime.parse(lastMessageTime);
    } else {
      timestamp = DateTime.now();
    }

    return ChatConversation(
      id: id,
      recipientId: otherUserId,
      recipientName: recipientName,
      recipientAvatarUrl: data['recipientAvatarUrl'] as String?,
      productId: data['productId'] as String?,
      productTitle: data['productTitle'] as String?,
      productImageUrl: data['productImageUrl'] as String?,
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageTime: timestamp,
      hasUnreadMessages: userUnreadCount > 0,
      unreadCount: userUnreadCount,
    );
  }
}

