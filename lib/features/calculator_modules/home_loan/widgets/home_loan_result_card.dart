import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../home_loan_model.dart';

class HomeLoanResultCard extends StatelessWidget {
  final HomeLoanResult result;

  const HomeLoanResultCard({super.key, required this.result});

  String _formatCurrency(double value) {
    if (value.isNaN || value.isInfinite) {
      return '₹0';
    }

    final rounded = value.round();

    final String number = rounded.toString();

    if (number.length <= 3) {
      return '₹$number';
    }

    final String lastThree = number.substring(number.length - 3);

    String remaining = number.substring(0, number.length - 3);

    final List<String> groups = [];

    while (remaining.length > 2) {
      groups.insert(0, remaining.substring(remaining.length - 2));

      remaining = remaining.substring(0, remaining.length - 2);
    }

    if (remaining.isNotEmpty) {
      groups.insert(0, remaining);
    }

    return '₹${groups.join(',')},$lastThree';
  }

  String _formatPercent(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final bool hasResult = result.totalPayment > 0;

    return Container(
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
          const Text('Home Loan Result', style: AppTextStyles.sectionTitle),

          const SizedBox(height: AppSpacing.lg),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              color: AppColors.primary.withValues(alpha: 0.07),
            ),
            child: Column(
              children: [
                const Text('Monthly EMI', style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Text(
                  _formatCurrency(result.monthlyEmi),
                  style: AppTextStyles.headline.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          _summaryRow('Loan Amount', _formatCurrency(result.loanAmount)),

          _summaryRow(
            'Interest Rate',
            '${result.annualInterestRate.toStringAsFixed(2)}% p.a.',
          ),

          _summaryRow(
            'Tenure',
            '${result.tenureYears} years (${result.tenureMonths} months)',
          ),

          _summaryRow('Total Interest', _formatCurrency(result.totalInterest)),

          _summaryRow('Total Payment', _formatCurrency(result.totalPayment)),

          if (hasResult) ...[
            const SizedBox(height: AppSpacing.xl),

            const Divider(),

            const SizedBox(height: AppSpacing.lg),

            const Text('Payment Breakdown', style: AppTextStyles.sectionTitle),

            const SizedBox(height: AppSpacing.lg),

            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 42,
                        sections: [
                          PieChartSectionData(
                            value: result.loanAmount,
                            title: _formatPercent(result.principalPercentage),
                            radius: 62,
                            titleStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            color: AppColors.primary,
                          ),
                          PieChartSectionData(
                            value: result.totalInterest,
                            title: _formatPercent(result.interestPercentage),
                            radius: 62,
                            titleStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            color: AppColors.negative,
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
                        _legendItem(
                          color: AppColors.primary,
                          title: 'Principal',
                          value: _formatCurrency(result.loanAmount),
                        ),
                        const SizedBox(height: 16),
                        _legendItem(
                          color: AppColors.negative,
                          title: 'Interest',
                          value: _formatCurrency(result.totalInterest),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(child: Text(title, style: AppTextStyles.body)),
          Text(value, style: AppTextStyles.sectionTitle),
        ],
      ),
    );
  }

  Widget _legendItem({
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
          margin: const EdgeInsets.only(top: 4),
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
}
