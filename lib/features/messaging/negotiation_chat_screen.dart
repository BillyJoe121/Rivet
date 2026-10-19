import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.isOfferUpdate = false,
  });

  final String id;
  final String senderName;
  final String text;
  final bool isMe;
  final String timestamp;
  final bool isOfferUpdate;
}

/// Chat de negociación y contrapropuestas de cotización (P-030).
class NegotiationChatScreen extends StatefulWidget {
  const NegotiationChatScreen({
    super.key,
    required this.contractor,
    required this.projectTitle,
  });

  final Contractor contractor;
  final String projectTitle;

  @override
  State<NegotiationChatScreen> createState() => _NegotiationChatScreenState();
}

class _NegotiationChatScreenState extends State<NegotiationChatScreen> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    const ChatMessage(
      id: 'm1',
      senderName: 'Carlos Mendoza',
      text: 'Hola Juan, revisé el dossier de tu sala. El área es de 42 m² y las dos paredes principales tienen buena base.',
      isMe: false,
      timestamp: '10:15 AM',
    ),
    const ChatMessage(
      id: 'm2',
      senderName: 'Juan Camilo',
      text: 'Hola Carlos. ¿La propuesta incluye el resane de la grieta bajo la ventana?',
      isMe: true,
      timestamp: '10:18 AM',
    ),
    const ChatMessage(
      id: 'm3',
      senderName: 'Carlos Mendoza',
      text: 'Sí, claro. Utilizaremos masilla elastomérica con cinta de fibra para evitar que vuelva a marcarse con el calor.',
      isMe: false,
      timestamp: '10:21 AM',
      isOfferUpdate: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: 'm-${DateTime.now().millisecondsSinceEpoch}',
        senderName: 'Juan Camilo',
        text: text,
        isMe: true,
        timestamp: 'Ahora',
      ));
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: widget.contractor.name,
        subtitle: widget.projectTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.ink700),
            tooltip: 'Detalle de la oferta',
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Banner de seguridad
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              color: AppColors.surfaceSubtle,
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, size: 16, color: AppColors.ink500),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Acuerda cambios de alcance aquí para que queden registrados en el acuerdo oficial.',
                      style: AppTypography.caption,
                    ),
                  ),
                ],
              ),
            ),

            // Lista de Mensajes
            Expanded(
              child: ListView.builder(
                padding: AppSpacing.screenPadding,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Align(
                      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: msg.isMe
                              ? AppColors.brand700
                              : msg.isOfferUpdate
                                  ? AppColors.brandLight
                                  : AppColors.surface0,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: msg.isMe
                                ? Colors.transparent
                                : msg.isOfferUpdate
                                    ? AppColors.brand700.withValues(alpha: 0.3)
                                    : AppColors.line300,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!msg.isMe) ...[
                              Text(
                                msg.senderName,
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: msg.isOfferUpdate ? AppColors.brand700 : AppColors.ink900,
                                ),
                              ),
                              const SizedBox(height: 2),
                            ],
                            Text(
                              msg.text,
                              style: AppTypography.bodyMedium.copyWith(
                                color: msg.isMe ? Colors.white : AppColors.ink900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                msg.timestamp,
                                style: AppTypography.caption.copyWith(
                                  fontSize: 10,
                                  color: msg.isMe ? AppColors.leaf300 : AppColors.ink500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Barra de Entrada de Texto
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.surface0,
                border: Border(top: BorderSide(color: AppColors.line300)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: AppColors.ink500),
                    tooltip: 'Adjuntar foto',
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje o aclaración...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        fillColor: AppColors.surfaceSubtle,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.ink500),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  CircleAvatar(
                    backgroundColor: AppColors.brand700,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 18),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
