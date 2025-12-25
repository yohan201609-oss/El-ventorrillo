import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:el_ventorrillo/data/repositories/chat_repository.dart';
import 'package:el_ventorrillo/data/repositories/firestore_chat_repository.dart';
import 'package:el_ventorrillo/domain/models/chat_conversation.dart';
import 'package:el_ventorrillo/domain/models/chat_message.dart';

part 'chat_provider.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return FirestoreChatRepository();
}

@riverpod
Stream<List<ChatConversation>> chatConversations(ChatConversationsRef ref) {
  final repository = ref.watch(chatRepositoryProvider);
  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  if (userId.isEmpty) {
    return Stream.value([]);
  }

  return repository.getConversations(userId);
}

@riverpod
Future<ChatConversation?> chatConversationById(
  ChatConversationByIdRef ref,
  String chatId,
) async {
  final repository = ref.watch(chatRepositoryProvider);
  return await repository.getConversationById(chatId);
}

@riverpod
Stream<List<ChatMessage>> chatMessages(ChatMessagesRef ref, String chatId) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages(chatId);
}

@riverpod
class SendMessage extends _$SendMessage {
  @override
  FutureOr<void> build() {}

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(chatRepositoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      state = AsyncValue.error('Usuario no autenticado', StackTrace.current);
      return;
    }

    try {
      await repository.sendMessage(
        chatId: chatId,
        senderId: user.uid,
        senderName: user.displayName ?? 'Usuario',
        text: text,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

@riverpod
class CreateChat extends _$CreateChat {
  @override
  FutureOr<String?> build() => null;

  Future<String?> createChat({
    required String recipientId,
    required String recipientName,
    String? productId,
    String? productTitle,
    String? productImageUrl,
  }) async {
    state = const AsyncValue.loading();

    final repository = ref.read(chatRepositoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      state = AsyncValue.error('Usuario no autenticado', StackTrace.current);
      return null;
    }

    try {
      final chatId = await repository.createConversation(
        userId1: user.uid,
        userId2: recipientId,
        userName1: user.displayName ?? 'Usuario',
        userName2: recipientName,
        productId: productId,
        productTitle: productTitle,
        productImageUrl: productImageUrl,
      );

      state = AsyncValue.data(chatId);
      return chatId;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      return null;
    }
  }
}

@riverpod
class MarkMessagesAsRead extends _$MarkMessagesAsRead {
  @override
  FutureOr<void> build() {}

  Future<void> markAsRead(String chatId) async {
    final repository = ref.read(chatRepositoryProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) return;

    try {
      await repository.markMessagesAsRead(chatId, userId);
    } catch (e) {
      // Silenciar errores de lectura
    }
  }
}

