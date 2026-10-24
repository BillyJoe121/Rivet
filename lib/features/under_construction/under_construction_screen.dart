import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'widgets/paint_wall_animation.dart';

/// Marcador de las secciones que aún no están disponibles. Si se abrió con
/// push muestra el botón volver; como pestaña del shell no lo muestra.
class UnderConstructionScreen extends StatelessWidget {
  const UnderConstructionScreen({super.key, this.section});

  /// Nombre de la sección (p. ej. "Bodega"); se usa como título de cabecera.
  final String? section;

  static const title = 'Pantalla en construcción';
  static const message = 'Esta sección aún no está disponible.';

  @override
  Widget build(BuildContext context) {
    final pushed = ModalRoute.of(context)?.canPop ?? false;
    final animate = !MediaQuery.disableAnimationsOf(context);

    return RivetScaffold(
      title: section,
      showBackButton: pushed,
      backgroundImagePath: 'Fondos/Rincón natural de pintura DIY.png',
      body: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenGutter, vertical: AppSpacing.xxl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: ExcludeSemantics(child: PaintWallAnimation(animate: animate)),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(title, textAlign: TextAlign.center, style: AppTypography.sectionTitle),
                      const SizedBox(height: AppSpacing.sm),
                      Text(message, textAlign: TextAlign.center, style: AppTypography.bodyMedium),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
