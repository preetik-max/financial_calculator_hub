import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/lead/lead_contact_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import 'car_loans_screen.dart';
import 'credit_cards_screen.dart';
import 'fixed_deposits_screen.dart';
import 'home_loans_screen.dart';
import 'insurance_screen.dart';
import 'personal_loans_screen.dart';

class FinancialProductsScreen extends StatelessWidget {
  const FinancialProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Products')),

      // ============================================================
      // CENTRALIZED WHATSAPP LEAD BUTTON
      // ============================================================
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
                    // ==================================================
                    // HEADER
                    // ==================================================
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

                    // ==================================================
                    // 1. CREDIT CARDS
                    // ==================================================
                    _ProductCard(
                      icon: Icons.credit_card_rounded,
                      title: 'Credit Cards',
                      description: 'Compare credit card options and benefits.',
                      buttonText: 'View Offers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreditCardsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ==================================================
                    // 2. PERSONAL LOANS
                    // ==================================================
                    _ProductCard(
                      icon: Icons.currency_rupee_rounded,
                      title: 'Personal Loans',
                      description:
                          'Explore personal loan options from '
                          'banks and financial providers.',
                      buttonText: 'View Offers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PersonalLoansScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ==================================================
                    // 3. HOME LOANS
                    // ==================================================
                    _ProductCard(
                      icon: Icons.home_work_rounded,
                      title: 'Home Loans',
                      description:
                          'Explore home loan options and '
                          'housing finance.',
                      buttonText: 'View Offers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HomeLoansScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ==================================================
                    // 4. CAR LOANS
                    // ==================================================
                    _ProductCard(
                      icon: Icons.directions_car_rounded,
                      title: 'Car Loans',
                      description:
                          'Explore car loan options and '
                          'vehicle financing.',
                      buttonText: 'View Offers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CarLoansScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ==================================================
                    // 5. INSURANCE
                    // ==================================================
                    _ProductCard(
                      icon: Icons.shield_outlined,
                      title: 'Insurance',
                      description:
                          'Explore insurance products from '
                          'financial providers.',
                      buttonText: 'View Offers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InsuranceScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // ==================================================
                    // 6. FIXED DEPOSITS
                    // ==================================================
                    _ProductCard(
                      icon: Icons.account_balance_outlined,
                      title: 'Fixed Deposits',
                      description:
                          'Explore fixed deposit options '
                          'and savings products.',
                      buttonText: 'View Offers',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FixedDepositsScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ==================================================
                    // ADMOB BANNER
                    // ==================================================
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
}

// ==================================================================
// PRODUCT CARD
// ==================================================================

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
              // ======================================================
              // PRODUCT ICON
              // ======================================================
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

              // ======================================================
              // PRODUCT CONTENT
              // ======================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.sectionTitle),

                    const SizedBox(height: 5),

                    Text(description, style: AppTextStyles.body),

                    const SizedBox(height: AppSpacing.md),

                    // ==================================================
                    // ACTION BUTTON
                    // ==================================================
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
