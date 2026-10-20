import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';

/// Situación de una etapa del seguimiento: completada, actual o pendiente.
enum OrderStageState { done, current, next }

/// Fila de etapa del seguimiento: símbolo de 23 px, título y detalle.
class OrderTimelineRow extends StatelessWidget {
  const OrderTimelineRow({
    super.key,
    required this.glyph,
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final String glyph;
  final String title;
  final String subtitle;
  final OrderStageState state;

  @override
  Widget build(BuildContext context) {
    final pending = state == OrderStageState.next;
    return Row(
      spacing: 10,
      children: [
        SizedBox(
          width: 23,
          child: Text(
            glyph,
            textAlign: TextAlign.center,
            style: ProText.r(21, color: pending ? ProColors.ink500 : ProColors.brand700, lineHeight: 24.609375),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              Text(
                title,
                style: ProText.r(
                  13,
                  weight: FontWeight.w600,
                  color: pending ? ProColors.ink500 : ProColors.ink900,
                  lineHeight: 16.25,
                ),
              ),
              Text(subtitle, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
            ],
          ),
        ),
      ],
    );
  }
}
