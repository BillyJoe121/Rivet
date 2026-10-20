import 'package:flutter/material.dart';

import '../finance/payout_account_screen.dart';
import '../home/widgets/kit/kit.dart';
import 'contractor_account_mock.dart';
import 'widgets/account_action_buttons.dart';
import 'widgets/account_profile_widgets.dart';

/// Edición del perfil profesional (Figma 22:146001).
class EditProfessionalProfileScreen extends StatefulWidget {
  const EditProfessionalProfileScreen({super.key});

  @override
  State<EditProfessionalProfileScreen> createState() => _EditProfessionalProfileScreenState();
}

class _EditProfessionalProfileScreenState extends State<EditProfessionalProfileScreen> {
  // Interruptores de visibilidad: teléfono, correo y ciudad.
  final _visible = [true, true, true];

  @override
  Widget build(BuildContext context) {
    return ProScreen(
      backgroundAsset: ProAssets.headerBotanical,
      bottomNav: const ProBottomNav(active: ProNavDestination.home),
      footer: _Footer(
        onPayout: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PayoutAccountScreen()),
        ),
        onSave: () => Navigator.maybePop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProBackHeader(
            title: 'Perfil profesional',
            lucideChevron: true,
            height: 132,
            titleWidth: 364,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 2,
              children: [
                const _SummaryCard(),
                const ProSectionHeader('Servicios', linkLabel: 'Editar'),
                const SizedBox(height: 56, child: _ServicesRow()),
                const ProSectionHeader('Zonas de trabajo', linkLabel: 'Editar'),
                const SizedBox(height: 23, child: _ZoneChips()),
                const ProSectionHeader('Disponibilidad', linkLabel: 'Editar'),
                const SizedBox(height: 38, child: _AvailabilityRow()),
                const ProSectionHeader('Datos visibles en tu perfil', linkLabel: 'Editar'),
                _VisibilityCard(values: _visible, onChanged: (i, v) => setState(() => _visible[i] = v)),
                const ProSectionHeader('Sobre mí', linkLabel: 'Editar'),
                Text(ContractorAccountMock.bio, style: ProText.r(12, color: ProColors.ink700, lineHeight: 14.4)),
                const ProSectionHeader('Portafolio de proyectos', linkLabel: 'Ver todos'),
                const SizedBox(height: 36, child: _GalleryStrip()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return ProCard(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        children: [
          const ProImage(ProAssets.avatarCarlos, width: 60, height: 60, radius: 30),
          const SizedBox(width: 12),
          const Expanded(
            child: ProfileSummaryText(
              name: ContractorAccountMock.name,
              trade: ContractorAccountMock.trade,
              zone: ContractorAccountMock.zone,
              rating: ContractorAccountMock.rating,
            ),
          ),
          const SizedBox(width: 12),
          const ProIcon(LucideIcon.chevronRight, size: 14),
        ],
      ),
    );
  }
}

class _ServicesRow extends StatelessWidget {
  const _ServicesRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        for (final s in ContractorAccountMock.services)
          Expanded(
            child: ProfileServiceTile(
              icon: s.icon,
              title: s.title,
              scope: s.scope,
              height: 56,
              iconSize: 22,
              gap: 1,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              titleSize: 11,
              scopeSize: 10,
            ),
          ),
      ],
    );
  }
}

class _ZoneChips extends StatelessWidget {
  const _ZoneChips();

  @override
  Widget build(BuildContext context) {
    final style = ProText.r(11, color: ProColors.brand700, lineHeight: 13.2);
    return Row(
      spacing: 8,
      children: [
        for (final zone in ContractorAccountMock.zones)
          ProChip(
            zone,
            background: ProColors.successLight,
            foreground: ProColors.brand700,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            textStyle: style,
          ),
        ProChip(
          '+ Añadir',
          background: ProColors.successLight,
          foreground: ProColors.brand700,
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          textStyle: style,
        ),
      ],
    );
  }
}

class _AvailabilityRow extends StatelessWidget {
  const _AvailabilityRow();

  @override
  Widget build(BuildContext context) {
    return ProOptionRow(
      icon: LucideIcon.clock,
      title: ContractorAccountMock.availability,
      titleStyle: ProText.r(12, weight: FontWeight.w600, color: ProColors.ink900, lineHeight: 15.6),
    );
  }
}

/// Tarjeta con los tres datos de contacto y su interruptor de visibilidad.
class _VisibilityCard extends StatelessWidget {
  const _VisibilityCard({required this.values, required this.onChanged});

  final List<bool> values;
  final void Function(int index, bool value) onChanged;

  static const _rows = [
    (LucideIcon.phone, 'Número de contacto', ContractorAccountMock.phone),
    (LucideIcon.mail, 'Correo electrónico', ContractorAccountMock.email),
    (LucideIcon.mapPin, 'Ciudad / zona', ContractorAccountMock.city),
  ];

  @override
  Widget build(BuildContext context) {
    return ProCard(
      radius: ProRadii.lg,
      borderWidth: ProStroke.card,
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          for (var i = 0; i < _rows.length; i++)
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: ProColors.line300, width: ProStroke.hairline)),
              ),
              child: Row(
                children: [
                  ProIcon(_rows[i].$1, size: 23),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: _rows[i].$2, style: ProText.r(12, lineHeight: 15.6)),
                        TextSpan(
                          text: '\n${_rows[i].$3}',
                          style: ProText.r(11, color: ProColors.ink500, lineHeight: 13.2),
                        ),
                      ]),
                    ),
                  ),
                  ProToggle(value: values[i], onChanged: (v) => onChanged(i, v)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _GalleryStrip extends StatelessWidget {
  const _GalleryStrip();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        for (final g in ContractorAccountMock.gallery)
          Expanded(child: ProImage(g.image, width: double.infinity, height: 36, radius: ProRadii.sm)),
      ],
    );
  }
}

/// Pie: "Cuenta de pago" (blanco con borde) y "Guardar perfil" (degradado).
class _Footer extends StatelessWidget {
  const _Footer({required this.onPayout, required this.onSave});

  final VoidCallback onPayout;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 11, 22, 6),
      child: Row(
        children: [
          GestureDetector(
            onTap: onPayout,
            child: Container(
              width: 132,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: ProColors.surface0,
                borderRadius: BorderRadius.circular(ProRadii.button),
                border: Border.all(color: ProColors.line300, width: ProStroke.card),
              ),
              child: Row(
                children: [
                  const ProIcon(LucideIcon.wallet, size: 18, strokeWidth: 2),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Cuenta de pago', style: ProText.r(12, weight: FontWeight.w600, lineHeight: 14.4)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: AccountGradientButton('Guardar perfil', onTap: onSave)),
        ],
      ),
    );
  }
}
