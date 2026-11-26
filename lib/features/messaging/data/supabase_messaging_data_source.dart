import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/messaging_domain.dart';

/// Fuente de datos de mensajería y notificaciones en Supabase + Realtime.
class SupabaseMessagingDataSource {
  SupabaseMessagingDataSource(this._client);

  final SupabaseClient? _client;

  SupabaseClient _requireSession() {
    final client = _client;
    if (client == null) {
      throw const MessagingFailure(
        'No hay conexión configurada con el servidor. Intenta más tarde.',
      );
    }
    if (client.auth.currentUser == null) {
      throw const MessagingFailure(
        'Tu sesión venció. Inicia sesión nuevamente para continuar.',
        isSessionExpired: true,
      );
    }
    return client;
  }

  Future<T> _guard<T>(String fallback, Future<T> Function() run) async {
    try {
      return await run();
    } on MessagingFailure {
      rethrow;
    } on AuthException {
      throw const MessagingFailure(
        'Tu sesión venció. Inicia sesión nuevamente para continuar.',
        isSessionExpired: true,
      );
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        throw const MessagingFailure(
          'No tienes permisos para acceder a esta conversación o notificación.',
          isPermissionDenied: true,
        );
      }
      throw MessagingFailure(e.message.isNotEmpty ? e.message : fallback);
    } catch (_) {
      throw MessagingFailure(fallback);
    }
  }

  Future<List<ChatConversation>> getConversations() {
    return _guard('No pudimos cargar tus conversaciones.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final rows = await client
          .from('conversations')
          .select()
          .or('client_id.eq.$userId,contractor_id.eq.$userId')
          .order('last_message_at', ascending: false);

      final result = <ChatConversation>[];
      for (final row in rows) {
        result.add(await _hydrateConversation(client, row, userId));
      }
      return result;
    });
  }

  Future<ChatConversation> ensureConversation({
    required String projectId,
    required String contractorId,
  }) {
    return _guard('No pudimos iniciar la conversación del proyecto.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final projectRow = await client
          .from('projects')
          .select('client_id')
          .eq('id', projectId)
          .maybeSingle();
      if (projectRow == null) {
        throw const MessagingFailure(
          'No encontramos el proyecto para iniciar la conversación.',
        );
      }

      final projectClientId = projectRow['client_id'] as String;
      final resolvedContractorId =
          userId == projectClientId ? contractorId : userId;

      final existing = await client
          .from('conversations')
          .select()
          .eq('project_id', projectId)
          .eq('client_id', projectClientId)
          .eq('contractor_id', resolvedContractorId)
          .maybeSingle();
      if (existing != null) {
        return _hydrateConversation(client, existing, userId);
      }

      final inserted = await client
          .from('conversations')
          .insert({
            'project_id': projectId,
            'client_id': projectClientId,
            'contractor_id': resolvedContractorId,
            'last_message_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select()
          .single();
      return _hydrateConversation(client, inserted, userId);
    });
  }

  Future<ChatConversation> sendMessage({
    required String conversationId,
    required String text,
  }) {
    return _guard('No pudimos enviar tu mensaje.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      await client.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': userId,
        'body': text,
        'kind': 'text',
      });
      return _loadConversationById(client, conversationId, userId);
    });
  }

  Future<ChatConversation> sendCounterOffer({
    required String conversationId,
    required int amountCop,
    required int estimatedDays,
    required String note,
  }) {
    return _guard('No pudimos enviar la contraoferta.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final body = note.isEmpty
          ? 'Contraoferta: \$ $amountCop COP · $estimatedDays días.'
          : '$note (\$ $amountCop COP · $estimatedDays días)';
      await client.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': userId,
        'body': body,
        'kind': 'counter_offer',
        'counter_offer_amount': amountCop,
      });
      return _loadConversationById(client, conversationId, userId);
    });
  }

  Future<ChatConversation> respondCounterOffer({
    required String conversationId,
    required String messageId,
    required bool accepted,
  }) {
    return _guard('No pudimos responder la contraoferta.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      await client.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': userId,
        'body': accepted
            ? 'Contraoferta aceptada.'
            : 'Contraoferta rechazada.',
        'kind': 'text',
      });
      return _loadConversationById(client, conversationId, userId);
    });
  }

  Future<List<ClientNotificationItem>> getNotifications() {
    return _guard('No pudimos cargar tus notificaciones.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final rows = await client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return [for (final r in rows) _notificationFromRow(r)];
    });
  }

  Future<List<ClientNotificationItem>> markNotificationRead(
    String notificationId,
  ) {
    return _guard('No pudimos marcar la notificación como leída.', () async {
      final client = _requireSession();
      await client
          .from('notifications')
          .update({'read_at': DateTime.now().toUtc().toIso8601String()})
          .eq('id', notificationId);
      return getNotifications();
    });
  }

  Stream<ChatMessage> watchMessages(String conversationId) {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      return const Stream.empty();
    }

    final controller = StreamController<ChatMessage>.broadcast();
    final channel = client.channel('messages:$conversationId');
    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            final row = payload.newRecord;
            if (row.isEmpty) return;
            controller.add(_messageFromRow(row, currentUserId: userId));
          },
        )
        .subscribe();

    controller.onCancel = () {
      client.removeChannel(channel);
      controller.close();
    };
    return controller.stream;
  }

  /// Carga mensajes anteriores a [before] en orden cronológico ascendente.
  Future<List<ChatMessage>> fetchMessagesBefore({
    required String conversationId,
    required DateTime before,
    int limit = 20,
  }) {
    return _guard('No pudimos cargar mensajes anteriores.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final conv = await client
          .from('conversations')
          .select('client_id, contractor_id')
          .eq('id', conversationId)
          .maybeSingle();
      final clientId = conv?['client_id'] as String?;
      final contractorId = conv?['contractor_id'] as String?;
      final otherId = clientId == userId ? contractorId : clientId;
      String otherName = 'Participante';
      if (otherId != null) {
        final otherProfile = await client
            .from('public_profiles')
            .select('full_name')
            .eq('id', otherId)
            .maybeSingle();
        otherName = otherProfile?['full_name'] as String? ?? 'Participante';
      }

      final rows = await client
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .lt('created_at', before.toUtc().toIso8601String())
          .order('created_at', ascending: false)
          .limit(limit);

      final messages = [
        for (final m in rows)
          _messageFromRow(
            m,
            currentUserId: userId,
            clientId: clientId,
            otherName: otherName,
          ),
      ];
      return messages.reversed.toList();
    });
  }

  Stream<ClientNotificationItem> watchNotifications() {
    final client = _client;
    final userId = client?.auth.currentUser?.id;
    if (client == null || userId == null) {
      return const Stream.empty();
    }

    final controller = StreamController<ClientNotificationItem>.broadcast();
    final channel = client.channel('notifications:$userId');
    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            final row = payload.newRecord;
            if (row.isEmpty) return;
            controller.add(_notificationFromRow(row));
          },
        )
        .subscribe();

    controller.onCancel = () {
      client.removeChannel(channel);
      controller.close();
    };
    return controller.stream;
  }

  Future<ChatConversation> _loadConversationById(
    SupabaseClient client,
    String conversationId,
    String userId,
  ) async {
    final row = await client
        .from('conversations')
        .select()
        .eq('id', conversationId)
        .single();
    return _hydrateConversation(client, row, userId);
  }

  Future<ChatConversation> _hydrateConversation(
    SupabaseClient client,
    Map<String, dynamic> row,
    String currentUserId,
  ) async {
    final conversationId = row['id'] as String;
    final projectId = row['project_id'] as String;
    final clientId = row['client_id'] as String;
    final contractorId = row['contractor_id'] as String;
    final otherId = currentUserId == clientId ? contractorId : clientId;

    final proj = await client
        .from('projects')
        .select('title')
        .eq('id', projectId)
        .maybeSingle();

    final otherProfile = await client
        .from('public_profiles')
        .select('full_name, role')
        .eq('id', otherId)
        .maybeSingle();

    final msgRows = (await client
            .from('messages')
            .select()
            .eq('conversation_id', conversationId)
            .order('created_at', ascending: false)
            .limit(20))
        .reversed
        .toList();

    final otherName = otherProfile?['full_name'] as String? ?? 'Participante';
    final otherRole = otherProfile?['role'] as String?;
    final specialty = otherRole == 'client'
        ? 'Propietario del proyecto'
        : 'Contratista Rivet';

    return ChatConversation(
      id: conversationId,
      projectId: projectId,
      projectTitle: proj?['title'] as String? ?? 'Proyecto Rivet',
      contractorId: otherId,
      contractorName: otherName,
      contractorSpecialty: specialty,
      unreadCount: msgRows
          .where((m) => m['sender_id'] != currentUserId && m['read_at'] == null)
          .length,
      messages: [
        for (final m in msgRows)
          _messageFromRow(
            m,
            currentUserId: currentUserId,
            clientId: clientId,
            otherName: otherName,
          ),
      ],
    );
  }

  ChatMessage _messageFromRow(
    Map<String, dynamic> row, {
    required String currentUserId,
    String? clientId,
    String otherName = 'Participante',
  }) {
    final senderId = row['sender_id'] as String? ?? '';
    final isMine = senderId == currentUserId;
    final fromClient = clientId != null ? senderId == clientId : isMine;
    final kind = row['kind'] as String? ?? 'text';
    final amount = (row['counter_offer_amount'] as num?)?.round();

    return ChatMessage(
      id: row['id'] as String,
      senderName: isMine ? 'Tú' : otherName,
      fromClient: fromClient,
      text: row['body'] as String? ?? '',
      sentAt: DateTime.tryParse(row['created_at'] as String? ?? '') ??
          DateTime.now(),
      isCounterOffer: kind == 'counter_offer',
      counterOfferAmountCop: amount,
    );
  }

  ClientNotificationItem _notificationFromRow(Map<String, dynamic> row) {
    final kind = row['kind'] as String? ?? '';
    final type = switch (kind) {
      'proposal_received' => ClientNotificationType.proposalReceived,
      'counter_offer' => ClientNotificationType.counterOfferUpdate,
      'visit_scheduled' => ClientNotificationType.visitScheduled,
      _ => ClientNotificationType.projectMilestone,
    };

    return ClientNotificationItem(
      id: row['id'] as String,
      title: row['title'] as String? ?? 'Actividad',
      body: row['body'] as String? ?? '',
      createdAt: DateTime.tryParse(row['created_at'] as String? ?? '') ??
          DateTime.now(),
      type: type,
      isRead: row['read_at'] != null,
      projectId: row['project_id'] as String?,
    );
  }
}
