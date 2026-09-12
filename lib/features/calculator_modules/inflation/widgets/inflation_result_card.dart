import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../inflation_model.dart';

class InflationResultCard extends StatelessWidget {
  final InflationResult result;

  const InflationResultCard({super.key, required this.result});

  String _formatCurrency(double value) {
    return '₹${value.toStringAsFixed(0)}';
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

    return _formatCurrency(value);
  }

  @override
  Widget build(BuildContext context) {
    final double currentAmount = result.currentAmount;
    final double inflationIncrease = result.inflationIncrease;
    final double futureCost = result.futureCost;

    final bool hasChartData = currentAmount > 0 && inflationIncrease > 0;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.border.withOpacity(0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calculation Result', style: AppTextStyles.sectionTitle),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('Future Cost', style: AppTextStyles.caption),
                  const SizedBox(height: 6),
                  Text(
                    _formatCompactCurrency(futureCost),
                    style: AppTextStyles.price.copyWith(fontSize: 30),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'After ${result.years} ${result.years == 1 ? 'year' : 'years'}',
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            if (hasChartData) ...[
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 3,
                    centerSpaceRadius: 48,
                    sections: [
                      PieChartSectionData(
                        value: currentAmount,
                        title: '',
                        radius: 58,
                        color: AppColors.primary,
                      ),
                      PieChartSectionData(
                        value: inflationIncrease,
                        title: '',
                        radius: 58,
                        color: AppColors.negative,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(color: AppColors.primary, label: 'Current Value'),
                  const SizedBox(width: 22),
                  _LegendItem(
                    color: AppColors.negative,
                    label: 'Inflation Impact',
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],

            _ResultRow(
              label: 'Current Amount',
              value: _formatCompactCurrency(currentAmount),
            ),

            const Divider(height: 22),

            _ResultRow(
              label: 'Inflation Increase',
              value: _formatCompactCurrency(inflationIncrease),
              valueColor: AppColors.negative,
            ),

            const Divider(height: 22),

            _ResultRow(
              label: 'Future Cost',
              value: _formatCompactCurrency(futureCost),
              valueColor: AppColors.primary,
            ),

            const Divider(height: 22),

            _ResultRow(
              label: 'Total Increase',
              value: '${result.increasePercentage.toStringAsFixed(2)}%',
              valueColor: AppColors.negative,
            ),

            const Divider(height: 22),

            _ResultRow(
              label: 'Purchasing Power',
              value: '${result.purchasingPower.toStringAsFixed(2)}%',
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.negative.withOpacity(0.07),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: AppColors.negative,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Due to inflation, an item costing '
                      '${_formatCompactCurrency(currentAmount)} today '
                      'may cost approximately '
                      '${_formatCompactCurrency(futureCost)} '
                      'after ${result.years} years.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                      ),
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

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ResultRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w800,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
