import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../simple_interest_model.dart';

class SimpleInterestResultCard extends StatelessWidget {
  final SimpleInterestResult result;

  const SimpleInterestResultCard({super.key, required this.result});

  String _money(double value) {
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    // AppTextStyles uses static styles.

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calculation Result', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Maturity Amount',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _money(result.maturityAmount),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              height: 190,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 42,
                  sections: [
                    PieChartSectionData(
                      value: result.principal,
                      title:
                          '${result.principalPercentage.toStringAsFixed(0)}%',
                      radius: 58,
                      titleStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      value: result.interest,
                      title: '${result.interestPercentage.toStringAsFixed(0)}%',
                      radius: 58,
                      titleStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(
                  label: 'Principal',
                  value: _money(result.principal),
                ),
                const SizedBox(width: 24),
                _LegendItem(label: 'Interest', value: _money(result.interest)),
              ],
            ),

            const SizedBox(height: 24),

            _ResultRow(
              label: 'Principal Amount',
              value: _money(result.principal),
            ),
            const Divider(height: 22),

            _ResultRow(
              label: 'Simple Interest',
              value: _money(result.interest),
              valueColor: AppColors.positive,
            ),
            const Divider(height: 22),

            _ResultRow(
              label: 'Maturity Amount',
              value: _money(result.maturityAmount),
            ),
            const Divider(height: 22),

            _ResultRow(
              label: 'Interest Rate',
              value: '${result.annualRate.toStringAsFixed(2)}% p.a.',
            ),
            const Divider(height: 22),

            _ResultRow(
              label: 'Time Period',
              value: '${result.timeYears.toStringAsFixed(2)} years',
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
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
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
