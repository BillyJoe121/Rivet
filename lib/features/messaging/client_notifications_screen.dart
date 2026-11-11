import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import '../proposals/received_proposals_screen.dart';
import 'messaging_module.dart';
import 'messaging_screens.dart';

/// Centro de notificaciones del cliente (P-043).
class ClientNotificationsScreen extends StatelessWidget {
  const ClientNotificationsScreen({
    super.key,
    this.messagingBloc,
  });

  final MessagingBloc? messagingBloc;

  @override
  Widget build(BuildContext context) {
    if (messagingBloc != null) {
      return BlocProvider<MessagingBloc>.value(
        value: messagingBloc!,
        child: const _ClientNotificationsView(),
      );
    }

    try {
      context.read<MessagingBloc>();
      return const _ClientNotificationsView();
    } catch (_) {
      return BlocProvider<MessagingBloc>(
        create: (context) {
          final repository = context.read<MessagingRepository>();
          return MessagingBloc(
            GetConversationsUseCase(repository),
            SendChatMessageUseCase(repository),
            SendCounterOfferUseCase(repository),
            RespondCounterOfferUseCase(repository),
            GetClientNotificationsUseCase(repository),
            MarkNotificationReadUseCase(repository),
          )..add(const LoadMessagingData());
        },
        child: const _ClientNotificationsView(),
      );
    }
  }
}

class _ClientNotificationsView extends StatelessWidget {
  const _ClientNotificationsView();

  IconData _iconFor(ClientNotificationType type) {
    return switch (type) {
      ClientNotificationType.proposalReceived => LucideIcons.fileSpreadsheet,
      ClientNotificationType.counterOfferUpdate => LucideIcons.handCoins,
      ClientNotificationType.visitScheduled => LucideIcons.calendarCheck,
      ClientNotificationType.projectMilestone => LucideIcons.sparkles,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagingBloc, MessagingState>(
      builder: (context, state) {
        final items = state.notifications;

        return RivetScaffold(
          title: 'Avisos',
          showBackButton: true,
          backgroundImagePath: AppHeroImages.messages,
          body: AppPageBody(
            onRefresh: () async {
              context.read<MessagingBloc>().add(const LoadMessagingData());
            },
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionHeader(
                      title: 'Actividad reciente',
                      count: state.unreadNotificationsCount,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (state.isLoading && items.isEmpty)
                      const AppLoadingState(label: 'Cargando notificaciones')
                    else if (state.status == MessagingStatus.failure &&
                        items.isEmpty)
                      AppErrorState(
                        message: state.errorMessage ??
                            'No pudimos consultar tus notificaciones.',
                        onRetry: () => context.read<MessagingBloc>().add(
                          const LoadMessagingData(),
                        ),
                      )
                    else if (items.isEmpty)
                      const AppEmptyState(
                        title: 'Estás al día',
                        message:
                            'Aquí te avisaremos cuando lleguen propuestas nuevas, mensajes o avances de obra.',
                        icon: LucideIcons.bell,
                      )
                    else
                      for (var i = 0; i < items.length; i++) ...[
                        AppCard(
                          backgroundColor: items[i].isRead
                              ? AppColors.paper100
                              : AppColors.brandLight,
                          onTap: () {
                            context.read<MessagingBloc>().add(
                              MarkNotificationAsRead(items[i].id),
                            );
                            _navigateFromNotification(context, items[i]);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _iconFor(items[i].type),
                                size: 22,
                                color: AppColors.brand700,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            items[i].title,
                                            style: AppTypography.subheading,
                                          ),
                                        ),
                                        if (!items[i].isRead)
                                          const AppBadge(
                                            text: 'Nueva',
                                            variant: AppBadgeVariant.brand,
                                            compact: true,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      items[i].body,
                                      style: AppTypography.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              const Icon(
                                LucideIcons.chevronRight,
                                size: 16,
                                color: AppColors.brand700,
                              ),
                            ],
                          ),
                        ),
                        if (i < items.length - 1)
                          const SizedBox(height: AppSpacing.sm),
                      ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateFromNotification(
    BuildContext context,
    ClientNotificationItem item,
  ) {
    if (item.conversationId != null) {
      final bloc = context.read<MessagingBloc>();
      AppNavigator.push(
        context,
        BlocProvider<MessagingBloc>.value(
          value: bloc,
          child: ProjectChatScreen(conversationId: item.conversationId!),
        ),
      );
      return;
    }

    if (item.projectId != null) {
      AppNavigator.push(
        context,
        ReceivedProposalsScreen(projectId: item.projectId!),
      );
    }
  }
}

