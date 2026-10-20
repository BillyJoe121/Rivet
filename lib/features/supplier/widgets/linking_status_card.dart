import 'package:flutter/material.dart';

import '../../home/widgets/kit/kit.dart';
import '../linking_mock.dart';
import 'order_pill.dart';

/// Tarjeta del estado de una solicitud de vinculación enviada por el contratista.
class LinkingStatusCard extends StatelessWidget {
  const LinkingStatusCard({super.key, required this.status});

  final LinkStatus status;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 6,
        children: [
          Row(
            spacing: 8,
            children: [
              Expanded(child: Text(status.name, style: ProText.serif(18, color: ProColors.ink700, lineHeight: 21.6))),
              OrderPill(status.label, background: status.background, foreground: status.foreground),
            ],
          ),
          Text(status.place, style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75)),
          Text(status.access, style: ProText.r(12, lineHeight: 15)),
        ],
      ),
    );
  }
}
