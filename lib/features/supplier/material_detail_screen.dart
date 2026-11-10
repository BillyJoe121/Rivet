import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'material_price_tier.dart';
import 'widgets/catalog_order_sheets.dart';

/// Ficha técnica y detalle desplegable de un producto de la Bodega Rivet (P-024).
class MaterialDetailScreen extends StatefulWidget {
  const MaterialDetailScreen({
    super.key,
    required this.product,
    this.tier = MaterialPriceTier.client,
    this.preselectedProjectId,
  });

  final MaterialProduct product;
  final MaterialPriceTier tier;
  final String? preselectedProjectId;

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  bool _componentsOpen = true;
  bool _yieldOpen = true;
  bool _usageOpen = false;

  String _coverageSummary(MaterialProduct p) {
    if (p.coverageM2 != null && p.coverageM2! > 0) {
      return '${p.coverageM2!.toStringAsFixed(0)} m² por ${p.unit} (a 2 manos)';
    }
    return switch (p.category) {
      'Pinturas' => '32 a 38 m² por ${p.unit} (a 2 manos sobre estuco sellado)',
      'Estuco' => '18 a 24 m² por ${p.unit} (según rugosidad del repello)',
      'Selladores' || 'Imprimantes' => '40 a 45 m² por ${p.unit} a una mano',
      'Impermeabilizantes' => '14 a 18 m² por ${p.unit} en 2 capas cruzadas',
      _ => 'Rendimiento sujeto al metraje lineal o área de aplicación',
    };
  }

  String _componentsDescription(MaterialProduct p) {
    if (p.description.isNotEmpty) {
      return '${p.description}\n\nFormulación técnica: elaborado con resinas acrílicas estirenadas de alta adherencia, dióxido de titanio rutilo de alta opacidad, cargas minerales micronizadas (carbonato de calcio de granulometría controlada), aditivos antiespumantes, biocidas de amplio espectro contra hongos y bajo contenido de compuestos orgánicos volátiles (bajo VOC).';
    }
    return switch (p.category) {
      'Pinturas' =>
        'Emulsión vinil-acrílica de alta resistencia formulada con copolímeros acrílicos puros, pigmentos de dióxido de titanio grado rutilo para máximo poder cubriente en seco y húmedo, extendedores minerales silíceos, agentes reológicos que evitan el salpique del rodillo y aditivos fungicidas e hidrofugantes diseñados para el clima cálido-húmedo del Valle del Cauca.',
      'Estuco' =>
        'Pasta acrílica lista para usar compuesta por polímeros elastoméricos de alta flexibilidad, cargas de mármol blanco micronizado malla 400, retenedores de humedad celulósicos que evitan fisuras por retracción durante el fraguado y promotores de adherencia sobre pañete, concreto o placa de yeso (drywall).',
      _ =>
        'Insumo de grado profesional seleccionado por la Bodega Rivet. Fabricado con polímeros sintéticos de alta durabilidad, fibras tratadas para retención uniforme de carga y resistencia a solventes minerales y alcalinidad del sustrato.',
    };
  }

  String _yieldAndPrepText(MaterialProduct p) {
    final coverage = _coverageSummary(p);
    return '• Rendimiento práctico: $coverage.\n'
        '• Espesor recomendado de película: 3,5 a 4,0 mils húmedos por mano.\n'
        '• Tiempo de secado: 1 hora al tacto y 3 a 4 horas entre manos a 25 °C.\n'
        '• Preparación de la superficie: el muro debe estar libre de polvo, grasa, partículas sueltas o humedad activa. En superficies nuevas o polvosas aplica primero una mano de sellador acrílico antes del acabado final.';
  }

  String _applicationDetailsText(MaterialProduct p) {
    final presentation = p.presentation ?? 'Presentación por ${p.unit}';
    return '• Presentación comercial: $presentation.\n'
        '• Dilución sugerida: hasta un 10 % con agua limpia para aplicación con rodillo de felpa o brocha de cerda sintética.\n'
        '• Lavabilidad y mantenimiento: permite limpieza suave con paño húmedo y jabón neutro después de 15 días de curado completo.\n'
        '• Despacho y respaldo: disponible para agregar a la lista de materiales de tu proyecto o pedir con despacho directo en Cali.';
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final effectivePrice = widget.tier.priceOf(product);
    final hasProject = widget.preselectedProjectId != null;

    return RivetScaffold(
      title: 'Detalle de\nmaterial',
      showBackButton: true,
      backgroundImagePath: AppHeroImages.paintShelf,
      body: AppPageBody(
        footer: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: hasProject
                  ? 'Agregar al proyecto actual'
                  : 'Agregar a un proyecto',
              icon: LucideIcons.folderPlus,
              showChevron: true,
              onPressed: () => showAddMaterialToProjectSheet(
                context,
                product: product,
                tier: widget.tier,
                preselectedProjectId: widget.preselectedProjectId,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              text: 'Pedir ahora mismo',
              variant: AppButtonVariant.outline,
              icon: LucideIcons.shoppingBag,
              onPressed: product.inStock
                  ? () => showOrderMaterialNowSheet(
                        context,
                        product: product,
                        tier: widget.tier,
                      )
                  : null,
            ),
          ],
        ),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageAsset != null) ...[
                  ClipRRect(
                    borderRadius: AppSpacing.roundedMd,
                    child: Image.asset(
                      product.imageAsset!,
                      height: 156,
                      width: double.infinity,
                      cacheWidth: 720,
                      gaplessPlayback: true,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.brand.toUpperCase(),
                            style: AppTypography.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.brand700,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            style: AppTypography.subheading.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppBadge(
                      text: product.inStock ? 'Disponible' : 'Agotado',
                      variant: product.inStock
                          ? AppBadgeVariant.success
                          : AppBadgeVariant.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.brandLight,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.tag,
                        color: AppColors.brand700,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Precio por ${product.unit}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.ink700,
                              ),
                            ),
                            Text(
                              '\$ ${formatCop(effectivePrice)} COP',
                              style: AppTypography.sectionTitle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.brand700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Ficha rápida', style: AppTypography.subheading),
                const SizedBox(height: AppSpacing.xs),
                AppSpecRow(
                  icon: LucideIcons.layers,
                  label: 'Categoría',
                  value: product.category,
                ),
                AppSpecRow(
                  icon: LucideIcons.package,
                  label: 'Presentación',
                  value: product.presentation ?? product.unit,
                ),
                AppSpecRow(
                  icon: LucideIcons.ruler,
                  label: 'Rendimiento estimado',
                  value: _coverageSummary(product),
                ),
                if (product.finish != null)
                  AppSpecRow(
                    icon: LucideIcons.sparkles,
                    label: 'Acabado',
                    value: product.finish!,
                  ),
                const AppSpecRow(
                  icon: LucideIcons.shieldCheck,
                  label: 'Distribución',
                  value: 'Bodega Rivet Directo',
                  showDivider: false,
                ),
                const Divider(height: AppSpacing.xl, color: AppColors.line300),
                _ExpandableDetailTile(
                  icon: LucideIcons.flaskConical,
                  title: 'Componentes y formulación técnica',
                  expanded: _componentsOpen,
                  onToggle: () =>
                      setState(() => _componentsOpen = !_componentsOpen),
                  body: _componentsDescription(product),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ExpandableDetailTile(
                  icon: LucideIcons.paintbrush,
                  title: 'Rendimiento y preparación de superficie',
                  expanded: _yieldOpen,
                  onToggle: () => setState(() => _yieldOpen = !_yieldOpen),
                  body: _yieldAndPrepText(product),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ExpandableDetailTile(
                  icon: LucideIcons.clipboardList,
                  title: 'Detalles de uso y almacenamiento',
                  expanded: _usageOpen,
                  onToggle: () => setState(() => _usageOpen = !_usageOpen),
                  body: _applicationDetailsText(product),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableDetailTile extends StatelessWidget {
  const _ExpandableDetailTile({
    required this.icon,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.body,
  });

  final IconData icon;
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper100,
        borderRadius: AppSpacing.roundedMd,
        border: Border.all(
          color: AppColors.line300,
          width: AppSpacing.strokeCard,
        ),
      ),
      child: InkWell(
        onTap: onToggle,
        borderRadius: AppSpacing.roundedMd,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.brand700),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(title, style: AppTypography.labelStrong),
                  ),
                  Icon(
                    expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 18,
                    color: AppColors.brand700,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(body, style: AppTypography.bodySmall),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
