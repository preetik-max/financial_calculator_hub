import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../compound_interest_model.dart';

class CompoundInterestResultCard extends StatelessWidget {
  final CompoundInterestResult result;

  const CompoundInterestResultCard({super.key, required this.result});

  String _money(double value) {
    return '₹${value.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Calculation Result', style: AppTextStyles.sectionTitle),

          const SizedBox(height: 18),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Maturity Amount', style: AppTextStyles.caption),
                const SizedBox(height: 5),
                Text(_money(result.maturityAmount), style: AppTextStyles.price),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ============================================================
          // PIE CHART
          // ============================================================
          const Text('Investment Breakdown', style: AppTextStyles.sectionTitle),

          const SizedBox(height: 16),

          SizedBox(
            height: 190,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 42,
                      sections: [
                        PieChartSectionData(
                          value: result.principal,
                          title:
                              '${result.principalPercentage.toStringAsFixed(0)}%',
                          radius: 58,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: result.compoundInterest,
                          title:
                              '${result.interestPercentage.toStringAsFixed(0)}%',
                          radius: 58,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(
                        label: 'Principal',
                        value: _money(result.principal),
                      ),
                      const SizedBox(height: 14),
                      _LegendItem(
                        label: 'Compound Interest',
                        value: _money(result.compoundInterest),
                        isInterest: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ============================================================
          // RESULT VALUES
          // ============================================================
          Row(
            children: [
              Expanded(
                child: _ResultItem(
                  label: 'Principal',
                  value: _money(result.principal),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ResultItem(
                  label: 'Interest',
                  value: _money(result.compoundInterest),
                  valueColor: AppColors.positive,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _ResultItem(
                  label: 'Interest Rate',
                  value: '${result.annualRate.toStringAsFixed(2)}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ResultItem(
                  label: 'Duration',
                  value: '${result.timeYears.toStringAsFixed(2)} years',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _ResultItem(label: 'Compounding', value: result.frequency.label),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isInterest;

  const _LegendItem({
    required this.label,
    required this.value,
    this.isInterest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isInterest ? AppColors.positive : AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ResultItem({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: valueColor ?? AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
