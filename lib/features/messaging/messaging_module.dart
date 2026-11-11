import 'package:flutter_bloc/flutter_bloc.dart';

import 'domain/messaging_domain.dart';

export 'data/local_messaging_repository.dart';
export 'domain/messaging_domain.dart';

sealed class MessagingEvent {
  const MessagingEvent();
}

final class LoadMessagingData extends MessagingEvent {
  const LoadMessagingData();
}

final class SendChatMessageRequested extends MessagingEvent {
  const SendChatMessageRequested({
    required this.conversationId,
    required this.text,
  });
  final String conversationId;
  final String text;
}

final class SendCounterOfferRequested extends MessagingEvent {
  const SendCounterOfferRequested({
    required this.conversationId,
    required this.amountCop,
    required this.estimatedDays,
    required this.note,
  });
  final String conversationId;
  final int amountCop;
  final int estimatedDays;
  final String note;
}

final class RespondCounterOfferRequested extends MessagingEvent {
  const RespondCounterOfferRequested({
    required this.conversationId,
    required this.messageId,
    required this.accepted,
  });
  final String conversationId;
  final String messageId;
  final bool accepted;
}

final class MarkNotificationAsRead extends MessagingEvent {
  const MarkNotificationAsRead(this.notificationId);
  final String notificationId;
}

enum MessagingStatus { initial, loading, success, failure }

class MessagingState {
  const MessagingState({
    this.status = MessagingStatus.initial,
    this.conversations = const [],
    this.notifications = const [],
    this.errorMessage,
  });

  final MessagingStatus status;
  final List<ChatConversation> conversations;
  final List<ClientNotificationItem> notifications;
  final String? errorMessage;

  bool get isLoading => status == MessagingStatus.loading;
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  ChatConversation? conversationById(String id) {
    for (final c in conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  MessagingState copyWith({
    MessagingStatus? status,
    List<ChatConversation>? conversations,
    List<ClientNotificationItem>? notifications,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MessagingState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      notifications: notifications ?? this.notifications,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc(
    this._getConversationsUseCase,
    this._sendChatMessageUseCase,
    this._sendCounterOfferUseCase,
    this._respondCounterOfferUseCase,
    this._getClientNotificationsUseCase,
    this._markNotificationReadUseCase,
  ) : super(const MessagingState()) {
    on<LoadMessagingData>(_onLoad);
    on<SendChatMessageRequested>(_onSendMessage);
    on<SendCounterOfferRequested>(_onSendCounterOffer);
    on<RespondCounterOfferRequested>(_onRespondCounterOffer);
    on<MarkNotificationAsRead>(_onMarkNotificationRead);
  }

  final GetConversationsUseCase _getConversationsUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final SendCounterOfferUseCase _sendCounterOfferUseCase;
  final RespondCounterOfferUseCase _respondCounterOfferUseCase;
  final GetClientNotificationsUseCase _getClientNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;

  Future<void> _onLoad(
    LoadMessagingData event,
    Emitter<MessagingState> emit,
  ) async {
    emit(state.copyWith(status: MessagingStatus.loading, clearError: true));
    try {
      final convs = await _getConversationsUseCase();
      final notifs = await _getClientNotificationsUseCase();
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: convs,
          notifications: notifs,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onSendMessage(
    SendChatMessageRequested event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final updated = await _sendChatMessageUseCase(
        conversationId: event.conversationId,
        text: event.text,
      );
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: _replaceConv(state.conversations, updated),
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onSendCounterOffer(
    SendCounterOfferRequested event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final updated = await _sendCounterOfferUseCase(
        conversationId: event.conversationId,
        amountCop: event.amountCop,
        estimatedDays: event.estimatedDays,
        note: event.note,
      );
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: _replaceConv(state.conversations, updated),
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onRespondCounterOffer(
    RespondCounterOfferRequested event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final updated = await _respondCounterOfferUseCase(
        conversationId: event.conversationId,
        messageId: event.messageId,
        accepted: event.accepted,
      );
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: _replaceConv(state.conversations, updated),
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  Future<void> _onMarkNotificationRead(
    MarkNotificationAsRead event,
    Emitter<MessagingState> emit,
  ) async {
    try {
      final updated = await _markNotificationReadUseCase(event.notificationId);
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          notifications: updated,
          clearError: true,
        ),
      );
    } catch (e) {
      final clean = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(
          status: MessagingStatus.failure,
          errorMessage: clean,
        ),
      );
    }
  }

  List<ChatConversation> _replaceConv(
    List<ChatConversation> current,
    ChatConversation updated,
  ) {
    final exists = current.any((c) => c.id == updated.id);
    if (!exists) return [updated, ...current];
    return [for (final c in current) c.id == updated.id ? updated : c];
  }
}
