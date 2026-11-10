import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/theme.dart';
import '../../core/widgets/widgets.dart';
import '../supplier/material_price_tier.dart';
import 'messaging_module.dart';

/// Hilo de chat y contraoferta del proyecto con respuesta simulada (P-030).
class ProjectChatScreen extends StatefulWidget {
  const ProjectChatScreen({
    super.key,
    required this.conversationId,
    this.contractorName = 'Contratista',
    this.projectTitle = 'Proyecto en curso',
    this.messagingBloc,
  });

  final String conversationId;
  final String contractorName;
  final String projectTitle;
  final MessagingBloc? messagingBloc;

  @override
  State<ProjectChatScreen> createState() => _ProjectChatScreenState();
}

class _ProjectChatScreenState extends State<ProjectChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  MessagingBloc _resolveBloc(BuildContext context) {
    if (widget.messagingBloc != null) return widget.messagingBloc!;
    try {
      return context.read<MessagingBloc>();
    } catch (_) {
      return MessagingBloc(
        MessagingService.instance.getConversationsUseCase,
        MessagingService.instance.sendChatMessageUseCase,
        MessagingService.instance.sendCounterOfferUseCase,
        MessagingService.instance.respondCounterOfferUseCase,
        MessagingService.instance.getClientNotificationsUseCase,
        MessagingService.instance.markNotificationReadUseCase,
      )..add(const LoadMessagingData());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = _resolveBloc(context);
    return BlocProvider<MessagingBloc>.value(
      value: bloc,
      child: BlocConsumer<MessagingBloc, MessagingState>(
        listener: (context, state) {
          if (state.status == MessagingStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  duration: const Duration(seconds: 5),
                ),
              );
          }
        },
        builder: (context, state) {
          final conv = state.conversationById(widget.conversationId) ??
              (state.conversations.isNotEmpty
                  ? state.conversations.first
                  : null);

          return RivetScaffold(
            title: 'Conversación',
            showBackButton: true,
            backgroundImagePath: AppHeroImages.messages,
            actions: [
              IconButton(
                tooltip: 'Enviar contraoferta',
                onPressed: conv == null
                    ? null
                    : () => _openCounterOfferSheet(context, conv.id),
                icon: const Icon(
                  LucideIcons.handCoins,
                  color: AppColors.brand700,
                ),
              ),
            ],
            bottomBar: _ChatComposerBar(
              controller: _messageController,
              onSend: () {
                final targetId = conv?.id ?? widget.conversationId;
                final text = _messageController.text;
                _messageController.clear();
                context.read<MessagingBloc>().add(
                  SendChatMessageRequested(
                    conversationId: targetId,
                    text: text,
                  ),
                );
              },
              onCounterOffer: conv == null
                  ? null
                  : () => _openCounterOfferSheet(context, conv.id),
            ),
            body: AppPageBody(
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conv?.contractorName ?? widget.contractorName,
                        style: AppTypography.sectionTitle,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        conv?.projectTitle ?? widget.projectTitle,
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const AppInfoBanner(
                        compact: true,
                        message:
                            'Chat simulado de prueba. Tus mensajes reciben respuesta automática.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (conv == null && state.isLoading)
                  const AppLoadingState(label: 'Cargando conversación')
                else if (conv == null)
                  const AppEmptyState(
                    title: 'Sin mensajes previos',
                    message:
                        'Escribe tu primer mensaje abajo para iniciar el hilo.',
                  )
                else
                  for (final msg in conv.messages) ...[
                    _ChatBubble(
                      message: msg,
                      onRespondCounterOffer: (accepted) {
                        context.read<MessagingBloc>().add(
                          RespondCounterOfferRequested(
                            conversationId: conv.id,
                            messageId: msg.id,
                            accepted: accepted,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _openCounterOfferSheet(BuildContext context, String conversationId) {
    final amountController = TextEditingController(text: '2050000');
    final daysController = TextEditingController(text: '5');
    final noteController = TextEditingController(
      text: 'Propongo ajustar el valor manteniendo dos manos de vinilo.',
    );
    final bloc = context.read<MessagingBloc>();

    showAppBottomSheet<void>(
      context,
      builder: (sheetContext) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enviar contraoferta', style: AppTypography.sectionTitle),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Nuevo monto propuesto (COP)',
                controller: amountController,
                keyboardType: TextInputType.number,
                prefixIcon: LucideIcons.coins,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Plazo estimado (días)',
                controller: daysController,
                keyboardType: TextInputType.number,
                prefixIcon: LucideIcons.clock,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Nota o condición',
                controller: noteController,
                maxLines: 2,
                prefixIcon: LucideIcons.fileText,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                text: 'Enviar contraoferta al chat',
                showChevron: true,
                onPressed: () {
                  final amount =
                      int.tryParse(amountController.text.replaceAll('.', '')) ??
                      0;
                  final days = int.tryParse(daysController.text) ?? 0;
                  Navigator.of(sheetContext).pop();
                  bloc.add(
                    SendCounterOfferRequested(
                      conversationId: conversationId,
                      amountCop: amount,
                      estimatedDays: days,
                      note: noteController.text,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({
    required this.message,
    required this.onRespondCounterOffer,
  });

  final ChatMessage message;
  final ValueChanged<bool> onRespondCounterOffer;

  @override
  Widget build(BuildContext context) {
    final isMe = message.fromClient;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: AppCard(
          backgroundColor: isMe ? AppColors.brandLight : AppColors.surface0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isMe ? 'Tú' : message.senderName,
                style: AppTypography.captionStrong.copyWith(
                  color: AppColors.brand700,
                ),
              ),
              const SizedBox(height: 4),
              Text(message.text, style: AppTypography.bodyLarge),
              if (message.isCounterOffer &&
                  message.counterOfferAmountCop != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: const BoxDecoration(
                    color: AppColors.paper100,
                    borderRadius: AppSpacing.roundedSm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contraoferta: \$ ${formatCop(message.counterOfferAmountCop!)} COP · ${message.counterOfferDays ?? 5} días',
                        style: AppTypography.labelStrong,
                      ),
                      const SizedBox(height: 4),
                      AppBadge(
                        text: switch (message.counterOfferStatus) {
                          CounterOfferStatus.pending => 'Pendiente de respuesta',
                          CounterOfferStatus.accepted => 'Contraoferta aceptada',
                          CounterOfferStatus.rejected =>
                            'Contraoferta rechazada',
                        },
                        variant: switch (message.counterOfferStatus) {
                          CounterOfferStatus.pending => AppBadgeVariant.warning,
                          CounterOfferStatus.accepted =>
                            AppBadgeVariant.success,
                          CounterOfferStatus.rejected => AppBadgeVariant.danger,
                        },
                        compact: true,
                      ),
                      if (message.counterOfferStatus ==
                          CounterOfferStatus.pending) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                text: 'Aceptar',
                                size: AppButtonSize.sm,
                                onPressed: () => onRespondCounterOffer(true),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: AppButton(
                                text: 'Rechazar',
                                size: AppButtonSize.sm,
                                variant: AppButtonVariant.outline,
                                onPressed: () => onRespondCounterOffer(false),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatComposerBar extends StatelessWidget {
  const _ChatComposerBar({
    required this.controller,
    required this.onSend,
    this.onCounterOffer,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onCounterOffer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenGutter,
        AppSpacing.sm,
        AppSpacing.screenGutter,
        AppSpacing.sm + MediaQuery.viewInsetsOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface0,
        border: Border(
          top: BorderSide(
            color: AppColors.line300,
            width: AppSpacing.strokeDivider,
          ),
        ),
      ),
      child: Row(
        children: [
          if (onCounterOffer != null) ...[
            IconButton(
              tooltip: 'Proponer contraoferta',
              onPressed: onCounterOffer,
              icon: const Icon(LucideIcons.coins, color: AppColors.brand700),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Expanded(
            child: AppSearchBar(
              controller: controller,
              hintText: 'Escribe un mensaje al contratista...',
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            tooltip: 'Enviar mensaje',
            onPressed: onSend,
            icon: const Icon(LucideIcons.send, color: AppColors.brand700),
          ),
        ],
      ),
    );
  }
}

