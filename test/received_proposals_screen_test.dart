import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rivet/core/data/mock_data.dart';
import 'package:rivet/features/proposals/received_proposals_screen.dart';

import 'helpers/repositories_test_harness.dart';

void main() {
  testWidgets('ReceivedProposalsScreen lista las propuestas por contratista', (tester) async {
    await tester.pumpWidget(
      withRepositories(const MaterialApp(home: ReceivedProposalsScreen())),
    );
    await tester.pump();

    expect(find.text('Propuestas\nrecibidas'), findsOneWidget);
    for (final proposal in MockData.proposals) {
      expect(find.text(proposal.contractor.name), findsWidgets);
    }
  });
}
