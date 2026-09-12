import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'fd_calculator.dart';
import 'fd_model.dart';
import 'widgets/fd_result_card.dart';

class FdScreen extends StatefulWidget {
  const FdScreen({super.key});

  @override
  State<FdScreen> createState() => _FdScreenState();
}

class _FdScreenState extends State<FdScreen> {
  final TextEditingController _principalController = TextEditingController(
    text: '100000',
  );

  final TextEditingController _rateController = TextEditingController(
    text: '7',
  );

  final TextEditingController _tenureController = TextEditingController(
    text: '5',
  );

  int _compoundingFrequency = 4;

  FdResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  double _parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }

  int _parseInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }

  void _calculate() {
    final double principal = _parseDouble(_principalController.text);

    final double rate = _parseDouble(_rateController.text);

    final int tenure = _parseInt(_tenureController.text);

    if (principal <= 0 || rate < 0 || tenure <= 0) {
      setState(() {
        _result = null;
      });
      return;
    }

    final result = FdCalculator.calculate(
      FdInput(
        principal: principal,
        annualInterestRate: rate,
        tenureYears: tenure,
        compoundingFrequency: _compoundingFrequency,
      ),
    );

    setState(() {
      _result = result;
    });
  }

  void _setCompoundingFrequency(int frequency) {
    setState(() {
      _compoundingFrequency = frequency;
    });

    _calculate();
  }

  String _frequencyLabel(int frequency) {
    switch (frequency) {
      case 1:
        return 'Yearly';
      case 2:
        return 'Half-yearly';
      case 4:
        return 'Quarterly';
      case 12:
        return 'Monthly';
      default:
        return 'Quarterly';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FD Calculator'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Fixed Deposit Calculator',
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: 6),
            const Text(
              'Calculate your FD maturity amount and interest earned',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.xl),
            _inputCard(),
            const SizedBox(height: AppSpacing.lg),
            if (_result != null) FdResultCard(result: _result!),
            const SizedBox(height: AppSpacing.lg),
            const BannerAdWidget(),
            const SizedBox(height: AppSpacing.lg),
            _disclaimer(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _inputCard() {
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
          const Text('Investment Details', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.lg),
          _numberField(
            controller: _principalController,
            label: 'Deposit Amount',
            prefix: '₹ ',
            hint: 'Enter FD amount',
          ),
          const SizedBox(height: AppSpacing.md),
          _numberField(
            controller: _rateController,
            label: 'Interest Rate',
            suffix: ' %',
            hint: 'Annual interest rate',
            decimal: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _numberField(
            controller: _tenureController,
            label: 'Tenure',
            suffix: ' years',
            hint: 'Investment period',
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Compounding Frequency', style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _frequencyChip(1),
              _frequencyChip(2),
              _frequencyChip(4),
              _frequencyChip(12),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton(
              onPressed: _calculate,
              child: const Text('Calculate FD'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _frequencyChip(int frequency) {
    final bool selected = _compoundingFrequency == frequency;

    return ChoiceChip(
      label: Text(_frequencyLabel(frequency)),
      selected: selected,
      onSelected: (_) {
        _setCompoundingFrequency(frequency);
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.12),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
    String? hint,
    bool decimal = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      onChanged: (_) {
        _calculate();
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefix,
        suffixText: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
    );
  }

  Widget _disclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: AppColors.primary),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'This calculator provides an indicative estimate. '
              'Actual FD maturity may vary based on the bank, '
              'interest rate, compounding method, taxes and applicable terms.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}
