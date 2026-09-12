import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../rd_model.dart';

class RdResultCard extends StatelessWidget {
  final RdResult result;

  const RdResultCard({super.key, required this.result});

  String _formatCurrency(double value) {
    final int rounded = value.round();

    final String digits = rounded.abs().toString();

    if (digits.length <= 3) {
      return '₹$digits';
    }

    final String lastThree = digits.substring(digits.length - 3);

    String remaining = digits.substring(0, digits.length - 3);

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
    if (result.maturityAmount <= 0) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryCard(),
        const SizedBox(height: AppSpacing.lg),
        _buildBreakdownCard(),
        const SizedBox(height: AppSpacing.lg),
        _buildPieChartCard(),
      ],
    );
  }

  Widget _buildSummaryCard() {
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
          const Text('Maturity Amount', style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Text(
            _formatCurrency(result.maturityAmount),
            style: AppTextStyles.headline,
          ),
          const SizedBox(height: 8),
          Text(
            '${result.tenureYears} year${result.tenureYears == 1 ? '' : 's'} • '
            '${result.annualInterestRate.toStringAsFixed(2)}% p.a.',
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
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
          const SizedBox(height: AppSpacing.md),
          _row('Total Deposited', _formatCurrency(result.totalDeposited)),
          const SizedBox(height: AppSpacing.sm),
          _row('Interest Earned', _formatCurrency(result.interestEarned)),
          const SizedBox(height: AppSpacing.sm),
          _row(
            'Maturity Amount',
            _formatCurrency(result.maturityAmount),
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value, {bool isHighlighted = false}) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextStyles.body)),
        Text(
          value,
          style: isHighlighted
              ? AppTextStyles.sectionTitle
              : AppTextStyles.body,
        ),
      ],
    );
  }

  Widget _buildPieChartCard() {
    final double deposited = result.totalDeposited;

    final double interest = result.interestEarned;

    final double total = deposited + interest;

    final double depositedPercentage = total > 0 ? deposited / total * 100 : 0;

    final double interestPercentage = total > 0 ? interest / total * 100 : 0;

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
          const Text('Deposit vs Interest', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 45,
                sections: [
                  PieChartSectionData(
                    value: deposited,
                    title: '${depositedPercentage.toStringAsFixed(1)}%',
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: interest,
                    title: '${interestPercentage.toStringAsFixed(1)}%',
                    radius: 70,
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
          Row(
            children: [
              Expanded(child: _legend('Deposited', deposited)),
              Expanded(child: _legend('Interest', interest)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(String title, double value) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: title == 'Deposited'
                ? AppColors.primary
                : AppColors.positive,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(_formatCurrency(value), style: AppTextStyles.body),
            ],
          ),
        ),
      ],
    );
  }
}
