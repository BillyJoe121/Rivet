import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/utils/app_page_route.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../supplier/material_price_tier.dart';
import '../../../../supplier/materials_catalog_screen.dart';
import '../../domain/project_draft.dart';
import '../bloc/project_wizard_bloc.dart';

/// Paso 4 (P-014): Lista estimada de materiales del proyecto.
class WizardStepMaterials extends StatelessWidget {
  const WizardStepMaterials({super.key, required this.draft});

  final ProjectDraft draft;

  @override
  Widget build(BuildContext context) {
    final materials = draft.materials;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Materiales sugeridos (Bodega Rivet)',
                  style: AppTypography.subheading,
                ),
              ),
              AppBadge(
                text: '\$ ${formatCop(draft.materialsTotalCop)}',
                variant: AppBadgeVariant.brand,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final item in materials)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: AppTypography.labelStrong),
                        Text(
                          '${item.unit} · \$ ${formatCop(item.unitPriceCop)} c/u',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  AppQuantityStepper(
                    value: item.quantity,
                    min: 0,
                    onChanged: (val) {
                      context.read<ProjectWizardBloc>().add(
                        WizardMaterialQuantityChanged(
                          productId: item.productId,
                          quantity: val,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            text: 'Explorar Bodega Rivet',
            variant: AppButtonVariant.outline,
            size: AppButtonSize.sm,
            icon: LucideIcons.packageSearch,
            onPressed: () => AppNavigator.push(
              context,
              MaterialsCatalogScreen(
                preselectedProjectId: draft.existingProjectId ?? 'draft',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paso 5: Presupuesto estimado (Mano de obra + Materiales = Total).
class WizardStepBudget extends StatefulWidget {
  const WizardStepBudget({super.key, required this.draft});

  final ProjectDraft draft;

  @override
  State<WizardStepBudget> createState() => _WizardStepBudgetState();
}

class _WizardStepBudgetState extends State<WizardStepBudget> {
  late final TextEditingController _laborController;
  late final TextEditingController _materialsController;

  @override
  void initState() {
    super.initState();
    _laborController = TextEditingController(
      text: '${widget.draft.effectiveLaborBudgetCop}',
    );
    _materialsController = TextEditingController(
      text: '${widget.draft.effectiveMaterialsBudgetCop}',
    );
  }

  @override
  void dispose() {
    _laborController.dispose();
    _materialsController.dispose();
    super.dispose();
  }

  void _syncBudget() {
    final labor =
        int.tryParse(_laborController.text.replaceAll(RegExp(r'[^0-9]'), '')) ??
        0;
    final materials =
        int.tryParse(
          _materialsController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    context.read<ProjectWizardBloc>().add(
      WizardBasicsChanged(
        laborBudgetCop: labor,
        materialsBudgetCop: materials,
        budgetEstimateCop: labor + materials,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.draft.totalBudgetCop;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Presupuesto estimado', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Define cuánto estimas para la mano de obra y ajusta el presupuesto de materiales.',
            style: AppTypography.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _laborController,
            label: 'Presupuesto para mano de obra (COP)',
            keyboardType: TextInputType.number,
            prefixIcon: LucideIcons.hammer,
            onChanged: (_) => _syncBudget(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _materialsController,
            label: 'Presupuesto para materiales (COP)',
            keyboardType: TextInputType.number,
            prefixIcon: LucideIcons.paintBucket,
            onChanged: (_) => _syncBudget(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.brandLight,
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mano de obra:', style: AppTypography.bodySmall),
                    Text(
                      '\$ ${formatCop(widget.draft.effectiveLaborBudgetCop)} COP',
                      style: AppTypography.labelStrong,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Materiales:', style: AppTypography.bodySmall),
                    Text(
                      '\$ ${formatCop(widget.draft.effectiveMaterialsBudgetCop)} COP',
                      style: AppTypography.labelStrong,
                    ),
                  ],
                ),
                const Divider(height: 16, color: AppColors.line300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Presupuesto total:', style: AppTypography.subheading),
                    Text(
                      '\$ ${formatCop(total)} COP',
                      style: AppTypography.subheading.copyWith(
                        color: AppColors.brand700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Paso 6 (P-015): Revisión final antes de publicar o guardar cambios.
class WizardStepPublish extends StatelessWidget {
  const WizardStepPublish({super.key, required this.draft});

  final ProjectDraft draft;

  @override
  Widget build(BuildContext context) {
    final effectiveBudget = draft.totalBudgetCop > 0
        ? draft.totalBudgetCop
        : draft.budgetEstimateCop;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            draft.isEditing
                ? 'Listo para guardar cambios'
                : 'Listo para publicar en Cali',
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Los contratistas de tu zona verán el metraje, las fotos y el presupuesto para enviarte propuestas comparables.',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          AppSpecRow(
            icon: LucideIcons.paintbrush,
            label: 'Obra',
            value: draft.title.isEmpty ? 'Sin título' : draft.title,
          ),
          AppSpecRow(
            icon: LucideIcons.mapPin,
            label: 'Sector',
            value: '${draft.city} · ${draft.neighborhood}',
          ),
          AppSpecRow(
            icon: LucideIcons.ruler,
            label: 'Metraje total',
            value:
                '${draft.totalAreaM2.toStringAsFixed(1)} m² (${draft.surfaces.length} superficies)',
          ),
          AppSpecRow(
            icon: LucideIcons.camera,
            label: 'Fotografías adjuntas',
            value: '${draft.photoAssets.length} fotos',
          ),
          AppSpecRow(
            icon: LucideIcons.hammer,
            label: 'Presupuesto mano de obra',
            value: '\$ ${formatCop(draft.effectiveLaborBudgetCop)} COP',
          ),
          AppSpecRow(
            icon: LucideIcons.paintBucket,
            label: 'Presupuesto materiales',
            value: '\$ ${formatCop(draft.effectiveMaterialsBudgetCop)} COP',
          ),
          AppSpecRow(
            icon: LucideIcons.coins,
            label: 'Presupuesto total',
            value: '\$ ${formatCop(effectiveBudget)} COP',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
