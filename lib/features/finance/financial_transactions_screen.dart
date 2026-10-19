import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

class TransactionEntry {
  const TransactionEntry({
    required this.id,
    required this.concept,
    required this.party,
    required this.amountCop,
    required this.date,
    required this.status,
    required this.variant,
    this.isIncome = false,
  });

  final String id;
  final String concept;
  final String party;
  final int amountCop;
  final String date;
  final String status;
  final AppBadgeVariant variant;
  final bool isIncome;
}

/// Historial de movimientos financieros y liquidaciones (P-038).
class FinancialTransactionsScreen extends StatelessWidget {
  const FinancialTransactionsScreen({super.key, this.currentRole = UserRole.client});

  final UserRole currentRole;

  @override
  Widget build(BuildContext context) {
    const transactions = [
      TransactionEntry(
        id: 'TX-401',
        concept: 'Mano de obra · Pintura sala',
        party: 'Carlos Mendoza',
        amountCop: 780000,
        date: '18 Oct 2026',
        status: 'En Custodia',
        variant: AppBadgeVariant.warning,
      ),
      TransactionEntry(
        id: 'TX-402',
        concept: 'Compra de materiales FerreCasa',
        party: 'FerreCasa Central',
        amountCop: 420000,
        date: '18 Oct 2026',
        status: 'Despachado',
        variant: AppBadgeVariant.brand,
      ),
      TransactionEntry(
        id: 'TX-398',
        concept: 'Visita presencial de inspección',
        party: 'Jorge Eliécer Silva',
        amountCop: 35000,
        date: '15 Oct 2026',
        status: 'Completado',
        variant: AppBadgeVariant.success,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: const AppHeader(
        title: 'Movimientos y Finanzas',
        subtitle: 'Entorno Simulado V1',
      ),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          // Tarjeta de Balance
          AppCard(
            backgroundColor: AppColors.brand800,
            borderColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SALDO EN CUSTODIA SIMULADA',
                  style: AppTypography.caption.copyWith(color: AppColors.leaf300, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '\$1.200.000 COP',
                  style: AppTypography.pageTitle.copyWith(color: Colors.white, fontSize: 26),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'El saldo se liberará a los profesionales una vez apruebes el acabado final.',
                  style: AppTypography.caption.copyWith(color: AppColors.leaf300),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Text('Registro de Operaciones (P-038)', style: AppTypography.subheading),
          const SizedBox(height: AppSpacing.xs),
          Text('Detalle de desembolsos, órdenes de material y visitas.', style: AppTypography.caption),
          const SizedBox(height: AppSpacing.md),

          ...transactions.map((tx) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: AppCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 18,
                          color: tx.isIncome ? AppColors.success700 : AppColors.ink700,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tx.concept, style: AppTypography.subheading.copyWith(fontSize: 14)),
                            Text('${tx.party} · ${tx.date}', style: AppTypography.caption),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${_formatCurrency(tx.amountCop)}',
                            style: AppTypography.subheading.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          AppBadge(text: tx.status, variant: tx.variant),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  static String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
