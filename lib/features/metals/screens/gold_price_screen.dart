import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class GoldPriceScreen extends StatelessWidget {
  const GoldPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _MetalScreen(
      title: 'Gold',
      price: '₹7,245',
      unit: 'per 10 grams',
      change: '+₹82  (+1.14%)',
      icon: Icons.workspace_premium_rounded,
      color: AppColors.gold,
      background: AppColors.goldLight,
    );
  }
}

class _MetalScreen extends StatelessWidget {
  final String title;
  final String price;
  final String unit;
  final String change;
  final IconData icon;
  final Color color;
  final Color background;

  const _MetalScreen({
    required this.title,
    required this.price,
    required this.unit,
    required this.change,
    required this.icon,
    required this.color,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title Price')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 34),
                const SizedBox(height: AppSpacing.lg),
                Text(title, style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.sm),
                Text(price, style: AppTextStyles.price),
                const SizedBox(height: 4),
                Text(unit, style: AppTextStyles.body),
                const SizedBox(height: AppSpacing.md),
                Text(change, style: AppTextStyles.positive),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Text('Quantity', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [_quantity('1 g'), _quantity('10 g'), _quantity('100 g')],
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Text('Price Trend', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                'Live price chart',
                style: AppTextStyles.body.copyWith(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quantity(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: OutlinedButton(onPressed: () {}, child: Text(text)),
      ),
    );
  }
}
