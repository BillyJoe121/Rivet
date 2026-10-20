import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/theme.dart';

/// Fila de especificación medida de "Detalle de material" (nodo 22:144798
/// "Opción"): alto mínimo 38, padding 5×4, 10 px entre elementos, icono de
/// línea de 23 en color de marca, etiqueta Roboto 600 12/15.6 `ink900`,
/// valor Roboto 600 12/14.4 `ink700`, `chevron-right` de 15 y separador
/// inferior de 0.5 en `line300` a todo el ancho.
class AppSpecRow extends StatelessWidget {
  const AppSpecRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 38),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        // Separador como decoración frontal: no suma alto a la fila.
        foregroundDecoration: BoxDecoration(
          border: showDivider
              ? const Border(
                  bottom: BorderSide(color: AppColors.line300, width: 0.5),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 23, color: AppColors.brand700),
            const SizedBox(width: 10),
            // Etiqueta a la izquierda y valor pegado al chevron; cada uno
            // puede ocupar hasta la mitad del espacio libre.
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: AppTypography.labelStrong.copyWith(height: 15.6 / 12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: AppTypography.labelStrong.copyWith(
                        color: AppColors.ink700,
                        height: 14.4 / 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(LucideIcons.chevronRight, size: 15, color: AppColors.brand700),
          ],
        ),
      ),
    );
  }
}
