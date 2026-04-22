import 'package:crypto_app/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/enums/app_theme_type.dart';

class ThemeModeChips extends ConsumerWidget {
  const ThemeModeChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final notifier = ref.read(themeProvider.notifier);

    final colors = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 10,
      children: AppThemeType.values.map((type) {
        final isSelected = theme == type;

        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(type.icon, size: 16),
              const SizedBox(width: 6),
              Text(type.label),
            ],
          ),
          selected: isSelected,
          onSelected: (_) => notifier.setTheme(type),

          selectedColor: colors.primary,
          backgroundColor: colors.surfaceVariant,

          labelStyle: TextStyle(
            color: isSelected ? colors.onPrimary : colors.onSurface,
          ),

          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }).toList(),
    );
  }
}
