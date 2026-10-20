import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

/// Abre los modales del núcleo tal como aparecen en el Figma.
class ModalGalleryScreen extends StatelessWidget {
  const ModalGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RivetScaffold(
      title: 'Modales',
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppButton(
            text: 'Confirmación',
            onPressed: () => showAppConfirmDialog(
              context,
              title: 'Finalizar proyecto',
              message: '¿Confirmas que el trabajo está terminado?',
              confirmLabel: 'Finalizar',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Elegir precio',
            onPressed: () => showAppPriceSelectDialog(
              context,
              productTitle: 'Pintura vinilo premium',
              options: const [
                AppPriceOption(label: '4 galones', value: r'$ 348.000'),
                AppPriceOption(label: '10 galones', value: r'$ 870.000'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Elegir fecha',
            onPressed: () => showAppDatePickerDialog(context, initialDate: DateTime(2024, 5, 17)),
          ),
        ],
      ),
    );
  }
}
