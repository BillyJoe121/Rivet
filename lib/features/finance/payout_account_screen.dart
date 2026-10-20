import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'payout_mock.dart';
import 'widgets/payout_widgets.dart';

/// Cuenta bancaria para recibir pagos del contratista (Figma 66:14323).
/// Datos ficticios de prueba: el formulario es de solo lectura en el prototipo.
class PayoutAccountScreen extends StatelessWidget {
  const PayoutAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerPrivacy,
      bottomNav: const ProBottomNav(active: ProNavDestination.more),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(22, 21, 22, 8),
        child: ProPrimaryButton(
          'Guardar cuenta y volver',
          onTap: () => Navigator.maybePop(context),
          height: 48,
          horizontalPadding: 16,
          labelStyle: ProText.r(14, weight: FontWeight.w600, color: ProColors.surface0, lineHeight: 16.8),
          gap: 6,
          width: double.infinity,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Cuenta para recibir pagos',
            height: 120,
            padding: EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            titleWidth: 235,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: ProColors.brandLight,
                    borderRadius: BorderRadius.circular(ProRadii.xl),
                  ),
                  child: Text(PayoutMock.role, style: ProText.r(11, color: ProColors.brand700, lineHeight: 13.2)),
                ),
                ProCard(
                  radius: ProRadii.lg,
                  borderWidth: 0.6,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: const _AccountFields(),
                ),
                PayoutSummaryCard(
                  title: 'Resumen protegido',
                  status: PayoutMock.pendingStatus,
                  summary: '${PayoutMock.holder} · ${PayoutMock.bank} ${PayoutMock.accountType} · ${PayoutMock.shortAccount}',
                  note:
                      'Después de guardar solo se muestran los últimos 4 dígitos. No es un método de pago del cliente.',
                ),
                const _PendingNotice(),
                Text(
                  'Vuelve a tu perfil profesional. Pago recibido estará disponible únicamente con cuenta verificada y cierre confirmado.',
                  style: ProText.r(12, color: ProColors.ink500, lineHeight: 15),
                ),
                Text(
                  'Prototipo académico: no se realiza ninguna transferencia real.',
                  style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.75),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cuatro campos de la cuenta y la nota de datos ficticios.
class _AccountFields extends StatelessWidget {
  const _AccountFields();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        PayoutField(label: 'Titular de la cuenta *', value: PayoutMock.holder),
        PayoutField(label: 'Entidad financiera *', value: 'Bancolombia  ⌄'),
        PayoutField(label: 'Tipo de cuenta *', value: 'Ahorros  ⌄'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 3,
          children: [
            PayoutField(label: 'Número de cuenta *', value: PayoutMock.maskedAccount),
            Text(
              'Datos ficticios de prueba · entrada protegida',
              style: ProText.r(11, color: ProColors.brand700, lineHeight: 13.75),
            ),
          ],
        ),
      ],
    );
  }
}

/// Aviso de cuenta pendiente en fondo ámbar.
class _PendingNotice extends StatelessWidget {
  const _PendingNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: ProColors.warningLight, borderRadius: BorderRadius.circular(ProRadii.md)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProIcon(LucideIcon.circleAlert, size: 20, color: ProColors.warning800),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Una cuenta pendiente no permite recibir pagos. Si no tienes cuenta al liberar el pago, primero debes configurarla y verificarla.',
              style: ProText.r(12, color: ProColors.ink500, lineHeight: 15),
            ),
          ),
        ],
      ),
    );
  }
}
