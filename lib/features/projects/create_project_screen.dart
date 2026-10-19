import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

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

  // Controladores para agregar nueva pared
  final _surfaceNameController = TextEditingController();
  final _surfaceWidthController = TextEditingController();
  final _surfaceHeightController = TextEditingController();

  // Paso 2: IA y Privacidad
  bool _aiMinimizationAccepted = true;
  bool _noPrivateDataConfirmed = true;

  double get _totalArea => _surfaces.fold(0.0, (acc, s) => acc + s.areaM2);

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _neighborhoodController.dispose();
    _surfaceNameController.dispose();
    _surfaceWidthController.dispose();
    _surfaceHeightController.dispose();
    super.dispose();
  }

  void _addSurface() {
    final name = _surfaceNameController.text.trim();
    final width = double.tryParse(_surfaceWidthController.text.trim()) ?? 0;
    final height = double.tryParse(_surfaceHeightController.text.trim()) ?? 0;

    if (name.isNotEmpty && width > 0 && height > 0) {
      setState(() {
        _surfaces.add(SurfaceItem(
          id: 's-${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          widthMeters: width,
          heightMeters: height,
        ));
        _surfaceNameController.clear();
        _surfaceWidthController.clear();
        _surfaceHeightController.clear();
      });
      Navigator.pop(context);
    }
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
                  2 => _buildStepPhotosAndPrivacy(),
                  _ => _buildStepReviewAndPublish(),
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

  Widget _buildStepPhotosAndPrivacy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fotos y Autorización de IA (P-011)', style: AppTypography.subheading.copyWith(fontSize: 18)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Para proteger tu intimidad, las fotos se procesan para difuminar personas, cuadros y objetos personales antes de ser visibles para los pintores.',
          style: AppTypography.bodySmall,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Imagen de muestra procesada
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    'Fondos/Sala minimalista con plantas y luz suave.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(color: AppColors.brandLight),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.brand700, size: 18),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Foto minimizada: objetos personales ocultos, textura de pared resaltada para cotización.',
                        style: TextStyle(fontSize: 12, color: AppColors.ink700),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        CheckboxListTile(
          value: _aiMinimizationAccepted,
          onChanged: (val) => setState(() => _aiMinimizationAccepted = val ?? false),
          title: Text('Autorizo el procesamiento de IA para ocultar elementos privados', style: AppTypography.bodySmall),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.brand700,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          value: _noPrivateDataConfirmed,
          onChanged: (val) => setState(() => _noPrivateDataConfirmed = val ?? false),
          title: Text('Confirmo que la foto no contiene documentos ni datos sensibles', style: AppTypography.bodySmall),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.brand700,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildStepReviewAndPublish() {
    final estimatedPaintGallons = (_totalArea / 25.0).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dossier y Revisión Final (P-015)', style: AppTypography.subheading.copyWith(fontSize: 18)),
        const SizedBox(height: AppSpacing.xs),
        Text('Revisa cómo verán los contratistas tu solicitud.', style: AppTypography.bodySmall),
        const SizedBox(height: AppSpacing.lg),

        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_titleController.text, style: AppTypography.subheading),
              Text('${_cityController.text} · ${_neighborhoodController.text}', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppStatTile(
                      label: 'ÁREA TOTAL',
                      value: '${_totalArea.toStringAsFixed(1)} m²',
                      icon: Icons.square_foot,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppStatTile(
                      label: 'PINTURA SUGERIDA',
                      value: '$estimatedPaintGallons Galones',
                      icon: Icons.format_paint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Superficies incluidas (${_surfaces.length}):',
                style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),
              ..._surfaces.map((s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• ${s.name} (${s.areaM2.toStringAsFixed(1)} m²)', style: AppTypography.bodySmall),
                  )),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),
        const AppCard(
          backgroundColor: AppColors.brandLight,
          child: Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.brand700),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Publicar no tiene costo. Los pintores te enviarán propuestas separando mano de obra de insumos.',
                  style: TextStyle(fontSize: 13, color: AppColors.brand700, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
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

  void _showAddSurfaceDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Agregar Superficie', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Nombre de la pared / techo',
              hint: 'Ej. Pared balcón',
              controller: _surfaceNameController,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Ancho (metros)',
                    hint: 'Ej. 3.8',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _surfaceWidthController,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    label: 'Alto (metros)',
                    hint: 'Ej. 2.6',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _surfaceHeightController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Guardar Superficie',
              onPressed: _addSurface,
            ),
          ],
        ),
      ),
    );
  }
}
