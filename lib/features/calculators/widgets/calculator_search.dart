
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class CalculatorSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const CalculatorSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search calculators...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textSecondary,
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
          onPressed: controller.clear,
          icon: const Icon(
            Icons.close_rounded,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
      ),
    );
  }
}