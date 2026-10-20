import 'package:flutter/material.dart';

import '../home/widgets/kit/kit.dart';
import 'widgets/account_action_buttons.dart';
import 'widgets/account_closure_widgets.dart';

/// Cierre del trabajo y calificación al contratista (Figma 22:145526).
class JobClosureScreen extends StatefulWidget {
  const JobClosureScreen({super.key});

  @override
  State<JobClosureScreen> createState() => _JobClosureScreenState();
}

class _JobClosureScreenState extends State<JobClosureScreen> {
  static const int _maxReview = 500;

  int _rating = 4;
  final _review = TextEditingController();

  @override
  void dispose() {
    _review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerLivingRoom,
      bottomNav: const ProBottomNav(active: ProNavDestination.projects),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Cierre y calificación',
            lucideChevron: true,
            height: 120,
            padding: EdgeInsets.fromLTRB(24, 10, 24, 8),
            gap: 6,
            titleWidth: 216,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 6,
              children: [
                const AccountClosureProject(),
                const ProSectionHeader('Confirmación de finalización'),
                const AccountClosureConfirmations(),
                const ProSectionHeader('Califica al contratista'),
                Text(
                  'Tu opinión ayuda a otros usuarios.',
                  style: ProText.r(12, color: ProColors.ink700, lineHeight: 14.4),
                ),
                _RatingCard(
                  rating: _rating,
                  controller: _review,
                  maxLength: _maxReview,
                  onRate: (value) => setState(() => _rating = value),
                ),
                const AccountClosureNotice(),
                AccountGradientButton('Confirmar cierre', onTap: () => Navigator.maybePop(context)),
                const AccountOutlineButton('Reportar problema'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta con estrellas tocables y el campo de reseña con su contador.
class _RatingCard extends StatelessWidget {
  const _RatingCard({
    required this.rating,
    required this.controller,
    required this.maxLength,
    required this.onRate,
  });

  final int rating;
  final TextEditingController controller;
  final int maxLength;
  final ValueChanged<int> onRate;

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: 146,
      radius: ProRadii.lg,
      borderWidth: 0.6,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 9,
        children: [
          AccountStarRating(value: rating, onChanged: onRate),
          ProCard(
            height: 74,
            radius: ProRadii.lg,
            borderWidth: 0.6,
            padding: const EdgeInsets.all(12),
            child: AccountReviewField(controller: controller, maxLength: maxLength),
          ),
        ],
      ),
    );
  }
}
