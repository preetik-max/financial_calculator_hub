import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/lead/lead_contact_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class FinancialProductsScreen extends StatelessWidget {
  const FinancialProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Products')),

      // Centralized WhatsApp lead button.
      floatingActionButton: LeadContactButton(
        message: '''
Hello, I need help choosing a financial product.

I am using the Finora Financial Calculator app.

I would like guidance about suitable financial products.

Please contact me.

Thank you.
''',
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

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose a financial product',
                      style: AppTextStyles.title,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Explore financial products and '
                      'connect with providers.',
                      style: AppTextStyles.body,
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    _ProductCard(
                      icon: Icons.account_balance_rounded,
                      title: 'Demat Accounts',
                      description: 'Explore demat and trading account options.',
                      buttonText: 'View Offers',
                      onTap: () {
                        _showComingSoon(context, 'Demat Account offers');
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _ProductCard(
                      icon: Icons.credit_card_rounded,
                      title: 'Credit Cards',
                      description: 'Compare credit card options and benefits.',
                      buttonText: 'View Offers',
                      onTap: () {
                        _showComingSoon(context, 'Credit Card offers');
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _ProductCard(
                      icon: Icons.currency_rupee_rounded,
                      title: 'Personal Loans',
                      description:
                          'Explore personal loan options from providers.',
                      buttonText: 'View Offers',
                      onTap: () {
                        _showComingSoon(context, 'Personal Loan offers');
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _ProductCard(
                      icon: Icons.home_work_rounded,
                      title: 'Home Loans',
                      description: 'Explore home loan options and financing.',
                      buttonText: 'View Offers',
                      onTap: () {
                        _showComingSoon(context, 'Home Loan offers');
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _ProductCard(
                      icon: Icons.shield_outlined,
                      title: 'Insurance',
                      description: 'Explore insurance products from providers.',
                      buttonText: 'View Offers',
                      onTap: () {
                        _showComingSoon(context, 'Insurance offers');
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _ProductCard(
                      icon: Icons.account_balance_outlined,
                      title: 'Fixed Deposits',
                      description: 'Explore fixed deposit options.',
                      buttonText: 'View Offers',
                      onTap: () {
                        _showComingSoon(context, 'Fixed Deposit offers');
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _ProductCard(
                      icon: Icons.trending_up_rounded,
                      title: 'Investments',
                      description:
                          'Explore investment and mutual fund options.',
                      buttonText: 'View Offers',
                      onTap: () {
                        _showComingSoon(context, 'Investment offers');
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Centralized AdMob.
                    const Center(child: BannerAdWidget()),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String product) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$product will be available soon'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _ProductCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  const _ProductCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: AppColors.primary, size: 27),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.sectionTitle),

                    const SizedBox(height: 5),

                    Text(description, style: AppTextStyles.body),

                    const SizedBox(height: AppSpacing.md),

                    OutlinedButton(onPressed: onTap, child: Text(buttonText)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
