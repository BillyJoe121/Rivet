part of 'messaging_bloc.dart';

sealed class MessagingEvent {
  const MessagingEvent();
}

final class LoadMessagingData extends MessagingEvent {
  const LoadMessagingData();
}

final class OpenProjectConversationRequested extends MessagingEvent {
  const OpenProjectConversationRequested({
    required this.projectId,
    required this.contractorId,
  });

  final String projectId;
  final String contractorId;
}

final class SubscribeConversationRealtime extends MessagingEvent {
  const SubscribeConversationRealtime(this.conversationId);
  final String conversationId;
}

final class SubscribeNotificationsRealtime extends MessagingEvent {
  const SubscribeNotificationsRealtime();
}

final class _RealtimeMessageArrived extends MessagingEvent {
  const _RealtimeMessageArrived({
    required this.conversationId,
    required this.message,
  });

  final String conversationId;
  final ChatMessage message;
}

final class _RealtimeNotificationArrived extends MessagingEvent {
  const _RealtimeNotificationArrived(this.notification);
  final ClientNotificationItem notification;
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

final class LoadOlderMessagesRequested extends MessagingEvent {
  const LoadOlderMessagesRequested(this.conversationId, {this.limit = 20});
  final String conversationId;
  final int limit;
}

enum MessagingStatus { initial, loading, success, failure }

class MessagingState {
  const MessagingState({
    this.status = MessagingStatus.initial,
    this.conversations = const [],
    this.notifications = const [],
    this.activeConversationId,
    this.errorMessage,
    this.isSessionExpired = false,
    this.isPermissionDenied = false,
    this.isLoadingOlder = false,
    this.hasMoreByConversation = const {},
  });

  final MessagingStatus status;
  final List<ChatConversation> conversations;
  final List<ClientNotificationItem> notifications;
  final String? activeConversationId;
  final String? errorMessage;
  final bool isSessionExpired;
  final bool isPermissionDenied;
  final bool isLoadingOlder;
  final Map<String, bool> hasMoreByConversation;

  bool get isLoading => status == MessagingStatus.loading;
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  bool hasMoreMessages(String conversationId) =>
      hasMoreByConversation[conversationId] ?? true;

  ChatConversation? conversationById(String id) {
    for (final c in conversations) {
      if (c.id == id) return c;
    }
    return null;
  }

  ChatConversation? conversationByParticipants({
    required String projectId,
    required String contractorId,
  }) {
    for (final c in conversations) {
      if (c.projectId == projectId && c.contractorId == contractorId) {
        return c;
      }
    }
    return null;
  }

  MessagingState copyWith({
    MessagingStatus? status,
    List<ChatConversation>? conversations,
    List<ClientNotificationItem>? notifications,
    String? activeConversationId,
    String? errorMessage,
    bool clearError = false,
    bool? isSessionExpired,
    bool? isPermissionDenied,
    bool? isLoadingOlder,
    Map<String, bool>? hasMoreByConversation,
  }) {
    return MessagingState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      notifications: notifications ?? this.notifications,
      activeConversationId: activeConversationId ?? this.activeConversationId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSessionExpired:
          clearError ? false : (isSessionExpired ?? this.isSessionExpired),
      isPermissionDenied:
          clearError ? false : (isPermissionDenied ?? this.isPermissionDenied),
      isLoadingOlder: isLoadingOlder ?? this.isLoadingOlder,
      hasMoreByConversation:
          hasMoreByConversation ?? this.hasMoreByConversation,
    );
  }
}
