import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';
import '../messaging_mock.dart';

/// Burbuja de la conversación de propuesta: 310 px, radios asimétricos y hora
/// con doble check en los mensajes propios.
class MsgChatBubble extends StatelessWidget {
  const MsgChatBubble({super.key, required this.message});

  final MsgBubble message;

  // Radios de Figma en orden [arriba-izquierda, arriba-derecha, abajo-derecha, abajo-izquierda].
  static const _mineRadius = BorderRadius.only(
    topLeft: Radius.circular(18),
    topRight: Radius.circular(18),
    bottomRight: Radius.circular(4),
    bottomLeft: Radius.circular(18),
  );
  static const _otherRadius = BorderRadius.only(
    topLeft: Radius.circular(18),
    topRight: Radius.circular(18),
    bottomRight: Radius.circular(18),
    bottomLeft: Radius.circular(4),
  );
  static const _mineMeta = Color(0xFFD5E7E2);

  @override
  Widget build(BuildContext context) {
    final mine = message.mine;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 310,
        padding: const EdgeInsets.fromLTRB(13.5, 12, 13.5, 12),
        decoration: BoxDecoration(
          color: mine ? ProColors.brand700 : ProColors.surface0,
          borderRadius: mine ? _mineRadius : _otherRadius,
          border: Border.all(
            color: mine ? ProColors.brand700 : ProColors.line300,
            width: ProStroke.card,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              message.text,
              style: ProText.r(
                14,
                color: mine ? ProColors.surface0 : ProColors.ink900,
                lineHeight: 20,
              ),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  message.time,
                  style: ProText.r(
                    10,
                    color: mine ? _mineMeta : ProColors.ink500,
                    lineHeight: 11.71875,
                  ),
                ),
                if (mine && message.read) ...[
                  const SizedBox(width: 5),
                  const ProIcon(
                    LucideIcon.checkCheck,
                    size: 14,
                    color: _mineMeta,
                    strokeWidth: 1.4,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Mensaje de la negociación: avatar de 34 px y tarjeta; la del usuario va tintada.
class MsgThreadRow extends StatelessWidget {
  const MsgThreadRow({
    super.key,
    required this.entry,
    required this.name,
    this.compact = false,
  });

  final MsgThreadEntry entry;

  /// Nombre a mostrar: el usuario o el nombre del contratista.
  final String name;

  /// Variante ajustada (padding 9 y espacio 3) usada tras la propuesta revisada.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ProImage(entry.avatar, width: 34, height: 34, radius: 17),
        const SizedBox(width: 10),
        Expanded(
          child: ProCard(
            padding: EdgeInsets.all(compact ? 9 : 11),
            color: entry.isMe ? ProColors.brandLight : ProColors.surface0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name    ${entry.time}',
                  style: ProText.r(
                    10,
                    weight: FontWeight.w600,
                    color: ProColors.ink700,
                    lineHeight: 12,
                  ),
                ),
                SizedBox(height: compact ? 3 : 4),
                Text(
                  entry.text,
                  style: ProText.r(
                    12,
                    color: ProColors.ink700,
                    lineHeight: 14.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Tarjeta de propuesta revisada con el ajuste de materiales y el nuevo precio.
class MsgOfferCard extends StatelessWidget {
  const MsgOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ProColors.warningLight,
        borderRadius: BorderRadius.circular(ProRadii.lg),
        border: Border.all(color: ProColors.line300, width: ProStroke.card),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            offerTitleLine,
            style: ProText.r(
              13,
              weight: FontWeight.w600,
              color: ProColors.ink700,
              lineHeight: 15.6,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              SizedBox(
                width: 169,
                child: Text(
                  offerDetail,
                  style: ProText.r(
                    11,
                    color: ProColors.ink700,
                    lineHeight: 13.2,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  offerAmount,
                  style: ProText.r(
                    13,
                    weight: FontWeight.w600,
                    color: ProColors.ink700,
                    lineHeight: 15.6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
