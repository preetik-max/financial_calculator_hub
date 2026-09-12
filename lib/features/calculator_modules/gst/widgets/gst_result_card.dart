import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../gst_model.dart';

class GstResultCard extends StatelessWidget {
  final GstResult result;

  const GstResultCard({super.key, required this.result});

  String _currency(double value) {
    final rounded = value.round();
    final text = rounded.toString();

    if (text.length <= 3) {
      return '₹$text';
    }

    final String lastThree = text.substring(text.length - 3);
    String remaining = text.substring(0, text.length - 3);

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
    final bool addMode = result.mode == GstCalculationMode.addGst;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GST Result', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 3),
                      Text(
                        addMode
                            ? 'GST added to base amount'
                            : 'GST extracted from inclusive amount',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            _buildMainResult(
              context,
              addMode ? 'Final Amount' : 'Base Amount',
              addMode ? result.finalAmount : result.baseAmount,
            ),

            const SizedBox(height: 18),

            const Divider(),

            const SizedBox(height: 16),

            _buildAmountRow(context, 'Base Amount', result.baseAmount),

            const SizedBox(height: 12),

            _buildAmountRow(
              context,
              'GST (${result.gstRate.toStringAsFixed(2)}%)',
              result.gstAmount,
              valueColor: AppColors.positive,
            ),

            const SizedBox(height: 12),

            _buildAmountRow(
              context,
              'Final Amount',
              result.finalAmount,
              isBold: true,
            ),

            const SizedBox(height: 24),

            Text('Amount Breakdown', style: AppTextStyles.sectionTitle),

            const SizedBox(height: 18),

            SizedBox(
              height: 210,
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
                            value: result.baseAmount,
                            title:
                                '${result.basePercentage.toStringAsFixed(0)}%',
                            radius: 58,
                            titleStyle: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            value: result.gstAmount,
                            title:
                                '${result.gstPercentage.toStringAsFixed(0)}%',
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

                  const SizedBox(width: 12),

                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegend(context, 'Base Amount', result.baseAmount),
                        const SizedBox(height: 18),
                        _buildLegend(context, 'GST', result.gstAmount),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      addMode
                          ? 'GST is calculated on the entered base amount.'
                          : 'The entered amount is treated as GST-inclusive.',
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

  Widget _buildMainResult(BuildContext context, String title, double amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            _currency(amount),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(
    BuildContext context,
    String label,
    double amount, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isBold ? FontWeight.w700 : null,
            ),
          ),
        ),
        Text(
          _currency(amount),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context, String label, double amount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: label == 'GST' ? AppColors.positive : AppColors.primary,
            shape: BoxShape.circle,
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
                _currency(amount),
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
