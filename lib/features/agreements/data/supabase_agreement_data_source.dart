import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/models.dart';
import '../domain/agreements_domain.dart';

/// Fuente de datos de acuerdos, pagos simulados y cuentas de cobro en Supabase.
class SupabaseAgreementDataSource {
  SupabaseAgreementDataSource(this._client);

  final SupabaseClient? _client;

  static const _defaultMilestones = [
    'Hito 1 · Alistamiento, protección de pisos y resanes de superficies',
    'Hito 2 · Aplicación de estuco plástico y lijado uniforme',
    'Hito 3 · Dos manos de pintura, revisión conjunta y entrega limpia',
  ];

  SupabaseClient _requireSession() {
    final client = _client;
    if (client == null) {
      throw const AgreementFailure(
        'No hay conexión configurada con el servidor. Intenta más tarde.',
      );
    }
    if (client.auth.currentUser == null) {
      throw const AgreementFailure(
        'Tu sesión venció. Inicia sesión nuevamente para continuar.',
        isSessionExpired: true,
      );
    }
    return client;
  }

  Future<T> _guard<T>(String fallback, Future<T> Function() run) async {
    try {
      return await run();
    } on AgreementFailure {
      rethrow;
    } on AuthException {
      throw const AgreementFailure(
        'Tu sesión venció. Inicia sesión nuevamente para continuar.',
        isSessionExpired: true,
      );
    } on PostgrestException catch (e) {
      if (e.code == '42501') {
        throw const AgreementFailure(
          'No tienes permisos para realizar esta acción sobre el acuerdo.',
          isPermissionDenied: true,
        );
      }
      if (e.code == '23505') {
        throw const AgreementFailure(
          'Ya existe un registro activo para esta operación.',
        );
      }
      throw AgreementFailure(e.message.isNotEmpty ? e.message : fallback);
    } catch (_) {
      throw AgreementFailure(fallback);
    }
  }

  Future<WorkAgreement> prepareAgreement({
    required String projectId,
    required String projectTitle,
    required Proposal proposal,
  }) {
    return _guard('No pudimos preparar el acuerdo del proyecto.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;

      final existing = await client
          .from('agreements')
          .select()
          .eq('proposal_id', proposal.id)
          .maybeSingle();

      if (existing != null) {
        return _hydrateAgreement(client, existing, projectTitle: projectTitle);
      }

      final projectRow = await client
          .from('projects')
          .select('id, title, client_id')
          .eq('id', projectId)
          .maybeSingle();
      if (projectRow == null) {
        throw const AgreementFailure('No encontramos el proyecto asociado.');
      }

      final clientId = projectRow['client_id'] as String? ?? userId;
      final total = proposal.laborCostCop + proposal.materialsCostCop;

      final inserted = await client
          .from('agreements')
          .insert({
            'project_id': projectId,
            'proposal_id': proposal.id,
            'client_id': clientId,
            'contractor_id': proposal.contractor.id,
            'labor_amount': proposal.laborCostCop,
            'materials_amount': proposal.materialsCostCop,
            'total_amount': total,
            'status': 'pending',
          })
          .select()
          .single();

      final agreementId = inserted['id'] as String;
      await client.from('agreement_milestones').insert([
        for (var i = 0; i < _defaultMilestones.length; i++)
          {
            'agreement_id': agreementId,
            'position': i,
            'title': _defaultMilestones[i],
          },
      ]);

      return _hydrateAgreement(
        client,
        inserted,
        projectTitle: projectRow['title'] as String? ?? projectTitle,
        estimatedDays: proposal.estimatedDays,
        contractorName: proposal.contractor.name,
      );
    });
  }

  Future<WorkAgreement> getAgreementById(String agreementId) {
    return _guard('No pudimos cargar el acuerdo.', () async {
      final client = _requireSession();
      final row = await client
          .from('agreements')
          .select()
          .eq('id', agreementId)
          .maybeSingle();
      if (row == null) {
        throw const AgreementFailure('No encontramos el acuerdo solicitado.');
      }
      return _hydrateAgreement(client, row);
    });
  }

  Future<WorkAgreement?> getAgreementForProject(String projectId) {
    return _guard('No pudimos consultar el acuerdo del proyecto.', () async {
      final client = _requireSession();
      final row = await client
          .from('agreements')
          .select()
          .eq('project_id', projectId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (row == null) return null;
      return _hydrateAgreement(client, row);
    });
  }

  Future<List<WorkAgreement>> getMyAgreements() {
    return _guard('No pudimos cargar tus acuerdos.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final rows = await client
          .from('agreements')
          .select()
          .or('client_id.eq.$userId,contractor_id.eq.$userId')
          .order('created_at', ascending: false);

      final result = <WorkAgreement>[];
      for (final row in rows) {
        result.add(await _hydrateAgreement(client, row));
      }
      return result;
    });
  }

  Future<WorkAgreement> acceptAgreement({
    required String agreementId,
    required bool asClient,
  }) {
    return _guard('No pudimos registrar tu aceptación del acuerdo.', () async {
      final client = _requireSession();
      final current = await client
          .from('agreements')
          .select()
          .eq('id', agreementId)
          .single();

      final nowIso = DateTime.now().toUtc().toIso8601String();
      final otherAccepted = asClient
          ? current['contractor_accepted_at'] != null
          : current['client_accepted_at'] != null;

      final update = <String, dynamic>{
        if (asClient) 'client_accepted_at': nowIso,
        if (!asClient) 'contractor_accepted_at': nowIso,
        if (otherAccepted) 'status': 'active',
      };

      final updated = await client
          .from('agreements')
          .update(update)
          .eq('id', agreementId)
          .select()
          .single();

      return _hydrateAgreement(client, updated);
    });
  }

  Future<WorkAgreement> processSimulatedPayment({
    required WorkAgreement agreement,
    String? cardBrand,
    String? cardLast4,
    bool simulateFailure = false,
  }) {
    return _guard('No pudimos registrar el pago simulado.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final status = simulateFailure ? 'rejected' : 'held';

      final inserted = await client
          .from('payments')
          .insert({
            'agreement_id': agreement.id,
            'payer_id': userId,
            'kind': 'advance',
            'amount': agreement.advanceAmountCop,
            'status': status,
            if (cardBrand != null && cardBrand.isNotEmpty) 'card_brand': cardBrand,
            if (cardLast4 != null && cardLast4.isNotEmpty) 'card_last4': cardLast4,
          })
          .select()
          .single();

      if (simulateFailure) {
        throw const AgreementFailure(
          'Pago simulado rechazado en la prueba. Puedes reintentar con otro método.',
        );
      }

      final paymentId = (inserted['id'] as String).substring(0, 8).toUpperCase();
      return agreement.copyWith(
        paymentStatus: SimulatedPaymentStatus.held,
        cardBrand: cardBrand,
        cardLast4: cardLast4,
        receiptCode: 'SIM-$paymentId',
      );
    });
  }

  Future<WorkAgreement> confirmWorkCompletion(WorkAgreement agreement) {
    return _guard('No pudimos confirmar la finalización del acuerdo.', () async {
      final client = _requireSession();
      final updated = await client
          .from('agreements')
          .update({'status': 'completed'})
          .eq('id', agreement.id)
          .select()
          .single();
      return _hydrateAgreement(client, updated);
    });
  }

  Future<PayoutAccount?> getPayoutAccount() {
    return _guard('No pudimos consultar tu cuenta de cobro.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final row = await client
          .from('payout_accounts')
          .select()
          .eq('contractor_id', userId)
          .maybeSingle();
      if (row == null) return null;
      return _payoutFromRow(row);
    });
  }

  Future<PayoutAccount> savePayoutAccount({
    required String bankName,
    required String accountType,
    required String accountNumberLast4,
    required String holderName,
    required String documentNumberLast4,
  }) {
    return _guard('No pudimos guardar tu cuenta de cobro.', () async {
      final client = _requireSession();
      final userId = client.auth.currentUser!.id;
      final row = await client
          .from('payout_accounts')
          .upsert(
            {
              'contractor_id': userId,
              'bank_name': bankName,
              'account_type': accountType,
              'account_number_last4': accountNumberLast4,
              'holder_name': holderName,
              'document_number_last4': documentNumberLast4,
            },
            onConflict: 'contractor_id',
          )
          .select()
          .single();
      return _payoutFromRow(row);
    });
  }

  Future<WorkAgreement> _hydrateAgreement(
    SupabaseClient client,
    Map<String, dynamic> row, {
    String? projectTitle,
    int? estimatedDays,
    String? contractorName,
  }) async {
    final agreementId = row['id'] as String;
    final projectId = row['project_id'] as String;
    final proposalId = row['proposal_id'] as String;
    final clientId = row['client_id'] as String;
    final contractorId = row['contractor_id'] as String;

    final milestonesRows = await client
        .from('agreement_milestones')
        .select()
        .eq('agreement_id', agreementId)
        .order('position', ascending: true);

    final paymentRow = await client
        .from('payments')
        .select()
        .eq('agreement_id', agreementId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    var resolvedTitle = projectTitle;
    if (resolvedTitle == null) {
      final proj = await client
          .from('projects')
          .select('title')
          .eq('id', projectId)
          .maybeSingle();
      resolvedTitle = proj?['title'] as String? ?? 'Proyecto Rivet';
    }

    var resolvedDays = estimatedDays;
    if (resolvedDays == null) {
      final prop = await client
          .from('proposals')
          .select('estimated_days')
          .eq('id', proposalId)
          .maybeSingle();
      resolvedDays = (prop?['estimated_days'] as num?)?.toInt() ?? 5;
    }

    var resolvedContractor = contractorName;
    String resolvedClient = '';
    final profiles = await client
        .from('public_profiles')
        .select('id, full_name')
        .inFilter('id', [clientId, contractorId]);
    for (final p in profiles) {
      if (p['id'] == contractorId && resolvedContractor == null) {
        resolvedContractor = p['full_name'] as String? ?? 'Contratista';
      }
      if (p['id'] == clientId) {
        resolvedClient = p['full_name'] as String? ?? 'Cliente';
      }
    }

    final items = [
      for (final m in milestonesRows)
        AgreementMilestone(
          id: m['id'] as String,
          agreementId: agreementId,
          position: (m['position'] as num).toInt(),
          title: m['title'] as String,
          isDone: m['status'] == 'done',
          clientConfirmedAt: _parseDate(m['client_confirmed_at']),
          contractorConfirmedAt: _parseDate(m['contractor_confirmed_at']),
        ),
    ];

    final clientAcceptedAt = _parseDate(row['client_accepted_at']);
    final contractorAcceptedAt = _parseDate(row['contractor_accepted_at']);
    final status = _parseStatus(row['status'] as String?);
    final paymentStatus = _parsePaymentStatus(paymentRow?['status'] as String?);
    final paymentId = paymentRow?['id'] as String?;

    return WorkAgreement(
      id: agreementId,
      projectId: projectId,
      projectTitle: resolvedTitle,
      proposalId: proposalId,
      clientId: clientId,
      contractorId: contractorId,
      contractorName: resolvedContractor ?? 'Contratista',
      clientName: resolvedClient,
      laborAmountCop: (row['labor_amount'] as num?)?.round() ?? 0,
      materialsAmountCop: (row['materials_amount'] as num?)?.round() ?? 0,
      estimatedDays: resolvedDays,
      milestones: [for (final item in items) item.title],
      milestoneItems: items,
      status: status,
      clientAcceptedAt: clientAcceptedAt,
      contractorAcceptedAt: contractorAcceptedAt,
      clientAcceptedTerms: clientAcceptedAt != null,
      contractorAcceptedTerms: contractorAcceptedAt != null,
      paymentStatus: paymentStatus,
      cardBrand: paymentRow?['card_brand'] as String?,
      cardLast4: paymentRow?['card_last4'] as String?,
      receiptCode: paymentId != null
          ? 'SIM-${paymentId.substring(0, 8).toUpperCase()}'
          : null,
      workCompletedConfirmed: status == AgreementStatus.completed,
    );
  }

  PayoutAccount _payoutFromRow(Map<String, dynamic> row) {
    return PayoutAccount(
      id: row['id'] as String,
      contractorId: row['contractor_id'] as String,
      bankName: row['bank_name'] as String,
      accountType: row['account_type'] as String,
      accountNumberLast4: row['account_number_last4'] as String,
      holderName: row['holder_name'] as String,
      documentNumberLast4: row['document_number_last4'] as String,
      verificationStatus: row['verification_status'] as String? ?? 'pending',
      createdAt: _parseDate(row['created_at']),
    );
  }

  DateTime? _parseDate(Object? value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  AgreementStatus _parseStatus(String? value) => switch (value) {
        'active' => AgreementStatus.active,
        'completed' => AgreementStatus.completed,
        'cancelled' => AgreementStatus.cancelled,
        _ => AgreementStatus.pending,
      };

  SimulatedPaymentStatus _parsePaymentStatus(String? value) => switch (value) {
        'approved' => SimulatedPaymentStatus.approved,
        'rejected' => SimulatedPaymentStatus.rejected,
        'held' => SimulatedPaymentStatus.held,
        'released' => SimulatedPaymentStatus.released,
        'refunded' => SimulatedPaymentStatus.refunded,
        _ => SimulatedPaymentStatus.pending,
      };
}
