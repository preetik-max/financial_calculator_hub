import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/lead/lead_contact_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ================================================================
  // WHATSAPP LEAD MESSAGE
  // ================================================================

  String _whatsappMessage() {
    return '''
Hello, I need help with financial planning.

I am using the Finora Financial Calculator app.

I would like guidance about:

• Loans
• EMI
• Investments
• Mutual Funds
• Insurance
• Financial Planning

Please guide me regarding suitable financial products.

Thank you.
''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ============================================================
      // CENTRALIZED WHATSAPP LEAD BUTTON
      // ============================================================
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: LeadContactButton(
        message: _whatsappMessage(),
        tooltip: 'Chat with Financial Advisor',
        onError: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to open WhatsApp. Please try again.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),

      // ============================================================
      // HOME CONTENT
      // ============================================================
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ======================================================
            // HEADER
            // ======================================================
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                0,
              ),
              sliver: SliverToBoxAdapter(child: _buildHeader(context)),
            ),

            // ======================================================
            // QUICK ACTIONS
            // ======================================================
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverToBoxAdapter(child: _buildQuickActions(context)),
            ),

            // ======================================================
            // GOLD & SILVER
            // ======================================================
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverToBoxAdapter(child: _buildMetals(context)),
            ),

            // ======================================================
            // FINANCE BANNER
            // ======================================================
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverToBoxAdapter(child: _buildFinanceBanner(context)),
            ),

            // ======================================================
            // EXPLORE CALCULATORS
            // ======================================================
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildExploreCalculators(context),
              ),
            ),

            // ======================================================
            // CENTRALIZED BANNER AD
            // ======================================================
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

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Financial Calculator Hub',
                style: AppTextStyles.title,
              ),
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
            tooltip: 'Profile',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            icon: const Icon(Icons.person_outline_rounded),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // QUICK ACTIONS
  // ================================================================

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            // ------------------------------------------------------
            // CALCULATORS
            // ------------------------------------------------------
            Expanded(
              child: _ActionCard(
                icon: Icons.calculate_rounded,
                title: 'Calculators',
                subtitle: 'Explore calculators',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.calculators);
                },
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // ------------------------------------------------------
            // FINANCIAL PRODUCTS
            // ------------------------------------------------------
            Expanded(
              child: _ActionCard(
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

  // ================================================================
  // GOLD & SILVER
  // ================================================================

  Widget _buildMetals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gold & Silver', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: _MetalCard(
                title: 'Gold',
                price: '₹7,245',
                unit: '10 grams',
                change: '+1.14%',
                icon: Icons.workspace_premium_rounded,
                iconColor: AppColors.gold,
                background: AppColors.goldLight,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.gold);
                },
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: _MetalCard(
                title: 'Silver',
                price: '₹86,420',
                unit: '1 kilogram',
                change: '+0.86%',
                icon: Icons.circle_outlined,
                iconColor: AppColors.silver,
                background: AppColors.silverLight,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.silver);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================================================================
  // FINANCE BANNER
  // ================================================================

  Widget _buildFinanceBanner(BuildContext context) {
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
                    Navigator.pushNamed(context, AppRoutes.calculators);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Explore Calculators'),
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

  // ================================================================
  // EXPLORE CALCULATORS
  // ================================================================

  Widget _buildExploreCalculators(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Explore Calculators', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.md),

        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _CalculatorChip(
              icon: Icons.savings_outlined,
              label: 'SIP',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.calculators);
              },
            ),

            _CalculatorChip(
              icon: Icons.payments_outlined,
              label: 'EMI',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.calculators);
              },
            ),

            _CalculatorChip(
              icon: Icons.lock_clock_outlined,
              label: 'FD',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.calculators);
              },
            ),

            _CalculatorChip(
              icon: Icons.repeat_rounded,
              label: 'RD',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.calculators);
              },
            ),

            _CalculatorChip(
              icon: Icons.home_outlined,
              label: 'Home Loan',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.calculators);
              },
            ),

            _CalculatorChip(
              icon: Icons.account_balance_outlined,
              label: 'PPF',
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.calculators);
              },
            ),
          ],
        ),
      ],
    );
  }
}

// ==================================================================
// ACTION CARD
// ==================================================================

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
                  color: AppColors.primary.withValues(alpha: 0.10),
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
      ),
    );
  }
}

// ==================================================================
// METAL CARD
// ==================================================================

class _MetalCard extends StatelessWidget {
  final String title;
  final String price;
  final String unit;
  final String change;
  final IconData icon;
  final Color iconColor;
  final Color background;
  final VoidCallback onTap;

  const _MetalCard({
    required this.title,
    required this.price,
    required this.unit,
    required this.change,
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
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
      ),
    );
  }
}

// ==================================================================
// CALCULATOR CHIP
// ==================================================================

class _CalculatorChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CalculatorChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
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
        ),
      ),
    );
  }
}
