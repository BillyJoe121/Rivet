import 'package:flutter/material.dart';

import 'rv_icon_data.dart';
import 'rv_icons.dart';
import 'rv_tokens.dart';

/// Navegación principal del propietario: 412×80, blanca, trazo 1 `#E6E9E4`,
/// padding 14/12/0/12 y cinco destinos de 77.6 (ícono 21, gap 8, label 10/12).
class RvBottomNav extends StatelessWidget {
  const RvBottomNav({super.key, required this.activeIndex, this.onSelect});

  final int activeIndex;

  /// Si es null, tocar un destino vuelve a la primera ruta de la pila.
  final ValueChanged<int>? onSelect;

  static const destinations = [
    (icon: RvIcons.house, label: 'Inicio'),
    (icon: RvIcons.hardHat, label: 'Contratistas'),
    (icon: RvIcons.tag, label: 'Propuestas'),
    (icon: RvIcons.messageSquare, label: 'Mensajes'),
    (icon: RvIcons.ellipsis, label: 'Más'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: RvLayout.bottomNav,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      decoration: BoxDecoration(
        color: RvColors.surface0,
        border: Border.all(color: RvColors.line300, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < destinations.length; i++)
            Expanded(child: _destination(context, i)),
        ],
      ),
    );
  }

  Widget _destination(BuildContext context, int i) {
    final d = destinations[i];
    final color = i == activeIndex ? RvColors.brand700 : RvColors.ink500;
    return Semantics(
      button: true,
      selected: i == activeIndex,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelect != null
            ? onSelect!(i)
            : Navigator.of(context).popUntil((route) => route.isFirst),
        child: Column(
          children: [
            RvIcon(d.icon, size: 21, color: color),
            const SizedBox(height: 8),
            Text(d.label, textAlign: TextAlign.center, style: rvText(10, lineHeight: 12, color: color)),
          ],
        ),
      ),
    );
  }
}
