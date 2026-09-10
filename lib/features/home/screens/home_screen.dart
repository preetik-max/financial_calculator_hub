import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            sliver: SliverToBoxAdapter(child: _header(context)),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _quickActions(context)),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _metals(context)),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: SliverToBoxAdapter(child: _financeBanner(context)),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            sliver: SliverToBoxAdapter(child: _exploreCalculators(context)),
          ),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              child: BannerAdWidget(),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Financial Calculator Hub', style: AppTextStyles.title),

              const SizedBox(height: 4),

              Text(
                'Plan smarter. Calculate better.',
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // QUICK ACTIONS
  // --------------------------------------------------

  Widget _quickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: _actionCard(
                icon: Icons.calculate_rounded,
                title: 'Calculators',
                subtitle: 'Coming soon',
                onTap: () {
                  _showComingSoon(context, 'Calculators');
                },
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: _actionCard(
                icon: Icons.account_balance_wallet_rounded,
                title: 'Financial Products',
                subtitle: 'Explore offers',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.financialProducts);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 25),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(title, style: AppTextStyles.sectionTitle),

            const SizedBox(height: 4),

            Text(subtitle, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // GOLD & SILVER
  // --------------------------------------------------

  Widget _metals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gold & Silver', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: _metalCard(
                context,
                title: 'Gold',
                price: '₹7,245',
                unit: '10 grams',
                change: '+1.14%',
                icon: Icons.workspace_premium_rounded,
                iconColor: AppColors.gold,
                background: AppColors.goldLight,
                route: AppRoutes.gold,
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: _metalCard(
                context,
                title: 'Silver',
                price: '₹86,420',
                unit: '1 kilogram',
                change: '+0.86%',
                icon: Icons.circle_outlined,
                iconColor: AppColors.silver,
                background: AppColors.silverLight,
                route: AppRoutes.silver,
              ),
            ),
          ],
        ),
      ],
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
    required Color background,
    required String route,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 30),

            const SizedBox(height: AppSpacing.md),

            Text(title, style: AppTextStyles.sectionTitle),

            const SizedBox(height: 5),

            Text(price, style: AppTextStyles.price),

            const SizedBox(height: 3),

            Text('per $unit', style: AppTextStyles.caption),

            const SizedBox(height: AppSpacing.sm),

            Text(change, style: AppTextStyles.positive),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // FINANCE BANNER
  // --------------------------------------------------

  Widget _financeBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Make better money decisions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Use our calculators to plan '
                  'your investments, loans and savings.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                FilledButton(
                  onPressed: () {
                    _showComingSoon(context, 'Calculators');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Coming Soon'),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          const Icon(
            Icons.account_balance_wallet_rounded,
            size: 58,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // CALCULATORS
  // --------------------------------------------------

  Widget _exploreCalculators(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Explore Calculators',
                style: AppTextStyles.sectionTitle,
              ),
            ),

            TextButton(
              onPressed: () {
                _showComingSoon(context, 'Calculators');
              },
              child: const Text('Coming Soon'),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: const [
            _CalculatorChip(icon: Icons.savings_outlined, label: 'SIP'),
            _CalculatorChip(icon: Icons.payments_outlined, label: 'EMI'),
            _CalculatorChip(icon: Icons.lock_clock_outlined, label: 'FD'),
            _CalculatorChip(icon: Icons.repeat_rounded, label: 'RD'),
            _CalculatorChip(icon: Icons.home_outlined, label: 'Home Loan'),
            _CalculatorChip(icon: Icons.account_balance_outlined, label: 'PPF'),
          ],
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// --------------------------------------------------
// CALCULATOR CHIP
// --------------------------------------------------

class _CalculatorChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CalculatorChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),

          const SizedBox(width: 7),

          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
