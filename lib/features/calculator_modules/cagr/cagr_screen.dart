import 'package:flutter/material.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'cagr_calculator.dart';
import 'cagr_model.dart';
import 'widgets/cagr_result_card.dart';

class CagrScreen extends StatefulWidget {
  const CagrScreen({super.key});

  @override
  State<CagrScreen> createState() => _CagrScreenState();
}

class _CagrScreenState extends State<CagrScreen> {
  final TextEditingController _initialController = TextEditingController(
    text: '100000',
  );

  final TextEditingController _finalController = TextEditingController(
    text: '200000',
  );

  final TextEditingController _yearsController = TextEditingController(
    text: '5',
  );

  CagrResult? _result;

  @override
  void initState() {
    super.initState();

    _calculate();
  }

  @override
  void dispose() {
    _initialController.dispose();
    _finalController.dispose();
    _yearsController.dispose();

    super.dispose();
  }

  double _parse(String value) {
    return double.tryParse(value.replaceAll(',', '').trim()) ?? 0.0;
  }

  void _calculate() {
    final input = CagrInput(
      initialInvestment: _parse(_initialController.text),
      finalValue: _parse(_finalController.text),
      periodYears: _parse(_yearsController.text),
    );

    final result = CagrCalculator.calculate(input);

    setState(() {
      _result = result;
    });
  }

  void _reset() {
    _initialController.text = '100000';
    _finalController.text = '200000';
    _yearsController.text = '5';

    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CAGR Calculator'), centerTitle: true),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text('CAGR Calculator', style: AppTextStyles.headline),

            const SizedBox(height: 6),

            const Text(
              'Calculate the annualized growth of your investment',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.xxl),

            _buildInputCard(),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: const Text('Reset'),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _calculate,
                    child: const Text('Calculate CAGR'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            if (_result != null) CagrResultCard(result: _result!),

            if (_result == null) _buildValidationMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
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

          _buildInputField(
            controller: _initialController,
            label: 'Initial Investment',
            hint: 'Example: ₹1,00,000',
            prefix: '₹',
          ),

          const SizedBox(height: AppSpacing.md),

          _buildInputField(
            controller: _finalController,
            label: 'Final Value',
            hint: 'Example: ₹2,00,000',
            prefix: '₹',
          ),

          const SizedBox(height: AppSpacing.md),

          _buildInputField(
            controller: _yearsController,
            label: 'Investment Period',
            hint: 'Example: 5',
            suffix: 'Years',
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? prefix,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => _calculate(),
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

  Widget _buildValidationMessage() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'Please enter valid values for initial investment, '
        'final value, and investment period.',
        style: AppTextStyles.body,
      ),
    );
  }
}
