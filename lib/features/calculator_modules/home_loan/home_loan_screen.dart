import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import 'home_loan_calculator.dart';
import 'home_loan_model.dart';
import 'widgets/home_loan_result_card.dart';

class HomeLoanScreen extends StatefulWidget {
  const HomeLoanScreen({super.key});

  @override
  State<HomeLoanScreen> createState() => _HomeLoanScreenState();
}

class _HomeLoanScreenState extends State<HomeLoanScreen> {
  final TextEditingController _loanAmountController = TextEditingController(
    text: '5000000',
  );

  final TextEditingController _interestRateController = TextEditingController(
    text: '8.5',
  );

  final TextEditingController _tenureController = TextEditingController(
    text: '20',
  );

  HomeLoanResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
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
    final double loanAmount = _parseDouble(_loanAmountController.text);
    final double interestRate = _parseDouble(_interestRateController.text);
    final int tenure = _parseInt(_tenureController.text);

    if (loanAmount <= 0 || interestRate < 0 || tenure <= 0) {
      setState(() {
        _result = null;
      });
      return;
    }

    final result = HomeLoanCalculator.calculate(
      HomeLoanInput(
        loanAmount: loanAmount,
        annualInterestRate: interestRate,
        tenureYears: tenure,
      ),
    );

    setState(() {
      _result = result;
    });
  }

  void _reset() {
    _loanAmountController.text = '5000000';
    _interestRateController.text = '8.5';
    _tenureController.text = '20';

    _calculate();
  }

  String? _validateLoanAmount(String? value) {
    final amount = _parseDouble(value ?? '');

    if (amount <= 0) {
      return 'Enter a valid loan amount';
    }

    return null;
  }

  String? _validateInterestRate(String? value) {
    final rate = _parseDouble(value ?? '');

    if (rate < 0 || rate > 30) {
      return 'Enter rate between 0% and 30%';
    }

    return null;
  }

  String? _validateTenure(String? value) {
    final tenure = _parseInt(value ?? '');

    if (tenure < 1 || tenure > 40) {
      return 'Enter tenure between 1 and 40 years';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Home Loan Calculator'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Calculate your home loan EMI',
              style: AppTextStyles.headline,
            ),

            const SizedBox(height: 6),

            const Text(
              'Estimate monthly EMI, total interest and total repayment.',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.xxl),

            _inputCard(),

            if (_result != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              HomeLoanResultCard(result: _result!),
            ],

            const SizedBox(height: AppSpacing.xxl),

            _disclaimer(),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),

      // AdMob banner
      bottomNavigationBar: const SafeArea(top: false, child: BannerAdWidget()),
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
          const Text('Loan Details', style: AppTextStyles.sectionTitle),

          const SizedBox(height: AppSpacing.lg),

          _buildTextField(
            controller: _loanAmountController,
            label: 'Home Loan Amount',
            hint: 'e.g. 5000000',
            prefixText: '₹ ',
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            validator: _validateLoanAmount,
          ),

          const SizedBox(height: AppSpacing.md),

          _buildTextField(
            controller: _interestRateController,
            label: 'Interest Rate',
            hint: 'e.g. 8.5',
            suffixText: '% p.a.',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: _validateInterestRate,
          ),

          const SizedBox(height: AppSpacing.md),

          _buildTextField(
            controller: _tenureController,
            label: 'Loan Tenure',
            hint: 'e.g. 20',
            suffixText: 'years',
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            validator: _validateTenure,
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _calculate,
                    child: const Text('Calculate EMI'),
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              OutlinedButton(
                onPressed: _reset,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(92, 50),
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? prefixText,
    String? suffixText,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        suffixText: suffixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      onChanged: (_) {
        _calculate();
      },
    );
  }

  Widget _disclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'This calculator provides an estimate for educational purposes. '
              'Actual home loan EMI, interest rate, fees and eligibility may '
              'vary by lender and loan terms.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}
