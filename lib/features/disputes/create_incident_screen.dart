import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Formulario para reportar incidencia o problema en obra (P-040).
class CreateIncidentScreen extends StatefulWidget {
  const CreateIncidentScreen({
    super.key,
    required this.projectTitle,
    required this.counterpartName,
  });

  final String projectTitle;
  final String counterpartName;

  @override
  State<CreateIncidentScreen> createState() => _CreateIncidentScreenState();
}

class _CreateIncidentScreenState extends State<CreateIncidentScreen> {
  String _category = 'Calidad del acabado o textura';
  final _descriptionController = TextEditingController();
  bool _hasPhotoAttached = true;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(title: 'Reportar Problema'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Proyecto Asociado (P-040)', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.xs),
                    Text(widget.projectTitle, style: AppTypography.subheading),
                    Text('Involucrado: ${widget.counterpartName}', style: AppTypography.caption),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              Text('Categoría de la Incidencia', style: AppTypography.subheading),
              const SizedBox(height: AppSpacing.md),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface0,
                  borderRadius: AppSpacing.roundedSm,
                  border: Border.all(color: AppColors.line300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _category,
                    isExpanded: true,
                    items: [
                      'Calidad del acabado o textura',
                      'Faltante o discrepancia de materiales',
                      'Retraso no acordado en la obra',
                      'Daño accidental a piso o mobiliario',
                      'Silencio o inasistencia del profesional',
                    ].map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: AppTypography.bodyMedium))).toList(),
                    onChanged: (val) => setState(() => _category = val ?? _category),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                label: 'Descripción de los hechos',
                hint: 'Describe detalladamente la inconformidad observada.',
                controller: _descriptionController,
                maxLines: 4,
              ),

              const SizedBox(height: AppSpacing.lg),

              Text('Evidencia Fotográfica', style: AppTypography.subheading),
              const SizedBox(height: AppSpacing.xs),
              Text('Adjunta fotos claras que muestren el área afectada sin alterar la imagen.', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.md),

              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image_outlined, color: AppColors.ink700),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_hasPhotoAttached ? 'foto_pared_grieta.jpg' : 'Sin foto adjunta', style: AppTypography.subheading.copyWith(fontSize: 14)),
                          Text('1.8 MB · Evidencia de muro', style: AppTypography.caption),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(_hasPhotoAttached ? Icons.check_circle : Icons.add_a_photo, color: AppColors.brand700),
                      onPressed: () => setState(() => _hasPhotoAttached = !_hasPhotoAttached),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              AppButton(
                text: 'Radicar Incidencia en Soporte',
                variant: AppButtonVariant.primary,
                icon: Icons.report_problem_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Incidencia radicada! Se asignó el caso #CASO-1082.'),
                      backgroundColor: AppColors.brand700,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
