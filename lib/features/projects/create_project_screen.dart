import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import 'widgets/add_surface_sheet.dart';
import 'widgets/photos_privacy_step.dart';
import 'widgets/project_review_step.dart';

/// Flujo paso a paso de creación y medición de un proyecto (P-008 a P-015).
class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  int _currentStep = 0;

  // Paso 0: Datos
  final _titleController = TextEditingController(text: 'Pintura completa de sala y pasillo');
  final _cityController = TextEditingController(text: 'Cali');
  final _neighborhoodController = TextEditingController(text: 'Valle del Lili');

  // Paso 1: Superficies
  final List<SurfaceItem> _surfaces = [
    const SurfaceItem(
      id: 's-new-1',
      name: 'Pared principal de la sala',
      widthMeters: 4.2,
      heightMeters: 2.6,
      finishType: 'Vinilo Tipo 1 Blanco',
    ),
    const SurfaceItem(
      id: 's-new-2',
      name: 'Pared lateral ventana',
      widthMeters: 3.5,
      heightMeters: 2.6,
      finishType: 'Vinilo Tipo 1 Blanco',
    ),
  ];

  // Paso 2: IA y Privacidad
  bool _aiMinimizationAccepted = true;
  bool _noPrivateDataConfirmed = true;

  double get _totalArea => _surfaces.fold(0.0, (acc, s) => acc + s.areaM2);

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    super.dispose();
  }

  void _onSurfaceAdded(SurfaceItem surface) {
    setState(() => _surfaces.add(surface));
  }

  void _showAddSurfaceDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => AddSurfaceSheet(onAddSurface: _onSurfaceAdded),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Nueva Cotización',
        subtitle: 'Paso ${_currentStep + 1} de 4',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
              child: AppStepProgress(
                steps: const ['Datos', 'Medidas', 'Fotos & IA', 'Publicar'],
                currentStep: _currentStep,
              ),
            ),
            const Divider(color: AppColors.line300),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: switch (_currentStep) {
                  0 => _buildStepGeneralData(),
                  1 => _buildStepSurfaces(),
                  2 => PhotosPrivacyStep(
                      aiMinimizationAccepted: _aiMinimizationAccepted,
                      noPrivateDataConfirmed: _noPrivateDataConfirmed,
                      onAiMinimizationChanged: (val) => setState(() => _aiMinimizationAccepted = val),
                      onNoPrivateDataChanged: (val) => setState(() => _noPrivateDataConfirmed = val),
                    ),
                  _ => ProjectReviewStep(
                      title: _titleController.text,
                      city: _cityController.text,
                      neighborhood: _neighborhoodController.text,
                      surfaces: _surfaces,
                      totalArea: _totalArea,
                    ),
                },
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepGeneralData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Qué espacio deseas pintar o estucar?', style: AppTypography.subheading.copyWith(fontSize: 18)),
        const SizedBox(height: AppSpacing.xs),
        Text('Escribe un título claro para que los contratistas comprendan el trabajo.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'Título de la solicitud',
          controller: _titleController,
          hint: 'Ej. Pintura de sala y resane de grietas',
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Ciudad',
                controller: _cityController,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: AppTextField(
                label: 'Barrio / Zona',
                controller: _neighborhoodController,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppCard(
          backgroundColor: AppColors.surfaceSubtle,
          child: Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: AppColors.brand700, size: 20),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Tu dirección exacta y teléfono solo se compartirán si tú apruebas una visita presencial.',
                  style: TextStyle(fontSize: 12, color: AppColors.ink700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepSurfaces() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Superficies y Medidas', style: AppTypography.subheading.copyWith(fontSize: 18)),
            AppBadge(text: '${_totalArea.toStringAsFixed(1)} m² Total', variant: AppBadgeVariant.brand),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text('Ingresa las dimensiones en metros de cada pared o techo.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.lg),

        ..._surfaces.asMap().entries.map((entry) {
          final s = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AppCard(
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.brandLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'P${entry.key + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.brand700),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(s.name, style: AppTypography.subheading.copyWith(fontSize: 14)),
                        Text('${s.widthMeters} m ancho × ${s.heightMeters} m alto · ${s.finishType}', style: AppTypography.caption),
                      ],
                    ),
                  ),
                  Text('${s.areaM2.toStringAsFixed(1)} m²', style: AppTypography.badgeText),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.danger700),
                    onPressed: () => setState(() => _surfaces.removeAt(entry.key)),
                  ),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: AppSpacing.md),
        AppButton(
          text: 'Agregar otra pared o superficie',
          variant: AppButtonVariant.outline,
          icon: Icons.add,
          onPressed: _showAddSurfaceDialog,
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface0,
        border: Border(top: BorderSide(color: AppColors.line300)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: AppButton(
                text: 'Atrás',
                variant: AppButtonVariant.outline,
                onPressed: () => setState(() => _currentStep--),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            flex: 2,
            child: AppButton(
              text: _currentStep == 3 ? 'Publicar Solicitud' : 'Siguiente',
              icon: _currentStep == 3 ? Icons.send : null,
              onPressed: () {
                if (_currentStep < 3) {
                  setState(() => _currentStep++);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Solicitud de cotización publicada exitosamente!'),
                      backgroundColor: AppColors.brand700,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
