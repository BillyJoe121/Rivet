import '../../../core/config/supabase_config.dart';
import '../domain/messaging_domain.dart';
import 'supabase_messaging_data_source.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  const MessagingRepositoryImpl(this._dataSource);

  final SupabaseMessagingDataSource _dataSource;

  @override
  Future<List<ChatConversation>> getConversations() =>
      _dataSource.getConversations();

  @override
  Future<ChatConversation> sendMessage({
    required String conversationId,
    required String text,
  }) =>
      _dataSource.sendMessage(conversationId: conversationId, text: text);

  @override
  Future<ChatConversation> sendCounterOffer({
    required String conversationId,
    required int amountCop,
    required int estimatedDays,
    required String note,
  }) =>
      _dataSource.sendCounterOffer(
        conversationId: conversationId,
        amountCop: amountCop,
        estimatedDays: estimatedDays,
        note: note,
      );

  @override
  Future<ChatConversation> respondCounterOffer({
    required String conversationId,
    required String messageId,
    required bool accepted,
  }) =>
      _dataSource.respondCounterOffer(
        conversationId: conversationId,
        messageId: messageId,
        accepted: accepted,
      );

  @override
  Future<List<ClientNotificationItem>> getNotifications() =>
      _dataSource.getNotifications();

  @override
  Future<List<ClientNotificationItem>> markNotificationRead(
    String notificationId,
  ) =>
      _dataSource.markNotificationRead(notificationId);

  @override
  Stream<ChatMessage> watchMessages(String conversationId) =>
      _dataSource.watchMessages(conversationId);

  @override
  Stream<ClientNotificationItem> watchNotifications() =>
      _dataSource.watchNotifications();

  @override
  Future<List<ChatMessage>> fetchMessagesBefore({
    required String conversationId,
    required DateTime before,
    int limit = 20,
  }) => _dataSource.fetchMessagesBefore(
    conversationId: conversationId,
    before: before,
    limit: limit,
  );
}

MessagingRepository createMessagingRepository() {
  try {
    return MessagingRepositoryImpl(
      SupabaseMessagingDataSource(SupabaseConfig.client),
    );
  } catch (_) {
    return MessagingRepositoryImpl(SupabaseMessagingDataSource(null));
  }
}
