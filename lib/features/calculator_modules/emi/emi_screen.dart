import 'package:flutter/material.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'emi_calculator.dart';
import 'emi_model.dart';
import 'widgets/emi_result_card.dart';

class EmiScreen extends StatefulWidget {
  const EmiScreen({super.key});

  @override
  State<EmiScreen> createState() => _EmiScreenState();
}

class _EmiScreenState extends State<EmiScreen> {
  final TextEditingController _loanAmountController = TextEditingController(
    text: '1000000',
  );

  final TextEditingController _interestRateController = TextEditingController(
    text: '8.5',
  );

  final TextEditingController _tenureController = TextEditingController(
    text: '20',
  );

  EmiResult? _result;

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

  // ---------------------------------------------------------------------------
  // CALCULATE
  // ---------------------------------------------------------------------------

  void _calculate() {
    final double loanAmount =
        double.tryParse(
          _loanAmountController.text.replaceAll(',', '').trim(),
        ) ??
        0;

    final double interestRate =
        double.tryParse(_interestRateController.text.trim()) ?? 0;

    final int tenure = int.tryParse(_tenureController.text.trim()) ?? 0;

    if (loanAmount <= 0 || interestRate < 0 || tenure <= 0) {
      setState(() {
        _result = null;
      });
      return;
    }

    final EmiInput input = EmiInput(
      loanAmount: loanAmount,
      annualInterestRate: interestRate,
      tenureYears: tenure,
    );

    final EmiResult result = EmiCalculator.calculate(input);

    setState(() {
      _result = result;
    });
  }

  // ---------------------------------------------------------------------------
  // RESET
  // ---------------------------------------------------------------------------

  void _reset() {
    _loanAmountController.text = '1000000';
    _interestRateController.text = '8.5';
    _tenureController.text = '20';

    _calculate();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMI Calculator'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Reset',
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildHeader(),

            const SizedBox(height: AppSpacing.xl),

            _buildInputCard(),

            const SizedBox(height: AppSpacing.lg),

            if (_result != null)
              EmiResultCard(result: _result!)
            else
              _buildEmptyResult(),

            const SizedBox(height: AppSpacing.lg),

            _buildDisclaimer(),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Plan your loan repayment',
                  style: AppTextStyles.sectionTitle,
                ),

                const SizedBox(height: 6),

                Text(
                  'Calculate your monthly EMI, total interest and total repayment amount.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INPUT CARD
  // ---------------------------------------------------------------------------

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
          const Text('Loan Details', style: AppTextStyles.sectionTitle),

          const SizedBox(height: AppSpacing.lg),

          // Loan amount
          TextField(
            controller: _loanAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            textInputAction: TextInputAction.next,
            onChanged: (_) => _calculate(),
            decoration: const InputDecoration(
              labelText: 'Loan Amount',
              hintText: 'Enter loan amount',
              prefixText: '₹ ',
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: _interestRateController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (_) => _calculate(),
                  decoration: const InputDecoration(
                    labelText: 'Interest Rate',
                    hintText: '8.5',
                    suffixText: '%',
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: TextField(
                  controller: _tenureController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => _calculate(),
                  decoration: const InputDecoration(
                    labelText: 'Loan Tenure',
                    hintText: '20',
                    suffixText: 'Years',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate_rounded),
              label: const Text(
                'Calculate EMI',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY RESULT
  // ---------------------------------------------------------------------------

  Widget _buildEmptyResult() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calculate_outlined,
            size: 42,
            color: AppColors.textSecondary,
          ),

          const SizedBox(height: AppSpacing.md),

          const Text(
            'Enter valid loan details',
            style: AppTextStyles.sectionTitle,
          ),

          const SizedBox(height: 6),

          Text(
            'Enter the loan amount, interest rate and tenure to calculate your EMI.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DISCLAIMER
  // ---------------------------------------------------------------------------

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: Text(
              'This calculator provides an estimate. Actual EMI may vary '
              'depending on the lender, interest rate, processing fees, '
              'insurance and other loan terms.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
