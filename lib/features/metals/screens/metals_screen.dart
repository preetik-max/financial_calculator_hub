import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class MetalsScreen extends StatelessWidget {
  const MetalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gold & Silver')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text('Precious Metals', style: AppTextStyles.headline),

            const SizedBox(height: AppSpacing.sm),

            const Text(
              'Track gold and silver prices',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.xl),

            _metalCard(
              context,
              title: 'Gold',
              price: '₹7,245',
              unit: '10 grams',
              change: '+1.14%',
              icon: Icons.workspace_premium_rounded,
              iconColor: AppColors.gold,
              backgroundColor: AppColors.goldLight,
              route: AppRoutes.gold,
            ),

            const SizedBox(height: AppSpacing.lg),

            _metalCard(
              context,
              title: 'Silver',
              price: '₹86,420',
              unit: '1 kilogram',
              change: '+0.86%',
              icon: Icons.circle_outlined,
              iconColor: AppColors.silver,
              backgroundColor: AppColors.silverLight,
              route: AppRoutes.silver,
            ),
          ],
        ),
      ),
    );
  }

  Widget _metalCard(
    BuildContext context, {
    required String title,
    required String price,
    required String unit,
    required String change,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String route,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: iconColor, size: 40),
            ),

            const SizedBox(width: AppSpacing.lg),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.title),

                  const SizedBox(height: 6),

                  Text(price, style: AppTextStyles.price),

                  const SizedBox(height: 3),

                  Text('per $unit', style: AppTextStyles.body),

                  const SizedBox(height: AppSpacing.sm),

                  Text(change, style: AppTextStyles.positive),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              size: 32,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
