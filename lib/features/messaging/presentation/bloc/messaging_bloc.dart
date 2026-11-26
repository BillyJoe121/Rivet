import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/messaging_domain.dart';

part 'messaging_event_state.dart';

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  MessagingBloc(
    this._getConversationsUseCase,
    this._sendChatMessageUseCase,
    this._sendCounterOfferUseCase,
    this._respondCounterOfferUseCase,
    this._getClientNotificationsUseCase,
    this._markNotificationReadUseCase, [
    this._repository,
    LoadOlderMessagesUseCase? loadOlderMessagesUseCase,
    EnsureConversationUseCase? ensureConversationUseCase,
  ]) : _loadOlderMessagesUseCase =
           loadOlderMessagesUseCase ??
           (_repository != null ? LoadOlderMessagesUseCase(_repository) : null),
       _ensureConversationUseCase =
           ensureConversationUseCase ??
           (_repository != null ? EnsureConversationUseCase(_repository) : null),
       super(const MessagingState()) {
    on<LoadMessagingData>(_onLoad);
    on<OpenProjectConversationRequested>(_onOpenProjectConversation);
    on<SubscribeConversationRealtime>(_onSubscribeConversation);
    on<SubscribeNotificationsRealtime>(_onSubscribeNotifications);
    on<_RealtimeMessageArrived>(_onRealtimeMessage);
    on<_RealtimeNotificationArrived>(_onRealtimeNotification);
    on<SendChatMessageRequested>(_onSendMessage);
    on<SendCounterOfferRequested>(_onSendCounterOffer);
    on<RespondCounterOfferRequested>(_onRespondCounterOffer);
    on<MarkNotificationAsRead>(_onMarkNotificationRead);
    on<LoadOlderMessagesRequested>(_onLoadOlderMessages);
  }

  factory MessagingBloc.fromRepository(MessagingRepository repository) {
    return MessagingBloc(
      GetConversationsUseCase(repository),
      SendChatMessageUseCase(repository),
      SendCounterOfferUseCase(repository),
      RespondCounterOfferUseCase(repository),
      GetClientNotificationsUseCase(repository),
      MarkNotificationReadUseCase(repository),
      repository,
      LoadOlderMessagesUseCase(repository),
      EnsureConversationUseCase(repository),
    );
  }

  final GetConversationsUseCase _getConversationsUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final SendCounterOfferUseCase _sendCounterOfferUseCase;
  final RespondCounterOfferUseCase _respondCounterOfferUseCase;
  final GetClientNotificationsUseCase _getClientNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final MessagingRepository? _repository;
  final LoadOlderMessagesUseCase? _loadOlderMessagesUseCase;
  final EnsureConversationUseCase? _ensureConversationUseCase;

  StreamSubscription<ChatMessage>? _messagesSub;
  StreamSubscription<ClientNotificationItem>? _notificationsSub;

  MessagingState _failureState(Object error) {
    if (error is MessagingFailure) {
      return state.copyWith(
        status: MessagingStatus.failure,
        errorMessage: error.message,
        isSessionExpired: error.isSessionExpired,
        isPermissionDenied: error.isPermissionDenied,
      );
    }
    return state.copyWith(
      status: MessagingStatus.failure,
      errorMessage: error.toString().replaceFirst('Exception: ', ''),
    );
  }

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
      emit(_failureState(e));
    }
  }

  Future<void> _onOpenProjectConversation(
    OpenProjectConversationRequested event,
    Emitter<MessagingState> emit,
  ) async {
    final useCase = _ensureConversationUseCase;
    if (useCase == null) return;
    emit(state.copyWith(status: MessagingStatus.loading, clearError: true));
    try {
      final conv = await useCase(
        projectId: event.projectId,
        contractorId: event.contractorId,
      );
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: _replaceConv(state.conversations, conv),
          activeConversationId: conv.id,
          clearError: true,
        ),
      );
      if (!isClosed) {
        add(SubscribeConversationRealtime(conv.id));
      }
    } catch (e) {
      emit(_failureState(e));
    }
  }

  Future<void> _onSubscribeConversation(
    SubscribeConversationRealtime event,
    Emitter<MessagingState> emit,
  ) async {
    await _messagesSub?.cancel();
    final repo = _repository;
    if (repo == null) return;
    _messagesSub = repo.watchMessages(event.conversationId).listen((msg) {
      if (!isClosed) {
        add(_RealtimeMessageArrived(
          conversationId: event.conversationId,
          message: msg,
        ));
      }
    });
  }

  Future<void> _onSubscribeNotifications(
    SubscribeNotificationsRealtime event,
    Emitter<MessagingState> emit,
  ) async {
    await _notificationsSub?.cancel();
    final repo = _repository;
    if (repo == null) return;
    _notificationsSub = repo.watchNotifications().listen((notif) {
      if (!isClosed) {
        add(_RealtimeNotificationArrived(notif));
      }
    });
  }

  void _onRealtimeMessage(
    _RealtimeMessageArrived event,
    Emitter<MessagingState> emit,
  ) {
    final conv = state.conversationById(event.conversationId);
    if (conv == null) return;
    if (conv.messages.any((m) => m.id == event.message.id)) return;
    final updated = conv.copyWith(
      messages: [...conv.messages, event.message],
    );
    emit(
      state.copyWith(
        status: MessagingStatus.success,
        conversations: _replaceConv(state.conversations, updated),
      ),
    );
  }

  void _onRealtimeNotification(
    _RealtimeNotificationArrived event,
    Emitter<MessagingState> emit,
  ) {
    if (state.notifications.any((n) => n.id == event.notification.id)) return;
    emit(
      state.copyWith(
        status: MessagingStatus.success,
        notifications: [event.notification, ...state.notifications],
      ),
    );
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
          activeConversationId: updated.id,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(_failureState(e));
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
      emit(_failureState(e));
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
      emit(_failureState(e));
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
      emit(_failureState(e));
    }
  }

  Future<void> _onLoadOlderMessages(
    LoadOlderMessagesRequested event,
    Emitter<MessagingState> emit,
  ) async {
    final useCase = _loadOlderMessagesUseCase;
    if (useCase == null || state.isLoadingOlder) return;
    final conv = state.conversationById(event.conversationId);
    if (conv == null || conv.messages.isEmpty) return;

    emit(state.copyWith(isLoadingOlder: true, clearError: true));
    try {
      final oldest = conv.messages.first.sentAt;
      final older = await useCase(
        conversationId: event.conversationId,
        before: oldest,
        limit: event.limit,
      );
      final merged = _mergeMessages(older, conv.messages);
      final updated = conv.copyWith(messages: merged);
      final nextHasMore = Map<String, bool>.from(state.hasMoreByConversation)
        ..[event.conversationId] = older.length >= event.limit;
      emit(
        state.copyWith(
          status: MessagingStatus.success,
          conversations: _replaceConv(state.conversations, updated),
          isLoadingOlder: false,
          hasMoreByConversation: nextHasMore,
        ),
      );
    } catch (e) {
      emit(_failureState(e).copyWith(isLoadingOlder: false));
    }
  }

  List<ChatMessage> _mergeMessages(
    List<ChatMessage> older,
    List<ChatMessage> current,
  ) {
    final byId = <String, ChatMessage>{
      for (final m in older) m.id: m,
      for (final m in current) m.id: m,
    };
    final result = byId.values.toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
    return result;
  }

  List<ChatConversation> _replaceConv(
    List<ChatConversation> current,
    ChatConversation updated,
  ) {
    final exists = current.any((c) => c.id == updated.id);
    if (!exists) return [updated, ...current];
    return [
      for (final c in current)
        if (c.id == updated.id)
          updated.copyWith(messages: _mergeMessages(c.messages, updated.messages))
        else
          c,
    ];
  }

  @override
  Future<void> close() async {
    await _messagesSub?.cancel();
    await _notificationsSub?.cancel();
    return super.close();
  }
}
