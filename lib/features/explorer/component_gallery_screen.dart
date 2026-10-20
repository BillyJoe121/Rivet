import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Muestra de botones, tarjetas, campos, insignias y pestañas del núcleo.
class ComponentGalleryScreen extends StatelessWidget {
  const ComponentGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RivetScaffold(
      title: 'Componentes',
      showBackButton: true,
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppButton(text: 'Preparar y despachar', onPressed: () {}),
          const SizedBox(height: AppSpacing.md),
          AppButton(text: 'Cancelar', variant: AppButtonVariant.outline, onPressed: () {}),
          const SizedBox(height: AppSpacing.md),
          AppCard(child: Text('Tarjeta', style: AppTypography.bodyStrong)),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Nombre completo', hint: 'Juan Pérez'),
          const SizedBox(height: AppSpacing.md),
          const AppBadge(text: 'Pedido confirmado'),
        ],
      ),
    );
  }
}
