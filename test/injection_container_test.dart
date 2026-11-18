import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/features/agreements/agreements_module.dart';
import 'package:rivet/features/auth/domain/repositories/auth_repository.dart';
import 'package:rivet/features/auth/domain/usecases/usecases.dart';
import 'package:rivet/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:rivet/features/contractors/contractors_module.dart';
import 'package:rivet/features/home/contractor_home_bloc.dart';
import 'package:rivet/features/messaging/messaging_module.dart';
import 'package:rivet/features/projects/contractor/open_projects_bloc.dart';
import 'package:rivet/features/projects/domain/repositories/project_repository.dart';
import 'package:rivet/features/projects/presentation/bloc/projects_bloc.dart';
import 'package:rivet/features/projects/wizard/domain/project_draft_repository.dart';
import 'package:rivet/features/proposals/domain/repositories/proposal_repository.dart';
import 'package:rivet/features/proposals/domain/usecases/accept_proposal_usecase.dart';
import 'package:rivet/features/proposals/presentation/bloc/proposals_bloc.dart';
import 'package:rivet/features/supplier/domain/repositories/catalog_repository.dart';
import 'package:rivet/features/supplier/domain/usecases/get_catalog_materials_usecase.dart';
import 'package:rivet/features/supplier/presentation/bloc/catalog_bloc.dart';
import 'package:rivet/injection_container.dart';

void main() {
  tearDown(() async {
    await sl.reset();
  });

  test(
    'initDependencies registra singletons de repositorios/casos de uso y factories de BLoCs',
    () async {
      await initDependencies(reset: true);

      expect(
        identical(sl<AuthRepository>(), sl<AuthRepository>()),
        isTrue,
      );
      expect(
        identical(sl<ProjectRepository>(), sl<ProjectRepository>()),
        isTrue,
      );
      expect(
        identical(sl<ProposalRepository>(), sl<ProposalRepository>()),
        isTrue,
      );
      expect(
        identical(sl<CatalogRepository>(), sl<CatalogRepository>()),
        isTrue,
      );
      expect(
        identical(sl<ContractorRepository>(), sl<ContractorRepository>()),
        isTrue,
      );
      expect(
        identical(sl<AgreementRepository>(), sl<AgreementRepository>()),
        isTrue,
      );
      expect(
        identical(sl<MessagingRepository>(), sl<MessagingRepository>()),
        isTrue,
      );
      expect(
        identical(sl<ProjectDraftRepository>(), sl<ProjectDraftRepository>()),
        isTrue,
      );

      expect(
        identical(sl<GetCurrentUserUseCase>(), sl<GetCurrentUserUseCase>()),
        isTrue,
      );
      expect(
        identical(sl<LoadOlderMessagesUseCase>(), sl<LoadOlderMessagesUseCase>()),
        isTrue,
      );
      expect(
        identical(sl<AcceptProposalUseCase>(), sl<AcceptProposalUseCase>()),
        isTrue,
      );
      expect(
        identical(
          sl<GetCatalogMaterialsUseCase>(),
          sl<GetCatalogMaterialsUseCase>(),
        ),
        isTrue,
      );

      final authBloc1 = sl<AuthBloc>();
      final authBloc2 = sl<AuthBloc>();
      final projectsBloc1 = sl<ProjectsBloc>();
      final projectsBloc2 = sl<ProjectsBloc>();
      final proposalsBloc = sl<ProposalsBloc>();
      final catalogBloc = sl<CatalogBloc>();
      final contractorsBloc = sl<ContractorsBloc>();
      final agreementsBloc = sl<AgreementsBloc>();
      final progressBloc = sl<ProgressBloc>();
      final closureBloc = sl<ClosureBloc>();
      final payoutBloc = sl<PayoutAccountBloc>();
      final openProjectsBloc = sl<OpenProjectsBloc>();
      final contractorHomeBloc = sl<ContractorHomeBloc>();
      final messagingBloc = sl<MessagingBloc>();
      final resolvedCatalog = resolveBloc<CatalogBloc>(
        () => throw StateError('No debe usar fallback cuando sl está listo'),
      );

      expect(identical(authBloc1, authBloc2), isFalse);
      expect(identical(projectsBloc1, projectsBloc2), isFalse);
      expect(resolvedCatalog, isA<CatalogBloc>());

      await authBloc1.close();
      await authBloc2.close();
      await projectsBloc1.close();
      await projectsBloc2.close();
      await proposalsBloc.close();
      await catalogBloc.close();
      await contractorsBloc.close();
      await agreementsBloc.close();
      await progressBloc.close();
      await closureBloc.close();
      await payoutBloc.close();
      await openProjectsBloc.close();
      await contractorHomeBloc.close();
      await messagingBloc.close();
      await resolvedCatalog.close();
    },
  );

  test('ningún archivo de domain/ importa archivos de data/', () {
    final featuresDir = Directory('lib/features');
    final violations = <String>[];
    for (final entity in featuresDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final normalized = entity.path.replaceAll('\\', '/');
      if (!normalized.contains('/domain/')) continue;
      final content = entity.readAsStringSync();
      for (final line in content.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.startsWith('import ') && trimmed.contains('data/')) {
          violations.add('$normalized: $trimmed');
        }
      }
    }
    expect(violations, isEmpty);
  });
}
