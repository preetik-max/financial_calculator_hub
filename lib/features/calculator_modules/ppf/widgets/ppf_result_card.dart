import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../ppf_model.dart';

class PpfResultCard extends StatelessWidget {
  final PpfResult result;

  const PpfResultCard({super.key, required this.result});

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

  String _formatCompactCurrency(double value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(2)} Cr';
    }

    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(2)} L';
    }

    if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    }

    return '₹${value.round()}';
  }

  @override
  Widget build(BuildContext context) {
    final double investment = result.totalInvestment;
    final double interest = result.totalInterest;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PPF Maturity', style: AppTextStyles.sectionTitle),

            const SizedBox(height: 8),

            Text(
              _formatCurrency(result.maturityAmount),
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 4),

            Text(
              'Estimated maturity amount after ${result.tenureYears} years',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withValues(alpha: 0.65),
              ),
            ),

            const SizedBox(height: 24),

            _SummaryRow(
              label: 'Total investment',
              value: _formatCurrency(result.totalInvestment),
              icon: Icons.savings_outlined,
              iconColor: AppColors.primary,
            ),

            const SizedBox(height: 14),

            _SummaryRow(
              label: 'Interest earned',
              value: _formatCurrency(result.totalInterest),
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.positive,
            ),

            const SizedBox(height: 14),

            _SummaryRow(
              label: 'Interest rate',
              value: '${result.annualInterestRate.toStringAsFixed(2)}%',
              icon: Icons.percent_rounded,
              iconColor: AppColors.gold,
            ),

            const SizedBox(height: 28),

            Text('Investment Breakdown', style: AppTextStyles.sectionTitle),

            const SizedBox(height: 18),

            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 42,
                        sections: [
                          PieChartSectionData(
                            value: investment > 0 ? investment : 1,
                            title:
                                '${result.investmentPercentage.toStringAsFixed(0)}%',
                            radius: 62,
                            titleStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: interest > 0 ? interest : 1,
                            title: interest > 0
                                ? '${result.interestPercentage.toStringAsFixed(0)}%'
                                : '0%',
                            radius: 62,
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

                  const SizedBox(width: 12),

                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LegendItem(
                          label: 'Investment',
                          value: _formatCompactCurrency(investment),
                        ),
                        const SizedBox(height: 20),
                        _LegendItem(
                          label: 'Interest',
                          value: _formatCompactCurrency(interest),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.gold,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'PPF interest rates are subject to government revision. '
                      'Actual maturity may vary if the rate changes.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 21),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),

        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final String value;

  const _LegendItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 11,
          height: 11,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: label == 'Investment'
                ? AppColors.primary
                : AppColors.positive,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
