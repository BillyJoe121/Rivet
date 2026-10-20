import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Muestra de filas, avatares, búsqueda, avisos y progreso del núcleo.
class ListGalleryScreen extends StatelessWidget {
  const ListGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RivetScaffold(
      title: 'Listas',
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          const AppSectionHeader(title: 'Pendientes de despachar', count: 2),
          const SizedBox(height: AppSpacing.md),
          const AppAvatar(initials: 'JP'),
          const SizedBox(height: AppSpacing.md),
          const AppSearchBar(hintText: 'Buscar materiales'),
          const SizedBox(height: AppSpacing.md),
          const AppInfoBanner(message: 'Despachado significa listo para retiro, no entregado.'),
          const SizedBox(height: AppSpacing.md),
          const AppProgressBar(value: 0.5, label: '2 de 4 etapas'),
        ],
      ),
    );
  }
}
