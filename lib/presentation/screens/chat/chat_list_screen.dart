import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';
import 'package:el_ventorrillo/domain/models/chat_conversation.dart';
import 'package:el_ventorrillo/presentation/providers/chat_provider.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Ahora';
        }
        return 'Hace ${difference.inMinutes} min';
      }
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsAsync = ref.watch(chatConversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
      ),
      body: conversationsAsync.when(
        data: (conversations) => conversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: Responsive.isMobile(context) ? 64 : 80,
                    color: AppTheme.gray400,
                  ),
                  SizedBox(
                    height: Responsive.getSpacing(context, mobile: 16.0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.getHorizontalPadding(context),
                    ),
                    child: Text(
                      'No tienes conversaciones',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: Responsive.getSpacing(context, mobile: 8.0),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.getHorizontalPadding(context),
                    ),
                    child: Text(
                      'Cuando inicies una conversación, aparecerá aquí',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(
                vertical: Responsive.getSpacing(context, mobile: 8.0),
              ),
              itemCount: conversations.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                indent: Responsive.isMobile(context) ? 80 : 100,
                color: AppTheme.gray200,
              ),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                return _ChatListItem(
                  conversation: conversation,
                  formatTime: _formatTime,
                );
              },
            ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar conversaciones',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.red,
                    ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref.invalidate(chatConversationsProvider);
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatConversation conversation;
  final String Function(DateTime) formatTime;

  const _ChatListItem({
    required this.conversation,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = Responsive.getHorizontalPadding(context);
    final maxWidth = Responsive.getMaxContentWidth(context);

    return InkWell(
      onTap: () {
        // Usar go en lugar de push para evitar problemas de claves duplicadas
        context.go(
          '/chat/${conversation.id}?recipientName=${Uri.encodeComponent(conversation.recipientName)}&productTitle=${conversation.productTitle != null ? Uri.encodeComponent(conversation.productTitle!) : ''}',
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: Responsive.getSpacing(context, mobile: 12.0),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: Responsive.isMobile(context) ? 28 : 32,
                      backgroundColor: AppTheme.amberLight.withOpacity(0.2),
                      backgroundImage: conversation.recipientAvatarUrl != null
                          ? NetworkImage(conversation.recipientAvatarUrl!)
                          : null,
                      child: conversation.recipientAvatarUrl == null
                          ? Icon(
                              Icons.person,
                              size: Responsive.isMobile(context) ? 28 : 32,
                              color: AppTheme.amber,
                            )
                          : null,
                    ),
                    if (conversation.hasUnreadMessages)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.circle,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation.recipientName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: conversation.hasUnreadMessages
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatTime(conversation.lastMessageTime),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: conversation.hasUnreadMessages
                                      ? AppTheme.amber
                                      : AppTheme.textSecondary,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (conversation.productTitle != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.gray200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                conversation.productTitle!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      fontSize: 10,
                                      color: AppTheme.textSecondary,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(
                              conversation.lastMessage,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: conversation.hasUnreadMessages
                                        ? AppTheme.textPrimary
                                        : AppTheme.textSecondary,
                                    fontWeight: conversation.hasUnreadMessages
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (conversation.unreadCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                conversation.unreadCount > 9
                                    ? '9+'
                                    : conversation.unreadCount.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

