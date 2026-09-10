import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class FinancialProductsScreen extends StatelessWidget {
  const FinancialProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Products')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _heroCard(),

            const SizedBox(height: AppSpacing.xl),

            const Text(
              'Explore Financial Products',
              style: AppTextStyles.sectionTitle,
            ),

            const SizedBox(height: AppSpacing.md),

            _productCard(
              context,
              icon: Icons.credit_card_rounded,
              iconColor: const Color(0xFF7C3AED),
              backgroundColor: const Color(0xFFF3E8FF),
              title: 'Credit Cards',
              subtitle: 'Compare credit cards and offers',
            ),

            _productCard(
              context,
              icon: Icons.payments_rounded,
              iconColor: AppColors.primary,
              backgroundColor: const Color(0xFFE8F0FF),
              title: 'Personal Loan',
              subtitle: 'Explore personal loan options',
            ),

            _productCard(
              context,
              icon: Icons.home_rounded,
              iconColor: const Color(0xFFEA580C),
              backgroundColor: const Color(0xFFFFEDE5),
              title: 'Home Loan',
              subtitle: 'Explore home loan offers',
            ),

            _productCard(
              context,
              icon: Icons.show_chart_rounded,
              iconColor: AppColors.positive,
              backgroundColor: const Color(0xFFE8F8EF),
              title: 'Demat Account',
              subtitle: 'Open a demat and trading account',
            ),

            _productCard(
              context,
              icon: Icons.shield_outlined,
              iconColor: const Color(0xFF0891B2),
              backgroundColor: const Color(0xFFE6F7FA),
              title: 'Insurance',
              subtitle: 'Explore insurance products',
            ),

            _productCard(
              context,
              icon: Icons.account_balance_rounded,
              iconColor: AppColors.gold,
              backgroundColor: AppColors.goldLight,
              title: 'Investment Accounts',
              subtitle: 'Explore investment opportunities',
            ),

            const SizedBox(height: AppSpacing.xl),

            _disclosure(),
          ],
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 40,
          ),

          SizedBox(height: 14),

          Text(
            'Financial Products',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Compare and explore financial products '
            'from our partners.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _productCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: () {
          _comingSoon(context, title);
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(icon, color: iconColor, size: 29),
              ),

              const SizedBox(width: AppSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.sectionTitle),

                    const SizedBox(height: 5),

                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _disclosure() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.silverLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Text(
        'Affiliate Disclosure\n\n'
        'Some links may be affiliate links. '
        'We may earn a commission when you use '
        'certain partner services through our app. '
        'This does not affect the price you pay.',
        style: AppTextStyles.caption.copyWith(height: 1.5),
      ),
    );
  }

  void _comingSoon(BuildContext context, String product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$product offers coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
