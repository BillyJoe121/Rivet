import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Pantalla para agendar visita presencial con alcance y fecha (P-020 / P-021).
class ContractorVisitScreen extends StatefulWidget {
  const ContractorVisitScreen({super.key, required this.contractor});

  final Contractor contractor;

  @override
  State<ContractorVisitScreen> createState() => _ContractorVisitScreenState();
}

class _ContractorVisitScreenState extends State<ContractorVisitScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  String _timeSlot = 'Mañana (8:00 AM - 12:00 PM)';
  final _addressController = TextEditingController(text: 'Carrera 98 # 42-15, Apto 402, Valle del Lili');
  final _notesController = TextEditingController(text: 'Deseo que revise la humedad de la pared principal antes de pintar.');

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Agendar Visita',
        subtitle: widget.contractor.name,
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Resumen Profesional
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.brandLight,
                    child: Text(
                      widget.contractor.name.split(' ').map((n) => n[0]).take(2).join(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.brand700),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.contractor.name, style: AppTypography.subheading.copyWith(fontSize: 15)),
                        Text('Visita de inspección y asesoría técnica', style: AppTypography.caption),
                      ],
                    ),
                  ),
                  const AppBadge(text: 'Cortesía / \$0', variant: AppBadgeVariant.success),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Fecha y Horario de la Visita (P-021)', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('Acuerda una fecha para que el profesional revise el espacio en persona.', style: AppTypography.bodySmall),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.brand700),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha seleccionada', style: AppTypography.caption),
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: AppTypography.subheading,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_calendar_outlined, color: AppColors.ink500),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            AppSegmentedControl<String>(
              items: const {
                'Mañana (8:00 AM - 12:00 PM)': 'Mañana (8 - 12)',
                'Tarde (1:00 PM - 5:00 PM)': 'Tarde (1 - 5)',
              },
              selected: _timeSlot,
              onChanged: (slot) => setState(() => _timeSlot = slot),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Dirección Protegida (P-021)', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('Solo se compartirá con el profesional para acudir a la visita.', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Dirección completa',
              controller: _addressController,
              prefixIcon: Icons.location_on_outlined,
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              label: 'Notas de acceso o alcance',
              hint: 'Ej. Indicar si hay parqueadero de visitantes o portería.',
              controller: _notesController,
              maxLines: 2,
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Confirmar Solicitud de Visita',
              icon: Icons.check,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Solicitud de visita enviada al profesional!'),
                    backgroundColor: AppColors.brand700,
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
