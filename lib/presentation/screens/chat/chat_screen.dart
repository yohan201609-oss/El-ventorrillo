import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:el_ventorrillo/core/theme/app_theme.dart';
import 'package:el_ventorrillo/core/utils/responsive.dart';
import 'package:el_ventorrillo/domain/models/chat_message.dart' as domain;
import 'package:el_ventorrillo/presentation/providers/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? chatId;
  final String? recipientId;
  final String? recipientName;
  final String? productTitle;

  const ChatScreen({
    super.key,
    this.chatId,
    this.recipientId,
    this.recipientName,
    this.productTitle,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _currentChatId;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    // Retrasar la inicialización hasta después de que el widget tree termine de construirse
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Usar Future.delayed para asegurar que se ejecute completamente fuera del build
      Future.delayed(Duration.zero, () {
        if (mounted) {
          _initializeChat();
        }
      });
    });
  }

  Future<void> _initializeChat() async {
    if (widget.chatId != null) {
      _currentChatId = widget.chatId;
      _isInitializing = false;
      if (mounted) setState(() {});
      // Marcar mensajes como leídos cuando se abre el chat
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_currentChatId != null && mounted) {
          ref.read(markMessagesAsReadProvider.notifier).markAsRead(_currentChatId!);
        }
      });
      return;
    }

    // Si no hay chatId pero hay recipientId, crear o buscar conversación
    if (widget.recipientId != null && widget.recipientName != null) {
      // Usar Future.delayed para asegurar que se ejecute completamente fuera del build
      await Future.delayed(Duration.zero, () async {
        final createChatNotifier = ref.read(createChatProvider.notifier);
        final chatId = await createChatNotifier.createChat(
          recipientId: widget.recipientId!,
          recipientName: widget.recipientName!,
          productTitle: widget.productTitle,
        );

        if (mounted) {
          if (chatId != null) {
            _currentChatId = chatId;
            _isInitializing = false;
            setState(() {});
            // Marcar mensajes como leídos
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ref.read(markMessagesAsReadProvider.notifier).markAsRead(chatId);
              }
            });
          } else {
            _isInitializing = false;
            setState(() {});
          }
        }
      });
    } else {
      _isInitializing = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _currentChatId == null) return;

    _messageController.clear();

    final sendMessageNotifier = ref.read(sendMessageProvider.notifier);
    await sendMessageNotifier.sendMessage(
      chatId: _currentChatId!,
      text: text,
    );

    // Auto-scroll al final
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final recipientName = widget.recipientName ?? 'Usuario';
    final productTitle = widget.productTitle;

    if (_isInitializing) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          title: const Text('Cargando...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentChatId == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
          title: Text(recipientName),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Error al inicializar el chat'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    final messagesAsync = ref.watch(chatMessagesProvider(_currentChatId!));
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppTheme.gray50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipientName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (productTitle != null)
              Text(
                productTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Implementar menú de opciones
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opciones próximamente'),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Área de mensajes
          Expanded(
            child: messagesAsync.when(
              data: (messages) => messages.isEmpty
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
                            'No hay mensajes aún',
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
                            'Envía un mensaje para iniciar la conversación',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(
                      Responsive.getHorizontalPadding(context),
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSent = message.senderId == currentUserId;
                      return _ChatBubble(
                        message: message,
                        isSent: isSent,
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
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar mensajes',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ref.invalidate(chatMessagesProvider(_currentChatId!));
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Campo de entrada
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(
                  Responsive.getHorizontalPadding(context) * 0.5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Escribe un mensaje...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: AppTheme.gray300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: AppTheme.gray300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(
                              color: AppTheme.amber,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: AppTheme.gray100,
                        ),
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (_) => _sendMessage(),
                        enabled: _currentChatId != null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: _currentChatId != null
                          ? AppTheme.amber
                          : AppTheme.gray400,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _currentChatId != null ? _sendMessage : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final domain.ChatMessage message;
  final bool isSent;
  final String Function(DateTime) formatTime;

  const _ChatBubble({
    required this.message,
    required this.isSent,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = Responsive.getMaxContentWidth(context) * 0.7;

    return Padding(
      padding: EdgeInsets.only(
        bottom: Responsive.getSpacing(context, mobile: 12.0),
      ),
      child: Row(
        mainAxisAlignment:
            isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSent) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.amberLight.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 16,
                color: AppTheme.amber,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSent ? AppTheme.amber : AppTheme.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isSent ? 16 : 4),
                    bottomRight: Radius.circular(isSent ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isSent ? Colors.white : AppTheme.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatTime(message.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isSent
                                ? Colors.white.withOpacity(0.8)
                                : AppTheme.textSecondary,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSent) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.blueLight.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 16,
                color: AppTheme.blue,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

