import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../domain/project_draft.dart';
import '../bloc/project_wizard_bloc.dart';

/// Paso 1 (P-008): Datos básicos y ubicación del proyecto.
class WizardStepBasics extends StatefulWidget {
  const WizardStepBasics({super.key, required this.draft});

  final ProjectDraft draft;

  @override
  State<WizardStepBasics> createState() => _WizardStepBasicsState();
}

class _WizardStepBasicsState extends State<WizardStepBasics> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _cityController;
  late final TextEditingController _neighborhoodController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.draft.title);
    _descController = TextEditingController(text: widget.draft.description);
    _cityController = TextEditingController(text: widget.draft.city);
    _neighborhoodController = TextEditingController(
      text: widget.draft.neighborhood,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  void _sync() {
    context.read<ProjectWizardBloc>().add(
      WizardBasicsChanged(
        title: _titleController.text,
        description: _descController.text,
        city: _cityController.text,
        neighborhood: _neighborhoodController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Datos del proyecto', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _titleController,
            label: 'Título de la obra',
            hint: 'Ej. Pintura sala y comedor',
            prefixIcon: LucideIcons.paintbrush,
            onChanged: (_) => _sync(),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _descController,
            label: 'Descripción o detalles',
            hint: 'Describe el estado actual de los muros y el acabado deseado',
            maxLines: 3,
            prefixIcon: LucideIcons.fileText,
            onChanged: (_) => _sync(),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _cityController,
                  label: 'Ciudad',
                  hint: 'Cali',
                  onChanged: (_) => _sync(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  controller: _neighborhoodController,
                  label: 'Barrio / Sector',
                  hint: 'Ciudad Jardín',
                  onChanged: (_) => _sync(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Paso 2 (P-009): Registro y cálculo de superficies en metros cuadrados.
class WizardStepSurfaces extends StatefulWidget {
  const WizardStepSurfaces({super.key, required this.draft});

  final ProjectDraft draft;

  @override
  State<WizardStepSurfaces> createState() => _WizardStepSurfacesState();
}

class _WizardStepSurfacesState extends State<WizardStepSurfaces> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Muro lateral',
  );
  final TextEditingController _widthController = TextEditingController(
    text: '3.5',
  );
  final TextEditingController _heightController = TextEditingController(
    text: '2.5',
  );

  @override
  void dispose() {
    _nameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _addSurface() {
    final width =
        double.tryParse(_widthController.text.replaceAll(',', '.')) ?? 0;
    final height =
        double.tryParse(_heightController.text.replaceAll(',', '.')) ?? 0;
    context.read<ProjectWizardBloc>().add(
      WizardSurfaceAdded(
        name: _nameController.text,
        widthMeters: width,
        heightMeters: height,
      ),
    );
    _nameController.text = 'Superficie ${widget.draft.surfaces.length + 2}';
  }

  @override
  Widget build(BuildContext context) {
    final surfaces = widget.draft.surfaces;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Superficies a intervenir',
                  style: AppTypography.subheading,
                ),
              ),
              AppBadge(
                text: '${widget.draft.totalAreaM2.toStringAsFixed(1)} m²',
                variant: AppBadgeVariant.brand,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < surfaces.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.paper100,
                  borderRadius: AppSpacing.roundedSm,
                  border: Border.all(
                    color: AppColors.line300,
                    width: AppSpacing.strokeCard,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.ruler,
                      size: 16,
                      color: AppColors.brand700,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '${surfaces[i].name} · ${surfaces[i].widthMeters} × ${surfaces[i].heightMeters} m (${surfaces[i].areaM2.toStringAsFixed(1)} m²)',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.ink900,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Eliminar superficie',
                      onPressed: () {
                        context.read<ProjectWizardBloc>().add(
                          WizardSurfaceRemoved(i),
                        );
                      },
                      icon: const Icon(
                        LucideIcons.trash2,
                        size: 18,
                        color: AppColors.danger700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const Divider(height: AppSpacing.xl, color: AppColors.line300),
          Text('Agregar otra superficie', style: AppTypography.labelStrong),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _nameController,
            label: 'Nombre de la pared o techo',
            hint: 'Ej. Pared ventana',
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _widthController,
                  label: 'Ancho (m)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  controller: _heightController,
                  label: 'Alto (m)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Agregar superficie',
            variant: AppButtonVariant.outline,
            icon: LucideIcons.plus,
            onPressed: _addSurface,
          ),
        ],
      ),
    );
  }
}

/// Paso 3 (P-010): Captura de fotos con la cámara del dispositivo / emulador.
class WizardStepPhotos extends StatefulWidget {
  const WizardStepPhotos({super.key, required this.draft});

  final ProjectDraft draft;

  @override
  State<WizardStepPhotos> createState() => _WizardStepPhotosState();
}

class _WizardStepPhotosState extends State<WizardStepPhotos> {
  static const MethodChannel _cameraChannel = MethodChannel(
    'com.example.rivet/camera',
  );
  bool _openingCamera = false;

  Future<void> _takePhotoWithCamera() async {
    if (_openingCamera) return;
    setState(() => _openingCamera = true);
    try {
      final path = await _cameraChannel.invokeMethod<String>('takePhoto');
      if (!mounted) return;
      if (path != null && path.isNotEmpty) {
        context.read<ProjectWizardBloc>().add(WizardPhotoAdded(path));
      }
    } on MissingPluginException {
      if (!mounted) return;
      context.read<ProjectWizardBloc>().add(
        const WizardPhotoAdded(AppHeroImages.livingRoom),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'No fue posible abrir la cámara.'),
            duration: const Duration(seconds: 5),
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _openingCamera = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.draft.photoAssets;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Fotografías del espacio',
                  style: AppTypography.subheading,
                ),
              ),
              AppBadge.count(text: '${photos.length}'),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Toma fotos de las paredes o techos que vas a intervenir para que los contratistas coticen con precisión.',
            style: AppTypography.caption,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: _openingCamera
                ? 'Abriendo cámara...'
                : 'Tomar foto con la cámara',
            icon: LucideIcons.camera,
            isLoading: _openingCamera,
            onPressed: _takePhotoWithCamera,
          ),
          const SizedBox(height: AppSpacing.md),
          if (photos.isEmpty)
            const AppEmptyState(
              title: 'Aún no has tomado fotos',
              message:
                  'Usa el botón superior para abrir la cámara y capturar el estado actual del muro.',
              icon: LucideIcons.camera,
            )
          else
            for (var i = 0; i < photos.length; i++) ...[
              _CapturedPhotoRow(
                path: photos[i],
                index: i,
                onRemove: () {
                  context.read<ProjectWizardBloc>().add(WizardPhotoRemoved(i));
                },
              ),
              if (i < photos.length - 1) const SizedBox(height: AppSpacing.sm),
            ],
        ],
      ),
    );
  }
}

class _CapturedPhotoRow extends StatelessWidget {
  const _CapturedPhotoRow({
    required this.path,
    required this.index,
    required this.onRemove,
  });

  final String path;
  final int index;
  final VoidCallback onRemove;

  bool get _isFilePath =>
      path.startsWith('/') || path.contains(':\\') || path.contains('/cache/');

  @override
  Widget build(BuildContext context) {
    final Widget thumbnail = _isFilePath
        ? Image.file(
            File(path),
            height: 76,
            width: 96,
            cacheWidth: 240,
            cacheHeight: 190,
            gaplessPlayback: true,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 76,
              width: 96,
              color: AppColors.brandLight,
              child: const Icon(LucideIcons.image, color: AppColors.brand700),
            ),
          )
        : Image.asset(
            path,
            height: 76,
            width: 96,
            cacheWidth: 240,
            cacheHeight: 190,
            gaplessPlayback: true,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 76,
              width: 96,
              color: AppColors.brandLight,
              child: const Icon(LucideIcons.image, color: AppColors.brand700),
            ),
          );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.paper100,
        borderRadius: AppSpacing.roundedSm,
        border: Border.all(
          color: AppColors.line300,
          width: AppSpacing.strokeCard,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppSpacing.roundedSm,
            child: thumbnail,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fotografía ${index + 1}',
                  style: AppTypography.labelStrong,
                ),
                const SizedBox(height: 2),
                Text(
                  _isFilePath ? 'Capturada con la cámara' : 'Foto del proyecto',
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Eliminar fotografía',
            onPressed: onRemove,
            icon: const Icon(
              LucideIcons.trash2,
              size: 18,
              color: AppColors.danger700,
            ),
          ),
        ],
      ),
    );
  }
}
