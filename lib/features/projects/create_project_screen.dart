import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'presentation/bloc/projects_bloc.dart';
import 'projects_service.dart';

/// Formulario para crear y publicar un proyecto de pintura o acabados (P-008).
class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({super.key, this.projectsBloc});

  final ProjectsBloc? projectsBloc;

  @override
  Widget build(BuildContext context) {
    if (projectsBloc != null) {
      return BlocProvider<ProjectsBloc>.value(
        value: projectsBloc!,
        child: const _CreateProjectView(),
      );
    }

    try {
      context.read<ProjectsBloc>();
      return const _CreateProjectView();
    } catch (_) {
      return BlocProvider<ProjectsBloc>(
        create: (_) => ProjectsBloc(
          ProjectsService.instance.getMyProjectsUseCase,
          ProjectsService.instance.createProjectUseCase,
          ProjectsService.instance.getProjectDetailUseCase,
        ),
        child: const _CreateProjectView(),
      );
    }
  }
}

class _CreateProjectView extends StatefulWidget {
  const _CreateProjectView();

  @override
  State<_CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<_CreateProjectView> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _cityController = TextEditingController(text: 'Cali');
  final _neighborhoodController = TextEditingController();
  final _budgetController = TextEditingController();

  final _surfaceNameController = TextEditingController(text: 'Pared principal');
  final _widthController = TextEditingController(text: '4.0');
  final _heightController = TextEditingController(text: '2.5');

  final List<SurfaceItem> _surfaces = [];

  String? _errorMessage;
  Timer? _errorTimer;

  @override
  void initState() {
    super.initState();
    _surfaces.add(
      const SurfaceItem(
        id: 's-init',
        name: 'Pared principal sala',
        widthMeters: 4.0,
        heightMeters: 2.5,
        finishType: 'Vinilo Tipo 1',
      ),
    );
  }

  @override
  void dispose() {
    _errorTimer?.cancel();
    _titleController.dispose();
    _descController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _budgetController.dispose();
    _surfaceNameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    HapticFeedback.mediumImpact();
    _errorTimer?.cancel();
    setState(() => _errorMessage = message);
    _errorTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) setState(() => _errorMessage = null);
    });
  }

  void _addSurface() {
    final name = _surfaceNameController.text.trim();
    final width = double.tryParse(_widthController.text.replaceAll(',', '.')) ?? 0;
    final height = double.tryParse(_heightController.text.replaceAll(',', '.')) ?? 0;

    if (name.isEmpty || width <= 0 || height <= 0) {
      _showError('Ingresa nombre y medidas válidas para la superficie.');
      return;
    }

    setState(() {
      _surfaces.add(
        SurfaceItem(
          id: 's-${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          widthMeters: width,
          heightMeters: height,
        ),
      );
      _surfaceNameController.text = 'Superficie ${_surfaces.length + 1}';
    });
  }

  void _removeSurface(int index) {
    if (_surfaces.length <= 1) {
      _showError('El proyecto debe tener al menos una superficie.');
      return;
    }
    setState(() => _surfaces.removeAt(index));
  }

  void _submit() {
    final title = _titleController.text.trim();
    final city = _cityController.text.trim();
    final neighborhood = _neighborhoodController.text.trim();
    final budgetStr = _budgetController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final budget = int.tryParse(budgetStr) ?? 0;

    if (title.isEmpty) {
      _showError('Ingresa un título para el proyecto.');
      return;
    }
    if (neighborhood.isEmpty) {
      _showError('Ingresa el barrio o sector.');
      return;
    }
    if (_surfaces.isEmpty) {
      _showError('Agrega al menos una superficie.');
      return;
    }

    context.read<ProjectsBloc>().add(
          CreateProjectSubmitted(
            title: title,
            description: _descController.text.trim(),
            city: city,
            neighborhood: neighborhood,
            surfaces: _surfaces,
            budgetEstimateCop: budget,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<ProjectsBloc, ProjectsState>(
      listener: (context, state) {
        if (state.isSuccess && state.selectedProject != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proyecto publicado con éxito.'),
              backgroundColor: AppColors.brand700,
            ),
          );
          Navigator.pop(context, state.selectedProject);
        } else if (state.isFailure && state.errorMessage != null) {
          _showError(state.errorMessage!);
        }
      },
      builder: (context, state) {
        final totalArea = _surfaces.fold(0.0, (acc, s) => acc + s.areaM2);

        return RivetScaffold(
          title: 'Crear proyecto',
          showBackButton: true,
          backgroundImagePath: 'Fondos/Checklist, plantas y cajas sostenibles.png',
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              bottomInset + AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(color: AppColors.danger700.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      _errorMessage!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.danger700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Datos del proyecto', style: AppTypography.subheading.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _titleController,
                        label: 'Título de la obra',
                        hint: 'Ej. Pintura sala y comedor',
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _descController,
                        label: 'Descripción o detalles',
                        hint: 'Describe el estado de los muros y requerimientos especiales',
                        maxLines: 3,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _cityController,
                              label: 'Ciudad',
                              hint: 'Cali',
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppTextField(
                              controller: _neighborhoodController,
                              label: 'Barrio / Sector',
                              hint: 'Valle del Lili',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _budgetController,
                        label: 'Presupuesto estimado (COP)',
                        hint: 'Ej. 1200000',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Superficies a intervenir', style: AppTypography.subheading.copyWith(fontWeight: FontWeight.w700)),
                          AppBadge(
                            text: '${totalArea.toStringAsFixed(1)} m²',
                            variant: AppBadgeVariant.brand,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (int i = 0; i < _surfaces.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: AppColors.surface0,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                              border: Border.all(color: AppColors.line300, width: AppSpacing.strokeCard),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.square, size: 16, color: AppColors.brand700),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    '${_surfaces[i].name} (${_surfaces[i].widthMeters}m × ${_surfaces[i].heightMeters}m = ${_surfaces[i].areaM2.toStringAsFixed(1)} m²)',
                                    style: AppTypography.bodySmall,
                                  ),
                                ),
                                IconButton(
                                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                                  icon: const Icon(LucideIcons.trash2, size: 18, color: AppColors.danger700),
                                  onPressed: () => _removeSurface(i),
                                  tooltip: 'Eliminar superficie',
                                ),
                              ],
                            ),
                          ),
                        ),
                      const Divider(height: AppSpacing.xl, color: AppColors.line300),
                      Text('Agregar otra superficie', style: AppTypography.captionStrong),
                      const SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        controller: _surfaceNameController,
                        label: 'Nombre de la pared',
                        hint: 'Ej. Muro ventana',
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _widthController,
                              label: 'Ancho (m)',
                              hint: '4.0',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: AppTextField(
                              controller: _heightController,
                              label: 'Alto (m)',
                              hint: '2.5',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: _addSurface,
                        icon: const Icon(LucideIcons.plus, size: 16),
                        label: const Text('Agregar superficie'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.brand700,
                          side: const BorderSide(color: AppColors.brand700),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusButton)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppButton(
                  text: state.isLoading ? 'Publicando...' : 'Publicar proyecto',
                  onPressed: state.isLoading ? () {} : _submit,
                  icon: LucideIcons.arrowRight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

