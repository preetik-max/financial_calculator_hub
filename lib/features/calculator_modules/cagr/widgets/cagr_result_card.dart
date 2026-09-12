import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../cagr_model.dart';

class CagrResultCard extends StatelessWidget {
  final CagrResult result;

  const CagrResultCard({super.key, required this.result});

  String _formatCurrency(double value) {
    final bool negative = value < 0;
    final double absolute = value.abs();

    String formatted;

    if (absolute >= 10000000) {
      formatted = '₹${(absolute / 10000000).toStringAsFixed(2)} Cr';
    } else if (absolute >= 100000) {
      formatted = '₹${(absolute / 100000).toStringAsFixed(2)} L';
    } else if (absolute >= 1000) {
      formatted = '₹${(absolute / 1000).toStringAsFixed(2)} K';
    } else {
      formatted = '₹${absolute.toStringAsFixed(0)}';
    }

    return negative ? '-$formatted' : formatted;
  }

  String _formatPercentage(double value) {
    return '${value.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    final bool profitable = result.profit >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your CAGR Result', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.md),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              const Text('CAGR', style: AppTextStyles.caption),

              const SizedBox(height: 6),

              Text(
                _formatPercentage(result.cagr),
                style: AppTextStyles.headline.copyWith(
                  color: profitable ? AppColors.positive : AppColors.negative,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '${result.periodYears.toStringAsFixed(1)} year investment period',
                style: AppTextStyles.caption,
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildSummaryRow(
                'Initial Investment',
                _formatCurrency(result.initialInvestment),
              ),

              const Divider(height: 24),

              _buildSummaryRow(
                'Final Value',
                _formatCurrency(result.finalValue),
              ),

              const Divider(height: 24),

              _buildSummaryRow(
                'Profit / Loss',
                _formatCurrency(result.profit),
                valueColor: profitable
                    ? AppColors.positive
                    : AppColors.negative,
              ),

              const Divider(height: 24),

              _buildSummaryRow(
                'Total Growth',
                _formatPercentage(result.growthPercentage),
                valueColor: profitable
                    ? AppColors.positive
                    : AppColors.negative,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.xxl),

        const Text('Investment Breakdown', style: AppTextStyles.sectionTitle),

        const SizedBox(height: AppSpacing.md),

        _buildChartCard(context),
      ],
    );
  }

  Widget _buildSummaryRow(String title, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.body),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildChartCard(BuildContext context) {
    final double investment = result.initialInvestment;
    final double profit = result.profit > 0 ? result.profit : 0;

    final double total = investment + profit;

    if (total <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 45,
                sections: [
                  PieChartSectionData(
                    value: investment,
                    title: 'Investment',
                    radius: 70,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (profit > 0)
                    PieChartSectionData(
                      value: profit,
                      title: 'Profit',
                      radius: 70,
                      titleStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem('Investment', investment),
              const SizedBox(width: AppSpacing.lg),
              if (profit > 0) _legendItem('Profit', profit),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String title, double value) {
    return Column(
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: 3),
        Text(_formatCurrency(value), style: AppTextStyles.sectionTitle),
      ],
    );
  }
}
