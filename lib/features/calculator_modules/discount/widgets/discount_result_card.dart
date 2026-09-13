import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../discount_model.dart';

class DiscountResultCard extends StatelessWidget {
  final DiscountResult result;

  const DiscountResultCard({super.key, required this.result});

  String _currency(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Calculation Result', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Final Price', style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Text(
                  _currency(result.finalPrice),
                  style: AppTextStyles.price.copyWith(
                    fontSize: 30,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          _ResultRow(
            label: 'Original Price',
            value: _currency(result.originalPrice),
          ),

          const Divider(height: 24),

          _ResultRow(
            label: 'Discount',
            value: '${result.discountPercent.toStringAsFixed(2)}%',
            valueColor: AppColors.positive,
          ),

          const Divider(height: 24),

          _ResultRow(
            label: 'You Save',
            value: _currency(result.discountAmount),
            valueColor: AppColors.positive,
          ),

          const Divider(height: 24),

          _ResultRow(
            label: 'Final Price',
            value: _currency(result.finalPrice),
            valueColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ResultRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body)),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
