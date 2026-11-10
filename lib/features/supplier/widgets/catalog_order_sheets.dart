import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/data/mock_data.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../projects/presentation/bloc/projects_bloc.dart';
import '../../projects/wizard/data/local_project_draft_repository.dart';
import '../material_price_tier.dart';

/// Abre el flujo para agregar un material al proyecto actual o elegir uno de
/// los proyectos del usuario cuando se entra directamente a la Bodega.
Future<void> showAddMaterialToProjectSheet(
  BuildContext context, {
  required MaterialProduct product,
  required MaterialPriceTier tier,
  String? preselectedProjectId,
}) {
  List<Project> projects = const [];
  ProjectsBloc? projectsBloc;
  try {
    projectsBloc = context.read<ProjectsBloc>();
    projects = projectsBloc.state.projects;
  } catch (_) {}
  if (projects.isEmpty) {
    projects = MockData.projects;
  }

  return showAppBottomSheet<void>(
    context,
    builder: (sheetContext) => _AddMaterialToProjectSheet(
      product: product,
      tier: tier,
      preselectedProjectId: preselectedProjectId,
      projects: projects,
      projectsBloc: projectsBloc,
    ),
  );
}

class _AddMaterialToProjectSheet extends StatefulWidget {
  const _AddMaterialToProjectSheet({
    required this.product,
    required this.tier,
    required this.projects,
    this.preselectedProjectId,
    this.projectsBloc,
  });

  final MaterialProduct product;
  final MaterialPriceTier tier;
  final String? preselectedProjectId;
  final List<Project> projects;
  final ProjectsBloc? projectsBloc;

  @override
  State<_AddMaterialToProjectSheet> createState() =>
      _AddMaterialToProjectSheetState();
}

class _AddMaterialToProjectSheetState
    extends State<_AddMaterialToProjectSheet> {
  int _quantity = 1;
  late String _selectedProjectId =
      widget.preselectedProjectId ??
      (widget.projects.isNotEmpty ? widget.projects.first.id : 'proj-101');

  bool get _hasPreselectedProject => widget.preselectedProjectId != null;

  Project? get _targetProject {
    for (final p in widget.projects) {
      if (p.id == _selectedProjectId) return p;
    }
    return widget.projects.isNotEmpty ? widget.projects.first : null;
  }

  void _confirmAdd() {
    final unitPrice = widget.tier.priceOf(widget.product);
    final newItem = ProjectMaterial(
      productId: widget.product.id,
      name: widget.product.name,
      unit: widget.product.unit,
      unitPriceCop: unitPrice,
      quantity: _quantity,
    );

    if (_selectedProjectId == 'draft') {
      final repo = LocalProjectDraftRepository.instance;
      final draft = repo.loadDraft();
      if (draft != null) {
        final next = [...draft.materials];
        final idx = next.indexWhere((m) => m.productId == newItem.productId);
        if (idx >= 0) {
          next[idx] = next[idx].withQuantity(next[idx].quantity + _quantity);
        } else {
          next.add(newItem);
        }
        repo.saveDraft(draft.copyWith(materials: next));
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Se agregaron $_quantity × ${widget.product.name} al proyecto actual.',
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      return;
    }

    final target = _targetProject;
    if (target != null && widget.projectsBloc != null) {
      final next = [...target.materials];
      final idx = next.indexWhere((m) => m.productId == newItem.productId);
      if (idx >= 0) {
        next[idx] = next[idx].withQuantity(next[idx].quantity + _quantity);
      } else {
        next.add(newItem);
      }
      final updatedProject = target.copyWith(materials: next);
      widget.projectsBloc!.add(UpdateProjectSubmitted(updatedProject));
    }

    final projectName = target?.title ?? 'tu proyecto';
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Agregado: $_quantity × ${widget.product.name} a «$projectName».',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final unitPrice = widget.tier.priceOf(widget.product);
    final subtotal = unitPrice * _quantity;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _hasPreselectedProject
                ? 'Agregar al proyecto actual'
                : 'Agregar a un proyecto',
            style: AppTypography.sectionTitle,
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.product.name} · \$ ${formatCop(unitPrice)} COP por ${widget.product.unit}',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          if (!_hasPreselectedProject) ...[
            Text(
              'Selecciona el proyecto destino',
              style: AppTypography.labelStrong,
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final proj in widget.projects) ...[
              AppCard(
                backgroundColor: proj.id == _selectedProjectId
                    ? AppColors.brandLight
                    : AppColors.paper100,
                isSelected: proj.id == _selectedProjectId,
                padding: const EdgeInsets.all(AppSpacing.md),
                onTap: () => setState(() => _selectedProjectId = proj.id),
                child: Row(
                  children: [
                    Icon(
                      proj.id == _selectedProjectId
                          ? LucideIcons.circleCheck
                          : LucideIcons.circle,
                      size: 18,
                      color: AppColors.brand700,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(proj.title, style: AppTypography.labelStrong),
                          Text(
                            '${proj.city} · ${proj.neighborhood} (${proj.materials.length} materiales)',
                            style: AppTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            const SizedBox(height: AppSpacing.sm),
          ] else if (_targetProject != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.brandLight,
                borderRadius: AppSpacing.roundedMd,
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.folderCheck,
                    size: 18,
                    color: AppColors.brand700,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Proyecto: ${_targetProject!.title}',
                      style: AppTypography.labelStrong,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cantidad (${widget.product.unit})',
                style: AppTypography.labelStrong,
              ),
              AppQuantityStepper(
                value: _quantity,
                min: 1,
                onChanged: (val) => setState(() => _quantity = val),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.paper100,
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal estimado:', style: AppTypography.bodySmall),
                Text(
                  '\$ ${formatCop(subtotal)} COP',
                  style: AppTypography.subheading.copyWith(
                    color: AppColors.brand700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: _hasPreselectedProject
                ? 'Confirmar y agregar al proyecto actual'
                : 'Agregar al proyecto seleccionado',
            showChevron: true,
            onPressed: _confirmAdd,
          ),
        ],
      ),
    );
  }
}

/// Abre el flujo de compra directa ("Pedir ahora mismo") con pago simulado.
Future<void> showOrderMaterialNowSheet(
  BuildContext context, {
  required MaterialProduct product,
  required MaterialPriceTier tier,
}) {
  return showAppBottomSheet<void>(
    context,
    builder: (_) => _OrderMaterialNowSheet(product: product, tier: tier),
  );
}

class _OrderMaterialNowSheet extends StatefulWidget {
  const _OrderMaterialNowSheet({required this.product, required this.tier});

  final MaterialProduct product;
  final MaterialPriceTier tier;

  @override
  State<_OrderMaterialNowSheet> createState() => _OrderMaterialNowSheetState();
}

class _OrderMaterialNowSheetState extends State<_OrderMaterialNowSheet> {
  int _quantity = 1;
  bool _confirmed = false;
  final TextEditingController _addressController = TextEditingController(
    text: 'Cra. 102 #14-80, Ciudad Jardín, Cali',
  );

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unitPrice = widget.tier.priceOf(widget.product);
    final total = unitPrice * _quantity;

    if (_confirmed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.circleCheck,
                color: AppColors.brand700,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Pedido registrado · Pago simulado',
                  style: AppTypography.sectionTitle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppSpecRow(
            icon: LucideIcons.packageCheck,
            label: 'Producto',
            value: '$_quantity × ${widget.product.name}',
          ),
          AppSpecRow(
            icon: LucideIcons.mapPin,
            label: 'Dirección de despacho',
            value: _addressController.text,
          ),
          AppSpecRow(
            icon: LucideIcons.truck,
            label: 'Entrega estimada en Cali',
            value: '24 a 48 horas hábiles',
          ),
          AppSpecRow(
            icon: LucideIcons.coins,
            label: 'Total Pago simulado',
            value: '\$ ${formatCop(total)} COP',
            showDivider: false,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Listo',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pedir ahora mismo',
                  style: AppTypography.sectionTitle,
                ),
              ),
              const AppBadge(
                text: 'Pago simulado',
                variant: AppBadgeVariant.warning,
                compact: true,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.product.name} · Despacho directo desde Bodega Rivet Cali',
            style: AppTypography.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cantidad (${widget.product.unit})',
                style: AppTypography.labelStrong,
              ),
              AppQuantityStepper(
                value: _quantity,
                min: 1,
                onChanged: (val) => setState(() => _quantity = val),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _addressController,
            label: 'Dirección de entrega en Cali',
            prefixIcon: LucideIcons.mapPin,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.brandLight,
              borderRadius: AppSpacing.roundedMd,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total a pagar (simulado):',
                  style: AppTypography.bodySmall,
                ),
                Text(
                  '\$ ${formatCop(total)} COP',
                  style: AppTypography.subheading.copyWith(
                    color: AppColors.brand700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Confirmar pedido · Pago simulado (\$ ${formatCop(total)})',
            showChevron: true,
            onPressed: () => setState(() => _confirmed = true),
          ),
        ],
      ),
    );
  }
}
