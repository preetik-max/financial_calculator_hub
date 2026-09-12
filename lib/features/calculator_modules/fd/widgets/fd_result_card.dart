import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../fd_model.dart';

class FdResultCard extends StatelessWidget {
  final FdResult result;

  const FdResultCard({super.key, required this.result});

  String _formatCurrency(double value) {
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

  @override
  Widget build(BuildContext context) {
    if (result.principal <= 0 || result.maturityAmount <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        _summaryCard(),
        const SizedBox(height: AppSpacing.lg),
        _breakdownCard(),
      ],
    );
  }

  Widget _summaryCard() {
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
          const Text('FD Maturity', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.md),
          const Text('Maturity Amount', style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(
            _formatCurrency(result.maturityAmount),
            style: AppTextStyles.headline,
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.positive.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.positive,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Interest Earned',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatCurrency(result.totalInterest),
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.positive,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _breakdownCard() {
    final double principal = result.principal;
    final double interest = result.totalInterest;

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
          const Text('Investment Breakdown', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 190,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 48,
                sectionsSpace: 3,
                sections: [
                  PieChartSectionData(
                    value: principal,
                    title: '${result.principalPercentage.toStringAsFixed(0)}%',
                    radius: 58,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: interest,
                    title: '${result.interestPercentage.toStringAsFixed(0)}%',
                    radius: 58,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _legendRow(
            'Principal',
            _formatCurrency(principal),
            AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          _legendRow('Interest', _formatCurrency(interest), AppColors.positive),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Maturity', style: AppTextStyles.sectionTitle),
              Text(
                _formatCurrency(result.maturityAmount),
                style: AppTextStyles.sectionTitle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendRow(String title, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(title, style: AppTextStyles.body)),
        Text(value, style: AppTextStyles.sectionTitle),
      ],
    );
  }
}
