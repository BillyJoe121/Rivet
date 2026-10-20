import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';
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
                      style: ProText.serif(
                        16,
                        color: ProColors.ink700,
                        lineHeight: 19.2,
                      ),
                    ),
                  ),
                  Text(
                    conversation.time,
                    style: ProText.r(
                      11,
                      color: ProColors.ink700,
                      lineHeight: 13.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                conversation.text,
                style: ProText.r(13, color: ProColors.ink700, lineHeight: 16),
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
        gradient: selected ? ProColors.brandGradient : null,
        color: selected ? null : ProColors.brandLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        style: selected
            ? ProText.r(
                12,
                weight: FontWeight.w600,
                color: ProColors.surface0,
                lineHeight: 14.4,
              )
            : ProText.r(12, color: ProColors.ink500, lineHeight: 14.4),
      ),
    );
  }
}
