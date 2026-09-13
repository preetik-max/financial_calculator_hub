import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../percentage_model.dart';

class PercentageResultCard extends StatelessWidget {
  final PercentageResult result;

  const PercentageResultCard({super.key, required this.result});

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  String _formatPercentage(double value) {
    return '${_formatNumber(value)}%';
  }

  @override
  Widget build(BuildContext context) {
    switch (result.mode) {
      case PercentageMode.percentageOf:
        return _buildPercentageOfCard();

      case PercentageMode.whatPercentage:
        return _buildWhatPercentageCard();

      case PercentageMode.increaseDecrease:
        return _buildIncreaseDecreaseCard();
    }
  }

  Widget _buildPercentageOfCard() {
    final double percentage = result.firstValue.clamp(0, 100).toDouble();
    final double remaining = 100 - percentage;

    return _ResultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Calculation Result', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 18),
          _MainResult(
            label:
                '${_formatNumber(result.firstValue)}% of ${_formatNumber(result.secondValue)}',
            value: _formatNumber(result.result),
          ),
          const SizedBox(height: 22),
          _PercentagePieChart(
            firstValue: percentage,
            secondValue: remaining,
            centerText: _formatPercentage(result.firstValue),
          ),
          const SizedBox(height: 20),
          const _LegendRow(color: AppColors.primary, label: 'Percentage'),
          const SizedBox(height: 8),
          const _LegendRow(color: AppColors.border, label: 'Remaining'),
        ],
      ),
    );
  }

  Widget _buildWhatPercentageCard() {
    return _ResultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Calculation Result', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 18),
          _MainResult(
            label:
                '${_formatNumber(result.firstValue)} is what % of ${_formatNumber(result.secondValue)}',
            value: _formatPercentage(result.result),
          ),
          const SizedBox(height: 22),
          _PercentagePieChart(
            firstValue: result.result.abs(),
            secondValue: 100,
            centerText: _formatPercentage(result.result),
          ),
          const SizedBox(height: 18),
          _InfoRow(
            label: 'First Value',
            value: _formatNumber(result.firstValue),
          ),
          _InfoRow(
            label: 'Second Value',
            value: _formatNumber(result.secondValue),
          ),
        ],
      ),
    );
  }

  Widget _buildIncreaseDecreaseCard() {
    final bool increase = result.result >= 0;
    final double percentage = result.percentageChange.abs();

    final double chartValue = percentage.clamp(0, 100).toDouble();

    return _ResultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Calculation Result', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 18),
          _MainResult(
            label: increase ? 'Percentage Increase' : 'Percentage Decrease',
            value: _formatPercentage(percentage),
            valueColor: increase ? AppColors.positive : AppColors.negative,
          ),
          const SizedBox(height: 22),
          _PercentagePieChart(
            firstValue: chartValue,
            secondValue: 100,
            centerText: _formatPercentage(percentage),
          ),
          const SizedBox(height: 18),
          _InfoRow(
            label: 'Old Value',
            value: _formatNumber(result.secondValue),
          ),
          _InfoRow(label: 'New Value', value: _formatNumber(result.firstValue)),
          _InfoRow(
            label: 'Change',
            value: '${increase ? '+' : ''}${_formatNumber(result.result)}',
            valueColor: increase ? AppColors.positive : AppColors.negative,
          ),
        ],
      ),
    );
  }
}

class _ResultContainer extends StatelessWidget {
  final Widget child;

  const _ResultContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MainResult extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MainResult({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.price.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _PercentagePieChart extends StatelessWidget {
  final double firstValue;
  final double secondValue;
  final String centerText;

  const _PercentagePieChart({
    required this.firstValue,
    required this.secondValue,
    required this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    final double safeFirst = firstValue.isFinite && firstValue > 0
        ? firstValue
        : 0;

    final double safeSecond = secondValue.isFinite && secondValue > 0
        ? secondValue
        : 0;

    final double total = safeFirst + safeSecond;

    if (total <= 0) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text('No chart data', style: AppTextStyles.caption),
        ),
      );
    }

    return SizedBox(
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: 52,
              sectionsSpace: 2,
              sections: [
                PieChartSectionData(
                  value: safeFirst,
                  radius: 58,
                  showTitle: false,
                  color: AppColors.primary,
                ),
                PieChartSectionData(
                  value: safeSecond,
                  radius: 58,
                  showTitle: false,
                  color: AppColors.border,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(centerText, style: AppTextStyles.title),
              const SizedBox(height: 3),
              const Text('Percentage', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
