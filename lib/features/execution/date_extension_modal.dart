import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Modal para solicitar o acordar prórroga de fecha de entrega (P-035).
class DateExtensionModal extends StatefulWidget {
  const DateExtensionModal({
    super.key,
    required this.currentDeadline,
    required this.projectTitle,
  });

  final DateTime currentDeadline;
  final String projectTitle;

  @override
  State<DateExtensionModal> createState() => _DateExtensionModalState();
}

class _DateExtensionModalState extends State<DateExtensionModal> {
  late DateTime _newDeadline;
  final _reasonController = TextEditingController(
    text: 'Se requiere 1 día adicional para secado completo de la segunda mano de vinilo debido a alta humedad relativa.',
  );

  @override
  void initState() {
    super.initState();
    _newDeadline = widget.currentDeadline.add(const Duration(days: 2));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(title: 'Solicitar Prórroga'),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Acuerdo de Prórroga (P-035)', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(widget.projectTitle, style: AppTypography.subheading),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fecha de entrega vigente:', style: AppTypography.bodySmall),
                      Text(
                        '${widget.currentDeadline.day}/${widget.currentDeadline.month}/${widget.currentDeadline.year}',
                        style: AppTypography.badgeText,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Nueva Fecha Propuesta', style: AppTypography.subheading),
            const SizedBox(height: AppSpacing.xs),
            Text('La nueva fecha solo entrará en vigencia si ambas partes la aprueban.', style: AppTypography.caption),
            const SizedBox(height: AppSpacing.md),

            AppCard(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _newDeadline,
                  firstDate: widget.currentDeadline,
                  lastDate: widget.currentDeadline.add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() => _newDeadline = picked);
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.event_repeat, color: AppColors.brand700),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha propuesta', style: AppTypography.caption),
                        Text(
                          '${_newDeadline.day}/${_newDeadline.month}/${_newDeadline.year}',
                          style: AppTypography.subheading,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.edit_calendar_outlined, color: AppColors.ink500),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            AppTextField(
              label: 'Motivo técnico de la extensión',
              controller: _reasonController,
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.xxl),

            AppButton(
              text: 'Enviar Propuesta de Prórroga',
              icon: Icons.send_outlined,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Propuesta de prórroga enviada para aceptación mutua!'),
                    backgroundColor: AppColors.brand700,
                  ),
                );
                Navigator.pop(context, _newDeadline);
              },
            ),
          ],
        ),
      ),
    );
  }
}
