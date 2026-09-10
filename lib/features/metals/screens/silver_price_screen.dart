import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class SilverPriceScreen extends StatelessWidget {
  const SilverPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Silver Price')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.silverLight,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle_outlined, color: AppColors.silver, size: 34),
                SizedBox(height: AppSpacing.lg),
                Text('Silver', style: AppTextStyles.sectionTitle),
                SizedBox(height: AppSpacing.sm),
                Text('₹86,420', style: AppTextStyles.price),
                SizedBox(height: 4),
                Text('per kilogram', style: AppTextStyles.body),
                SizedBox(height: AppSpacing.md),
                Text('+₹740  (+0.86%)', style: AppTextStyles.positive),
              ],
            ),
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
            child: const Center(
              child: Text('Live price chart', style: AppTextStyles.body),
            ),
          ),
        ],
      ),
    );
  }
}
