import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/utils/app_page_route.dart';
import '../../core/widgets/widgets.dart';
import 'messaging_module.dart';
import 'project_chat_screen.dart';

export 'project_chat_screen.dart';

/// Bandeja de conversaciones del cliente (P-030 lista).
class ConversationsListScreen extends StatelessWidget {
  const ConversationsListScreen({
    super.key,
    this.messagingBloc,
  });

  final MessagingBloc? messagingBloc;

  @override
  Widget build(BuildContext context) {
    if (messagingBloc != null) {
      return BlocProvider<MessagingBloc>.value(
        value: messagingBloc!,
        child: const _ConversationsListView(),
      );
    }

    try {
      context.read<MessagingBloc>();
      return const _ConversationsListView();
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
        child: const _ConversationsListView(),
      );
    }
  }
}

class _ConversationsListView extends StatelessWidget {
  const _ConversationsListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagingBloc, MessagingState>(
      builder: (context, state) {
        final conversations = state.conversations;
        return RivetScaffold(
          title: 'Mensajes',
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
                    const AppSectionHeader(
                      title: 'Conversaciones con contratistas',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (state.isLoading && conversations.isEmpty)
                      const AppLoadingState(label: 'Cargando conversaciones')
                    else if (state.status == MessagingStatus.failure &&
                        conversations.isEmpty)
                      AppErrorState(
                        message: state.errorMessage ??
                            'No pudimos cargar tus mensajes.',
                        onRetry: () => context.read<MessagingBloc>().add(
                          const LoadMessagingData(),
                        ),
                      )
                    else if (conversations.isEmpty)
                      const AppEmptyState(
                        title: 'Aún no tienes conversaciones activas',
                        message:
                            'Cuando recibas propuestas o escribas a un contratista desde el directorio, tus hilos aparecerán aquí.',
                        icon: LucideIcons.messageSquare,
                      )
                    else
                      for (var i = 0; i < conversations.length; i++) ...[
                        AppCard(
                          backgroundColor: AppColors.paper100,
                          onTap: () {
                            final bloc = context.read<MessagingBloc>();
                            AppNavigator.push(
                              context,
                              BlocProvider<MessagingBloc>.value(
                                value: bloc,
                                child: ProjectChatScreen(
                                  conversationId: conversations[i].id,
                                  contractorName:
                                      conversations[i].contractorName,
                                  projectTitle: conversations[i].projectTitle,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppAvatar(
                                initials: conversations[i]
                                    .contractorName
                                    .substring(0, 2)
                                    .toUpperCase(),
                                size: 44,
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
                                            conversations[i].contractorName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.subheading,
                                          ),
                                        ),
                                        if (conversations[i].unreadCount > 0)
                                          AppBadge.count(
                                            text:
                                                '${conversations[i].unreadCount}',
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${conversations[i].contractorSpecialty} · ${conversations[i].projectTitle}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.caption,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      conversations[i].lastMessagePreview,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
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
                        if (i < conversations.length - 1)
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
}
