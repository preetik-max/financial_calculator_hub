import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../sip_model.dart';

class SipResultCard extends StatelessWidget {
  final SipResult result;

  const SipResultCard({super.key, required this.result});

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    }

    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    }

    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }

    return '₹${amount.toStringAsFixed(0)}';
  }

  String _formatExact(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final double invested = result.investedAmount;
    final double returns = result.estimatedReturns;
    final double total = result.maturityValue;

    final double investedPercentage = total > 0 ? (invested / total) * 100 : 0;

    final double returnsPercentage = total > 0 ? (returns / total) * 100 : 0;

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
          const Text('Your SIP Result', style: AppTextStyles.sectionTitle),

          const SizedBox(height: 6),

          Text(
            'Estimated value after ${result.investmentYears} years',
            style: AppTextStyles.caption,
          ),

          const SizedBox(height: AppSpacing.lg),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Column(
              children: [
                const Text(
                  'Estimated Maturity Value',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),

                const SizedBox(height: 6),

                Text(
                  _formatAmount(total),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatExact(total),
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          const Text('Investment Breakdown', style: AppTextStyles.sectionTitle),

          const SizedBox(height: AppSpacing.md),

          SizedBox(
            height: 230,
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 42,
                      sectionsSpace: 3,
                      sections: [
                        PieChartSectionData(
                          value: invested > 0 ? invested : 1,
                          title: '${investedPercentage.toStringAsFixed(0)}%',
                          radius: 62,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                          color: AppColors.primary,
                        ),
                        PieChartSectionData(
                          value: returns > 0 ? returns : 1,
                          title: '${returnsPercentage.toStringAsFixed(0)}%',
                          radius: 62,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                          color: AppColors.success,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legend(
                        label: 'Invested Amount',
                        amount: invested,
                        percentage: investedPercentage,
                        color: AppColors.primary,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      _legend(
                        label: 'Estimated Returns',
                        amount: returns,
                        percentage: returnsPercentage,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          const Divider(),

          const SizedBox(height: AppSpacing.md),

          _row('Monthly SIP', _formatExact(result.monthlyInvestment)),

          _row(
            'Expected Return',
            '${result.expectedReturn.toStringAsFixed(1)}% p.a.',
          ),

          _row('Investment Period', '${result.investmentYears} years'),

          _row('Total Investment', _formatExact(invested)),

          _row('Estimated Returns', _formatExact(returns)),

          _row('Maturity Value', _formatExact(total), highlighted: true),
        ],
      ),
    );
  }

  Widget _legend({
    required String label,
    required double amount,
    required double percentage,
    required Color color,
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
              Text(label, style: AppTextStyles.caption),

              const SizedBox(height: 3),

              Text(_formatAmount(amount), style: AppTextStyles.sectionTitle),

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

  Widget _row(String label, String value, {bool highlighted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body)),

          Text(
            value,
            style: highlighted
                ? AppTextStyles.sectionTitle
                : AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
