import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../lumpsum_model.dart';

class LumpsumResultCard extends StatelessWidget {
  final LumpsumResult result;

  const LumpsumResultCard({super.key, required this.result});

  String _formatIndianCurrency(double value) {
    final int amount = value.round();
    final String digits = amount.toString();

    if (digits.length <= 3) {
      return '₹$digits';
    }

    final String lastThree = digits.substring(digits.length - 3);
    String remaining = digits.substring(0, digits.length - 3);

    final List<String> parts = [];

    while (remaining.length > 2) {
      parts.insert(0, remaining.substring(remaining.length - 2));
      remaining = remaining.substring(0, remaining.length - 2);
    }

    if (remaining.isNotEmpty) {
      parts.insert(0, remaining);
    }

    return '₹${parts.join(',')},$lastThree';
  }

  String _formatLakhs(double value) {
    final double lakhs = value / 100000.0;

    if (lakhs >= 100) {
      return '₹${lakhs.toStringAsFixed(1)} L';
    }

    if (lakhs >= 10) {
      return '₹${lakhs.toStringAsFixed(2)} L';
    }

    if (lakhs >= 1) {
      return '₹${lakhs.toStringAsFixed(2)} L';
    }

    return _formatIndianCurrency(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Lumpsum Result', style: AppTextStyles.sectionTitle),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Estimated value after '
            '${result.investmentPeriodYears} '
            '${result.investmentPeriodYears == 1 ? 'year' : 'years'}',
            style: AppTextStyles.body,
          ),

          const SizedBox(height: AppSpacing.lg),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Column(
              children: [
                Text(
                  'Estimated Maturity Value',
                  style: AppTextStyles.body.copyWith(color: Colors.white70),
                ),

                const SizedBox(height: AppSpacing.sm),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _formatLakhs(result.maturityValue),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatIndianCurrency(result.maturityValue),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          const Text('Investment Breakdown', style: AppTextStyles.sectionTitle),

          const SizedBox(height: AppSpacing.lg),

          _breakdownChart(),

          const SizedBox(height: AppSpacing.lg),

          _legendItem(
            iconColor: AppColors.primary,
            title: 'Invested Amount',
            amount: _formatLakhs(result.investedAmount),
            percentage: result.investedPercentage,
          ),

          const SizedBox(height: AppSpacing.md),

          _legendItem(
            iconColor: AppColors.positive,
            title: 'Estimated Returns',
            amount: _formatLakhs(result.estimatedReturns),
            percentage: result.returnsPercentage,
          ),

          const SizedBox(height: AppSpacing.xl),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Text(
              'This is an illustrative estimate. Actual investment '
              'returns may vary depending on market performance.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownChart() {
    final double invested = result.investedAmount;
    final double returns = result.estimatedReturns;

    if (invested <= 0 && returns <= 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
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
                    value: invested,
                    title: '${result.investedPercentage.round()}%',
                    radius: 82,
                    color: AppColors.primary,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  PieChartSectionData(
                    value: returns,
                    title: '${result.returnsPercentage.round()}%',
                    radius: 82,
                    color: AppColors.positive,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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
                _compactLegend(
                  AppColors.primary,
                  'Invested',
                  result.investedPercentage,
                ),
                const SizedBox(height: AppSpacing.md),
                _compactLegend(
                  AppColors.positive,
                  'Returns',
                  result.returnsPercentage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactLegend(Color color, String title, double percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$title\n${percentage.toStringAsFixed(1)}%',
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }

  Widget _legendItem({
    required Color iconColor,
    required String title,
    required String amount,
    required double percentage,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
        ),

        const SizedBox(width: AppSpacing.md),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body),

              const SizedBox(height: 3),

              Text(amount, style: AppTextStyles.sectionTitle),

              const SizedBox(height: 2),

              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: AppTextStyles.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
