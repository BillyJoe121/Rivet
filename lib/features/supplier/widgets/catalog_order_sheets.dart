import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';
import '../../../injection_container.dart';
import '../../projects/domain/repositories/project_repository.dart';
import '../../projects/presentation/bloc/projects_bloc.dart';
import '../../projects/wizard/domain/add_material_to_draft_usecase.dart';
import '../../projects/wizard/domain/project_draft_repository.dart';
import '../material_price_tier.dart';

export 'order_material_now_sheet.dart';

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
  ProjectRepository? projectRepository;
  try {
    projectsBloc = context.read<ProjectsBloc>();
    projects = projectsBloc.state.projects;
  } catch (_) {}
  try {
    projectRepository = context.read<ProjectRepository>();
  } catch (_) {
    if (sl.isRegistered<ProjectRepository>()) {
      projectRepository = sl<ProjectRepository>();
    }
  }

  return showAppBottomSheet<void>(
    context,
    builder: (sheetContext) => _AddMaterialToProjectSheet(
      product: product,
      tier: tier,
      preselectedProjectId: preselectedProjectId,
      projects: projects,
      projectsBloc: projectsBloc,
      projectRepository: projectRepository,
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
    this.projectRepository,
  });

  final MaterialProduct product;
  final MaterialPriceTier tier;
  final String? preselectedProjectId;
  final List<Project> projects;
  final ProjectsBloc? projectsBloc;
  final ProjectRepository? projectRepository;

  @override
  State<_AddMaterialToProjectSheet> createState() =>
      _AddMaterialToProjectSheetState();
}

class _AddMaterialToProjectSheetState
    extends State<_AddMaterialToProjectSheet> {
  int _quantity = 1;
  late List<Project> _projects = List<Project>.from(widget.projects);
  late String _selectedProjectId =
      widget.preselectedProjectId ??
      (_projects.isNotEmpty ? _projects.first.id : '');
  bool _loadingProjects = false;
  bool _submitting = false;

  bool get _hasPreselectedProject => widget.preselectedProjectId != null;

  @override
  void initState() {
    super.initState();
    if (_projects.isEmpty &&
        !_hasPreselectedProject &&
        widget.projectRepository != null) {
      _loadProjects();
    }
  }

  Future<void> _loadProjects() async {
    setState(() => _loadingProjects = true);
    try {
      final loaded = await widget.projectRepository!.getMyProjects();
      if (!mounted) return;
      setState(() {
        _projects = loaded;
        if (_selectedProjectId.isEmpty && loaded.isNotEmpty) {
          _selectedProjectId = loaded.first.id;
        }
        _loadingProjects = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingProjects = false);
    }
  }

  Project? get _targetProject {
    for (final p in _projects) {
      if (p.id == _selectedProjectId) return p;
    }
    return _projects.isNotEmpty ? _projects.first : null;
  }

  Future<void> _confirmAdd() async {
    final unitPrice = widget.tier.priceOf(widget.product);
    final newItem = ProjectMaterial(
      productId: widget.product.id,
      name: widget.product.name,
      unit: widget.product.unit,
      unitPriceCop: unitPrice,
      quantity: _quantity,
    );

    if (_selectedProjectId == 'draft') {
      AddMaterialToDraftUseCase(context.read<ProjectDraftRepository>())(
        newItem,
      );
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
    if (target == null) return;

    final next = [...target.materials];
    final idx = next.indexWhere((m) => m.productId == newItem.productId);
    if (idx >= 0) {
      next[idx] = next[idx].withQuantity(next[idx].quantity + _quantity);
    } else {
      next.add(newItem);
    }
    final updatedProject = target.copyWith(materials: next);

    if (widget.projectsBloc != null) {
      widget.projectsBloc!.add(UpdateProjectSubmitted(updatedProject));
    } else if (widget.projectRepository != null) {
      setState(() => _submitting = true);
      try {
        await widget.projectRepository!.updateProject(updatedProject);
      } catch (_) {
        if (!mounted) return;
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(
                'No pudimos guardar el material en el proyecto. Intenta de nuevo.',
              ),
              duration: Duration(seconds: 4),
            ),
          );
        return;
      }
    }

    if (!mounted) return;
    final projectName = target.title;
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
            if (_loadingProjects)
              const AppLoadingState(label: 'Cargando tus proyectos')
            else if (_projects.isEmpty)
              const AppEmptyState(
                title: 'Aún no tienes proyectos',
                message:
                    'Crea un proyecto en la pestaña Proyectos para agregarle materiales.',
                icon: LucideIcons.folderPlus,
              )
            else
              for (final proj in _projects) ...[
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
            onPressed: _submitting ||
                    (_selectedProjectId != 'draft' && _targetProject == null)
                ? null
                : _confirmAdd,
          ),
        ],
      ),
    );
  }
}
