import 'package:flutter/material.dart';
import '../../../core/models/models.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/widgets.dart';

/// Modal bottom sheet para ingresar una nueva pared o superficie.
class AddSurfaceSheet extends StatefulWidget {
  const AddSurfaceSheet({
    super.key,
    required this.onAddSurface,
  });

  final ValueChanged<SurfaceItem> onAddSurface;

  @override
  State<AddSurfaceSheet> createState() => _AddSurfaceSheetState();
}

class _AddSurfaceSheetState extends State<AddSurfaceSheet> {
  final _nameController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  String _finishType = 'Vinilo Tipo 1 Blanco';

  @override
  void dispose() {
    _nameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final width = double.tryParse(_widthController.text.trim()) ?? 0;
    final height = double.tryParse(_heightController.text.trim()) ?? 0;

    if (name.isNotEmpty && width > 0 && height > 0) {
      widget.onAddSurface(
        SurfaceItem(
          id: 's-${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          widthMeters: width,
          heightMeters: height,
          finishType: _finishType,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
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
            controller: _nameController,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Ancho (metros)',
                  hint: 'Ej. 3.8',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _widthController,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  label: 'Alto (metros)',
                  hint: 'Ej. 2.6',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  controller: _heightController,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Tipo de acabado esperado', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            initialValue: _finishType,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface0,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.line300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            ),
            items: const [
              DropdownMenuItem(value: 'Vinilo Tipo 1 Blanco', child: Text('Vinilo Tipo 1 Blanco')),
              DropdownMenuItem(value: 'Vinilo Lavable Color', child: Text('Vinilo Lavable Color')),
              DropdownMenuItem(value: 'Estuco y Pintura Completa', child: Text('Estuco y Pintura Completa')),
              DropdownMenuItem(value: 'Esmalte / Barniz', child: Text('Esmalte / Barniz')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _finishType = val);
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            text: 'Guardar Superficie',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
