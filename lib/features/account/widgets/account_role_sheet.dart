import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/design_system/design_system.dart';
import '../../../core/models/models.dart';

/// Hoja inferior para cambiar el rol activo y recorrer la app desde las
/// perspectivas de cliente o contratista. Se abre al tocar el avatar del perfil.
Future<void> showAccountRoleSheet(
  BuildContext context, {
  required UserRole currentRole,
  required ValueChanged<UserRole> onSwitchRole,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.paper100,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            Text(
              'Cambiar rol activo',
              style: AppTypography.serifTitleProportional,
            ),
            Text(
              'Permite probar y navegar la app como Cliente o Contratista.',
              style: AppTypography.captionProportional,
            ),
            const SizedBox(height: 4),
            for (final role in const [UserRole.client, UserRole.contractor])
              AppCard(
                isSelected: role == currentRole,
                padding: const EdgeInsets.all(10),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onSwitchRole(role);
                },
                child: AppListTile(
                  leadingIcon: switch (role) {
                    UserRole.client => LucideIcons.house,
                    UserRole.contractor => LucideIcons.paintRoller,
                    UserRole.supplier => LucideIcons.store,
                  },
                  title: role.label,
                  subtitle: role.description,
                  showDivider: false,
                  showChevron: false,
                  trailing: role == currentRole
                      ? const Icon(
                          LucideIcons.circleCheck,
                          size: 18,
                          color: AppColors.brand700,
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
