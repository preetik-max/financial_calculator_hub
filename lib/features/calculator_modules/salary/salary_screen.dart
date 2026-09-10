import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import 'salary_calculator.dart';
import 'salary_model.dart';
import 'widgets/salary_result_card.dart';

class SalaryScreen extends StatefulWidget {
  const SalaryScreen({super.key});

  @override
  State<SalaryScreen> createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  final _grossController = TextEditingController(text: '50000');

  final _pfController = TextEditingController(text: '12');

  final _professionalTaxController = TextEditingController(text: '200');

  final _otherDeductionsController = TextEditingController(text: '0');

  SalaryResult? _result;

  @override
  void dispose() {
    _grossController.dispose();
    _pfController.dispose();
    _professionalTaxController.dispose();
    _otherDeductionsController.dispose();
    super.dispose();
  }

  double _parse(TextEditingController controller) {
    return double.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;
  }

  void _calculate() {
    FocusScope.of(context).unfocus();

    final input = SalaryInput(
      monthlyGross: _parse(_grossController),
      pfPercent: _parse(_pfController),
      professionalTax: _parse(_professionalTaxController),
      otherDeductions: _parse(_otherDeductionsController),
    );

    if (input.monthlyGross <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid monthly salary.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _result = SalaryCalculator.calculate(input);
    });
  }

  String _money(double value) {
    return '₹${value.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salary Calculator')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const Text(
              'Calculate In-Hand Salary',
              style: AppTextStyles.headline,
            ),
            const SizedBox(height: 5),
            const Text(
              'Estimate your monthly and annual take-home salary.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.xl),
            _inputCard(),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate_rounded),
                label: const Text('Calculate Salary'),
              ),
            ),
            if (_result != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              SalaryResultCard(result: _result!),
              const SizedBox(height: AppSpacing.xxl),
              _loanSuggestions(_result!),
            ],
            const SizedBox(height: AppSpacing.xxl),
            const BannerAdWidget(),
            const SizedBox(height: AppSpacing.lg),
            _disclaimer(),
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
          const Text('Salary Details', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.lg),
          _field(
            controller: _grossController,
            label: 'Monthly Gross Salary',
            prefix: '₹ ',
          ),
          const SizedBox(height: AppSpacing.md),
          _field(controller: _pfController, label: 'Employee PF', suffix: '%'),
          const SizedBox(height: AppSpacing.md),
          _field(
            controller: _professionalTaxController,
            label: 'Professional Tax',
            prefix: '₹ ',
          ),
          const SizedBox(height: AppSpacing.md),
          _field(
            controller: _otherDeductionsController,
            label: 'Other Monthly Deductions',
            prefix: '₹ ',
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        suffixText: suffix,
      ),
    );
  }

  Widget _loanSuggestions(SalaryResult result) {
    final income = result.monthlyInHand;

    // Educational estimate only.
    final personalMin = income * 18;
    final personalMax = income * 24;

    final homeMin = income * 45;
    final homeMax = income * 55;

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
          const Text(
            'Smart Finance Insights',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 5),
          const Text(
            'Indicative estimates based on your in-hand salary.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.lg),
          _suggestion(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Personal Loan',
            amount: '${_money(personalMin)} – ${_money(personalMax)}',
          ),
          const SizedBox(height: AppSpacing.md),
          _suggestion(
            icon: Icons.home_outlined,
            title: 'Home Loan',
            amount: '${_money(homeMin)} – ${_money(homeMax)}',
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'These are educational estimates, not lender approval or guaranteed eligibility.',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _suggestion({
    required IconData icon,
    required String title,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Text(
        'Disclaimer: This calculator provides an indicative estimate based on the inputs entered. '
        'Actual salary, deductions, tax, PF and loan eligibility can vary based on employer policy, '
        'location, applicable laws and lender criteria.',
        style: AppTextStyles.caption,
        textAlign: TextAlign.center,
      ),
    );
  }
}
