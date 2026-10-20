import 'package:flutter/material.dart';
import '../../core/models/models.dart';
import '../../core/widgets/widgets.dart';
import '../home/widgets/kit/kit.dart';
import 'widgets/finance_widgets.dart';

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
    this.icon = LucideIcon.creditCard,
  });

  final String id;
  final String concept;
  final String party;
  final int amountCop;
  final String date;
  final String status;
  final AppBadgeVariant variant;
  final bool isIncome;
  final LucideIcon icon;
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
        icon: LucideIcon.user,
      ),
      TransactionEntry(
        id: 'TX-402',
        concept: 'Compra de materiales FerreCasa',
        party: 'FerreCasa Central',
        amountCop: 420000,
        date: '18 Oct 2026',
        status: 'Despachado',
        variant: AppBadgeVariant.brand,
        icon: LucideIcon.package,
      ),
      TransactionEntry(
        id: 'TX-398',
        concept: 'Visita presencial de inspección',
        party: 'Jorge Eliécer Silva',
        amountCop: 35000,
        date: '15 Oct 2026',
        status: 'Completado',
        variant: AppBadgeVariant.success,
        icon: LucideIcon.mapPin,
      ),
    ];

    return ProScreen(
      backgroundAsset: ProAssets.headerShop,
      navWhenPushed: ProNavDestination.more,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Movimientos y Finanzas',
            lucideChevron: true,
            height: 120,
            padding: EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            titleWidth: 300,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: ProColors.brandLight,
                      borderRadius: BorderRadius.circular(ProRadii.xl),
                    ),
                    child: Text(
                      'Entorno Simulado V1',
                      style: ProText.r(11, color: ProColors.brand700, lineHeight: 13.2),
                    ),
                  ),
                ),
                const FinanceBalanceCard(
                  title: 'SALDO EN CUSTODIA SIMULADA',
                  amount: '\$1.200.000 COP',
                  note: 'El saldo se liberará a los profesionales una vez apruebes el acabado final.',
                ),
                const SizedBox(height: 6),
                Text('Registro de Operaciones (P-038)', style: ProText.subheading),
                Text('Detalle de desembolsos, órdenes de material y visitas.', style: ProText.bodySmall),
                for (final tx in transactions)
                  FinanceTransactionCard(
                    icon: tx.icon,
                    concept: tx.concept,
                    party: tx.party,
                    date: tx.date,
                    amount: '\$${_formatCurrency(tx.amountCop)}',
                    status: tx.status,
                    variant: tx.variant,
                    isIncome: tx.isIncome,
                  ),
                const SizedBox(height: 14),
              ],
            ),
          ),
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
