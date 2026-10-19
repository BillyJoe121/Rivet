import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.icon,
    required this.variant,
    this.isUnread = false,
  });

  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final IconData icon;
  final AppBadgeVariant variant;
  final bool isUnread;
}

/// Centro de notificaciones de la plataforma (P-043).
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const notifications = [
      NotificationItem(
        id: 'n1',
        title: 'Nueva propuesta recibida',
        description: 'Carlos Mendoza envió una cotización detallada para tu proyecto "Pintura sala".',
        timeAgo: 'Hace 15 min',
        icon: Icons.receipt_long,
        variant: AppBadgeVariant.brand,
        isUnread: true,
      ),
      NotificationItem(
        id: 'n2',
        title: 'Visita técnica agendada',
        description: 'Se confirmó la visita presencial de evaluación para el jueves 8:00 AM.',
        timeAgo: 'Hace 2 horas',
        icon: Icons.event_available,
        variant: AppBadgeVariant.info,
        isUnread: true,
      ),
      NotificationItem(
        id: 'n3',
        title: 'Materiales listos en bodega',
        description: 'FerreCasa Central confirmó el despacho de pintura y estuco para la obra.',
        timeAgo: 'Ayer',
        icon: Icons.local_shipping_outlined,
        variant: AppBadgeVariant.success,
      ),
      NotificationItem(
        id: 'n4',
        title: 'Confirmación mutua requerida',
        description: 'El contratista reportó el cierre de obra. Revisa el acabado para liberar fondos.',
        timeAgo: 'Hace 3 días',
        icon: Icons.verified_outlined,
        variant: AppBadgeVariant.warning,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.paper100,
      appBar: AppHeader(
        title: 'Notificaciones',
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Marcar leídas', style: TextStyle(fontSize: 13, color: AppColors.brand700)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: AppSpacing.screenPadding,
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: AppCard(
              backgroundColor: n.isUnread ? AppColors.brandLight.withValues(alpha: 0.3) : AppColors.surface0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(n.icon, size: 22, color: AppColors.brand700),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(n.title, style: AppTypography.subheading.copyWith(fontSize: 14)),
                            if (n.isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.clay600,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(n.description, style: AppTypography.bodySmall),
                        const SizedBox(height: 4),
                        Text(n.timeAgo, style: AppTypography.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
