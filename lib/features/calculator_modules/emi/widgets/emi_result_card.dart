import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../emi_model.dart';

class EmiResultCard extends StatelessWidget {
  final EmiResult result;

  const EmiResultCard({super.key, required this.result});

  String _formatCurrency(double value) {
    if (value.isNaN || value.isInfinite) {
      return '₹0';
    }

    return '₹${value.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)},')}';
  }

  String _formatPercent(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasResult = result.monthlyEmi > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Monthly EMI', style: AppTextStyles.caption),
              const SizedBox(height: 6),
              Text(
                _formatCurrency(result.monthlyEmi),
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your estimated monthly loan payment',
                style: AppTextStyles.body,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'Principal',
                value: _formatCurrency(result.loanAmount),
                icon: Icons.account_balance_wallet_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _summaryCard(
                title: 'Interest',
                value: _formatCurrency(result.totalInterest),
                icon: Icons.percent_rounded,
                color: AppColors.positive,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        Row(
          children: [
            Expanded(
              child: _summaryCard(
                title: 'Total Payment',
                value: _formatCurrency(result.totalPayment),
                icon: Icons.payments_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _summaryCard(
                title: 'Tenure',
                value: '${result.tenureYears} Years',
                icon: Icons.calendar_month_outlined,
                color: AppColors.gold,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Payment Breakdown',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: 4),
              const Text(
                'Principal vs total interest',
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: AppSpacing.lg),

              if (hasResult)
                SizedBox(
                  height: 210,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 45,
                            sections: [
                              PieChartSectionData(
                                value: result.loanAmount,
                                title: _formatPercent(
                                  result.principalPercentage,
                                ),
                                radius: 65,
                                titleStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                color: AppColors.primary,
                              ),
                              PieChartSectionData(
                                value: result.totalInterest,
                                title: _formatPercent(
                                  result.interestPercentage,
                                ),
                                radius: 65,
                                titleStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                color: AppColors.positive,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: AppSpacing.md),

                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _legend(
                              color: AppColors.primary,
                              title: 'Principal',
                              value: _formatCurrency(result.loanAmount),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _legend(
                              color: AppColors.positive,
                              title: 'Interest',
                              value: _formatCurrency(result.totalInterest),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Enter valid loan details to see the breakdown.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xl),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Loan Summary', style: AppTextStyles.sectionTitle),
              const SizedBox(height: AppSpacing.md),

              _detailRow('Loan Amount', _formatCurrency(result.loanAmount)),
              _detailRow(
                'Interest Rate',
                '${result.annualInterestRate.toStringAsFixed(2)}% p.a.',
              ),
              _detailRow(
                'Tenure',
                '${result.tenureYears} Years (${result.tenureMonths} months)',
              ),
              _detailRow('Monthly EMI', _formatCurrency(result.monthlyEmi)),
              _detailRow(
                'Total Interest',
                _formatCurrency(result.totalInterest),
              ),
              _detailRow('Total Payment', _formatCurrency(result.totalPayment)),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        const Text(
          'Note: This calculator provides an estimate. Actual EMI may vary '
          'depending on the lender, interest calculation method, fees, '
          'insurance and other charges.',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.sectionTitle),
        ],
      ),
    );
  }

  Widget _legend({
    required Color color,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.sectionTitle),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.body)),
          Text(value, style: AppTextStyles.sectionTitle),
        ],
      ),
    );
  }
}
