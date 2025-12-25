import 'package:el_ventorrillo/domain/models/chat_conversation.dart';
import 'package:el_ventorrillo/domain/models/chat_message.dart';

abstract class ChatRepository {
  // Conversaciones
  Stream<List<ChatConversation>> getConversations(String userId);
  Future<ChatConversation?> getConversationById(String chatId);
  Future<String> createConversation({
    required String userId1,
    required String userId2,
    required String userName1,
    required String userName2,
    String? productId,
    String? productTitle,
    String? productImageUrl,
  });

  // Mensajes
  Stream<List<ChatMessage>> getMessages(String chatId);
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String text,
  });
  Future<void> markMessagesAsRead(String chatId, String userId);
  Future<int> getUnreadCount(String chatId, String userId);
}

