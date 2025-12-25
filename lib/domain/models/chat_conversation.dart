import 'package:equatable/equatable.dart';

class ChatConversation extends Equatable {
  final String id;
  final String recipientId;
  final String recipientName;
  final String? recipientAvatarUrl;
  final String? productId;
  final String? productTitle;
  final String? productImageUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasUnreadMessages;
  final int unreadCount;

  const ChatConversation({
    required this.id,
    required this.recipientId,
    required this.recipientName,
    this.recipientAvatarUrl,
    this.productId,
    this.productTitle,
    this.productImageUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    this.hasUnreadMessages = false,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        recipientId,
        recipientName,
        recipientAvatarUrl,
        productId,
        productTitle,
        productImageUrl,
        lastMessage,
        lastMessageTime,
        hasUnreadMessages,
        unreadCount,
      ];
}

