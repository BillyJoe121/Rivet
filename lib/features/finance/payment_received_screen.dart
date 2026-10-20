import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'payout_mock.dart';

/// Confirmación de pago liberado sobre fondo de marca (Figma 66:14883).
/// Es una simulación: no se realiza ninguna transferencia real.
class PaymentReceivedScreen extends StatelessWidget {
  const PaymentReceivedScreen({super.key});

  static const Color _ink = ProColors.paper100;

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      background: ProColors.brand700,
      bottomNav: const ProBottomNav(active: ProNavDestination.projects),
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(22, 19, 22, 7),
        child: GestureDetector(
          onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: ProColors.paper100,
              borderRadius: BorderRadius.circular(ProRadii.button),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Volver al inicio del contratista',
                    textAlign: TextAlign.center,
                    style: ProText.r(14, weight: FontWeight.w600, color: ProColors.brand700, lineHeight: 16.4),
                  ),
                ),
                const ProChevron(color: ProColors.brand700),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 44, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            Text(
              'Rivet',
              textAlign: TextAlign.center,
              style: ProText.serif(30, color: _ink, lineHeight: 38.4),
            ),
            Center(
              child: Container(
                width: 86,
                height: 86,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: _ink, shape: BoxShape.circle),
                child: const ProIcon(LucideIcon.check, size: 42, color: ProColors.brand700, strokeWidth: 3),
              ),
            ),
            Text(
              '¡Has recibido el pago de tu proyecto!',
              textAlign: TextAlign.center,
              style: ProText.serif(30, color: _ink, lineHeight: 37.5),
            ),
            Text(
              PayoutMock.paidProject,
              textAlign: TextAlign.center,
              style: ProText.r(16, color: _ink, lineHeight: 18.75),
            ),
            const _ReleaseSummary(),
            Text(
              '✓ Cierre confirmado por ambas partes\n✓ Cuenta verificada · •••• 5678\n✓ Pago liberado (simulación)',
              textAlign: TextAlign.center,
              style: ProText.r(13, color: _ink, lineHeight: 19.5),
            ),
            Text(
              'Prototipo académico. No se realizó ninguna transferencia real.',
              textAlign: TextAlign.center,
              style: ProText.r(12, color: _ink, lineHeight: 16.8),
            ),
          ],
        ),
      ),
    );
  }
}

/// Recuadro translúcido con el monto neto, el desglose y la fecha.
class _ReleaseSummary extends StatelessWidget {
  const _ReleaseSummary();

  @override
  Widget build(BuildContext context) {
    const ink = PaymentReceivedScreen._ink;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(ProRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Text(
            'Neto recibido · Simulación',
            textAlign: TextAlign.center,
            style: ProText.r(13, color: ink, lineHeight: 15.234375),
          ),
          Text(
            PayoutMock.netAmount,
            textAlign: TextAlign.center,
            style: ProText.serif(32, color: ink, lineHeight: 40.96),
          ),
          Text(
            'Mano de obra acordada: ${PayoutMock.laborAmount}\n'
            'Sin deducciones. No incluye materiales ni garantía.\n'
            '${PayoutMock.paymentDate}',
            textAlign: TextAlign.center,
            style: ProText.r(12, color: ink, lineHeight: 16.8),
          ),
        ],
      ),
    );
  }
}
