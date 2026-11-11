import 'package:flutter/material.dart';

import '../../../core/design_system/design_system.dart';
import '../messaging_mock.dart';

/// Fila de conversación de la bandeja: avatar circular de 55 px, nombre Lora,
/// hora a la derecha y último mensaje.
class MsgConversationRow extends StatelessWidget {
  const MsgConversationRow({super.key, required this.conversation});

  final MsgConversation conversation;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProImage(conversation.avatar, width: 55, height: 55, radius: 27.5),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      conversation.name,
                      style: AppTypography.proportional(
                        16,
                        family: AppTypography.serif,
                        weight: FontWeight.w600,
                        color: AppColors.ink700,
                        lineHeight: 19.2,
                      ),
                    ),
                  ),
                  Text(
                    conversation.time,
                    style: AppTypography.proportional(
                      11,
                      color: AppColors.ink700,
                      lineHeight: 13.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                conversation.text,
                style: AppTypography.proportional(13, color: AppColors.ink700, lineHeight: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Pestaña de la bandeja: seleccionada con degradado de marca, o suave.
class MsgTab extends StatelessWidget {
  const MsgTab({super.key, required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: selected ? AppColors.brandGradientDiagonal : null,
        color: selected ? null : AppColors.brandLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: selected
            ? AppTypography.proportional(
                12,
                weight: FontWeight.w600,
                color: AppColors.surface0,
                lineHeight: 14.4,
              )
            : AppTypography.proportional(12, color: AppColors.ink500, lineHeight: 14.4),
      ),
    );
  }
}
