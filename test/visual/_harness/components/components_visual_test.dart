// Pruebas visuales de los componentes compartidos contra recortes de los
// frames de Figma (2x). Cada prueba usa el tamaño exacto del nodo.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:rivet/core/theme/theme.dart';
import 'package:rivet/core/widgets/widgets.dart';

import '../figma_harness.dart';

/// Tarjeta de lista del diseño (blanca, borde 0.6, radio 16) para enmarcar
/// los componentes sin depender de otros widgets en reconstrucción.
Widget _card({required EdgeInsets padding, required Widget child}) {
  return Container(
    padding: padding,
    decoration: const BoxDecoration(
      color: AppColors.surface0,
      borderRadius: AppSpacing.roundedLg,
    ),
    foregroundDecoration: BoxDecoration(
      borderRadius: AppSpacing.roundedLg,
      border: Border.all(
        color: AppColors.line300,
        width: AppSpacing.strokeCard,
        strokeAlign: BorderSide.strokeAlignInside,
      ),
    ),
    child: child,
  );
}

Future<void> _render(
  WidgetTester tester,
  String name,
  Size size,
  Widget child, {
  Color? background,
}) async {
  final file = await renderComponentToPng(
    tester,
    SizedBox(width: size.width, height: size.height, child: child),
    name: 'components/$name',
    canvasSize: size,
    background: background,
  );
  expect(file.existsSync(), isTrue);
}

void main() {
  setUpAll(loadHarnessFonts);

  testWidgets('section_header_conteo', (tester) async {
    await _render(
      tester,
      'section_header_2027_226',
      const Size(368, 22),
      const AppSectionHeader(title: 'Pendientes de despachar', count: 2),
    );
  });

  testWidgets('siguientes_pasos', (tester) async {
    await _render(
      tester,
      'siguientes_pasos_22_143599',
      const Size(368, 193),
      _card(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSectionHeader(
              title: 'Siguientes pasos',
              actionLabel: 'Ver todos',
              onAction: () {},
            ),
            const SizedBox(height: 9),
            const AppListTile(
              leadingIcon: LucideIcons.clipboardCheck,
              title: 'Revisa 2 nuevas cotizaciones',
              subtitle: 'Pintar sala',
              meta: 'Hace 1 h',
            ),
            const SizedBox(height: 9),
            const AppListTile(
              leadingIcon: LucideIcons.clipboardList,
              title: 'Contratista hizo una pregunta',
              subtitle: 'Renueva cocina',
              meta: 'Hace 3 h',
            ),
            const SizedBox(height: 9),
            const AppListTile(
              leadingIcon: LucideIcons.lock,
              title: 'Confirma la visita al lugar',
              subtitle: 'Pintar exterior',
              meta: 'Mañana',
            ),
          ],
        ),
      ),
    );
  });

  testWidgets('ajustes', (tester) async {
    await _render(
      tester,
      'ajustes_22_146438',
      const Size(368, 256),
      _card(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const AppListTile(
              leadingIcon: LucideIcons.user,
              title: 'Información de la cuenta',
              subtitle: 'Nombre, correo y contacto',
            ),
            AppListTile(
              leadingIcon: LucideIcons.mapPin,
              title: 'Visibilidad pública',
              subtitle: 'Mostrar solo zona aproximada',
              trailing: AppSwitch(value: true, onChanged: (_) {}),
            ),
            AppListTile(
              leadingIcon: LucideIcons.image,
              title: 'Privacidad de fotos',
              subtitle: 'Permitir uso de fotos aprobadas',
              trailing: AppSwitch(value: true, onChanged: (_) {}),
            ),
            AppListTile(
              leadingIcon: LucideIcons.sparkles,
              title: 'Consentimiento de IA',
              subtitle: 'Procesamiento de imágenes autorizado',
              trailing: AppSwitch(value: true, onChanged: (_) {}),
            ),
            const AppListTile(
              leadingIcon: LucideIcons.bell,
              title: 'Notificaciones',
              subtitle: 'Mensajes, propuestas y fechas',
            ),
            const AppListTile(
              leadingIcon: LucideIcons.lock,
              title: 'Seguridad',
              subtitle: 'Cambiar contraseña',
            ),
          ],
        ),
      ),
    );
  });

  testWidgets('avisos', (tester) async {
    await _render(
      tester,
      'aviso_compacto_2027_272',
      const Size(368, 50),
      const AppInfoBanner(
        compact: true,
        message:
            '«Despachado» significa listo para retiro, no entregado. '
            'La entrega se registra al recoger los materiales.',
      ),
    );
    await _render(
      tester,
      'aviso_22_146466',
      const Size(368, 52),
      const AppInfoBanner(
        message:
            'La dirección exacta y las fotos privadas nunca se '
            'comparten sin tu aprobación.',
      ),
    );
    await _render(
      tester,
      'aviso_alerta_66_14130',
      const Size(368, 54),
      const AppInfoBanner(
        variant: AppInfoBannerVariant.warning,
        iconSize: 20,
        message:
            'El pago no se libera hasta resolver el caso. Este reporte '
            'corresponde al trabajo, no al pedido de materiales.',
      ),
    );
  });

  testWidgets('avatares', (tester) async {
    await _render(
      tester,
      'avatar_22_143565',
      const Size(36, 36),
      const AppAvatar(initials: 'JP'),
      background: Colors.white,
    );
    await _render(
      tester,
      'avatar_22_146433',
      const Size(72, 72),
      const AppAvatar(initials: 'JP', size: 72),
      background: Colors.white,
    );
  });

  testWidgets('busqueda_y_filtros', (tester) async {
    await _render(
      tester,
      'busqueda_22_144652',
      const Size(368, 42),
      const AppSearchBar(
        hintText: 'Buscar materiales, marcas o proveedores...',
      ),
    );
    await _render(
      tester,
      'filtros_22_144655',
      const Size(368, 78),
      const AppFilterGrid(
        fields: [
          AppFilterField(
            icon: LucideIcons.package,
            label: 'Categoría',
            height: 36,
          ),
          AppFilterField(icon: LucideIcons.shield, label: 'Marca', height: 36),
          AppFilterField(
            icon: LucideIcons.mapPin,
            label: 'Ubicación',
            height: 36,
          ),
          AppFilterField(
            icon: LucideIcons.circleCheck,
            label: 'Disponibilidad',
            height: 36,
          ),
        ],
      ),
    );
    await _render(
      tester,
      'chips_22_144854',
      const Size(368, 54),
      AppFilterChips(
        labels: const [
          'Todos',
          'Borrador',
          'Publicado',
          'Recibiendo propuestas',
          'En ejecución',
          'Finalizado',
        ],
        selectedIndex: null,
        onSelected: (_) {},
      ),
    );
  });

  testWidgets('accesos_y_progreso', (tester) async {
    await _render(
      tester,
      'accesos_22_143586',
      const Size(368, 90),
      const AppQuickActionRow(
        tiles: [
          AppQuickActionTile(icon: LucideIcons.plus, label: 'Nuevo proyecto'),
          AppQuickActionTile(
            icon: LucideIcons.fileText,
            label: 'Mis proyectos',
          ),
          AppQuickActionTile(icon: LucideIcons.tag, label: 'Cotizaciones'),
          AppQuickActionTile(
            icon: LucideIcons.messageSquare,
            label: 'Mensajes',
          ),
        ],
      ),
    );
    await _render(
      tester,
      'accesos_22_144385',
      const Size(368, 72),
      const AppQuickActionRow(
        gap: 4,
        tiles: [
          AppQuickActionTile(
            icon: LucideIcons.house,
            label: 'Proyectos',
            height: 72,
            iconSize: 24,
            gap: 6,
            padding: 8,
          ),
          AppQuickActionTile(
            icon: LucideIcons.users,
            label: 'Contratistas',
            height: 72,
            iconSize: 24,
            gap: 6,
            padding: 8,
          ),
          AppQuickActionTile(
            icon: LucideIcons.package,
            label: 'Bodega',
            height: 72,
            iconSize: 24,
            gap: 6,
            padding: 8,
          ),
        ],
      ),
    );
    await _render(
      tester,
      'progreso_22_143581',
      const Size(212, 11),
      const AppProgressBar(value: 0.4, label: '2 de 4 etapas'),
      background: Colors.white,
    );
  });
}
