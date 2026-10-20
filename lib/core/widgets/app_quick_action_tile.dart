import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Acceso rápido ("Acceso" en 22:143552, 22:144370, 22:146094): tarjeta
/// blanca con borde 0.5, radio 14, ícono de línea centrado y etiqueta de
/// hasta dos líneas Roboto 400 12 ink700.
///
/// Valores por defecto de 22:143552 (86×90, ícono 27, separación 9,
/// padding 10). Para la fila de 120×72 de 22:144370 usar ícono 24,
/// separación 6 y padding 8.
class AppQuickActionTile extends StatelessWidget {
  const AppQuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.height = 90,
    this.iconSize = 27,
    this.gap = 9,
    this.padding = 10,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final double height;
  final double iconSize;
  final double gap;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: AppColors.surface0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedCard,
          side: BorderSide(
            color: AppColors.line300,
            width: 0.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.roundedCard,
          child: SizedBox(
            height: height,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: iconSize, color: AppColors.brand700),
                  SizedBox(height: gap),
                  Text(
                    label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTypography.label.copyWith(
                      color: AppColors.ink700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fila de accesos rápidos de igual ancho con separación [gap] (8 en
/// 22:143552, 4 en 22:144370).
class AppQuickActionRow extends StatelessWidget {
  const AppQuickActionRow({super.key, required this.tiles, this.gap = 8});

  final List<Widget> tiles;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(child: tiles[i]),
        ],
      ],
    );
  }
}
