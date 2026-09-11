import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/calculator_catalog.dart';

class CalculatorCategoryTabs extends StatelessWidget {
  final CalculatorCategory selectedCategory;
  final ValueChanged<CalculatorCategory> onChanged;

  const CalculatorCategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      (CalculatorCategory.all, 'All'),
      (CalculatorCategory.investment, 'Investment'),
      (CalculatorCategory.loans, 'Loans'),
      (CalculatorCategory.savings, 'Savings'),
      (CalculatorCategory.tax, 'Tax'),
      (CalculatorCategory.tools, 'Tools'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((item) {
          final selected = selectedCategory == item.$1;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: ChoiceChip(
              label: Text(item.$2),
              selected: selected,
              onSelected: (_) {
                onChanged(item.$1);
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
              labelStyle: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
