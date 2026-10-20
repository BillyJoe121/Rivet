import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

/// Modelo de mensaje para el chat de negociación.
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

/// Burbuja de mensaje individual en el hilo de negociación.
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: message.isMe
              ? AppColors.brand700
              : message.isOfferUpdate
              ? AppColors.brandLight
              : AppColors.surface0,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: message.isMe
                ? Colors.transparent
                : message.isOfferUpdate
                ? AppColors.brand700.withValues(alpha: 0.3)
                : AppColors.line300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isMe) ...[
              Text(
                message.senderName,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: message.isOfferUpdate
                      ? AppColors.brand700
                      : AppColors.ink900,
                ),
              ),
              const SizedBox(height: 2),
            ],
            Text(
              message.text,
              style: AppTypography.bodyMedium.copyWith(
                color: message.isMe ? Colors.white : AppColors.ink900,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                message.timestamp,
                style: AppTypography.caption.copyWith(
                  fontSize: 10,
                  color: message.isMe ? AppColors.leaf300 : AppColors.ink500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
