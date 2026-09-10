import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import 'loan_eligibility_calculator.dart';
import 'loan_eligibility_model.dart';

class LoanEligibilityScreen extends StatefulWidget {
  const LoanEligibilityScreen({super.key});

  @override
  State<LoanEligibilityScreen> createState() =>
      _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState
    extends State<LoanEligibilityScreen> {
  final _incomeController =
  TextEditingController(text: '50000');

  final _emiController =
  TextEditingController(text: '5000');

  final _ageController =
  TextEditingController(text: '30');

  final _creditScoreController =
  TextEditingController(text: '750');

  EmploymentType _employmentType =
      EmploymentType.salaried;

  int _tenure = 5;

  List<LoanEligibilityResult> _results = [];

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _emiController.dispose();
    _ageController.dispose();
    _creditScoreController.dispose();
    super.dispose();
  }

  void _calculate() {
    final income =
        double.tryParse(_incomeController.text) ?? 0;

    final emi =
        double.tryParse(_emiController.text) ?? 0;

    final age =
        int.tryParse(_ageController.text) ?? 30;

    final creditScore =
        int.tryParse(_creditScoreController.text) ?? 750;

    final input = LoanEligibilityInput(
      monthlyIncome: income,
      existingEmi: emi,
      age: age,
      creditScore: creditScore,
      employmentType: _employmentType,
      tenureYears: _tenure,
    );

    setState(() {
      _results =
          LoanEligibilityCalculator.calculate(input);
    });
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    }

    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)} L';
    }

    return '₹${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Eligibility'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          children: [
            const Text(
              'Check your loan eligibility',
              style: AppTextStyles.headline,
            ),

            const SizedBox(height: AppSpacing.sm),

            const Text(
              'Get an indicative estimate based on your income, '
                  'existing EMIs and profile.',
              style: AppTextStyles.body,
            ),

            const SizedBox(height: AppSpacing.xl),

            _buildInputCard(),

            const SizedBox(height: AppSpacing.xl),

            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(
                  Icons.calculate_rounded,
                ),
                label: const Text(
                  'CHECK ELIGIBILITY',
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            if (_results.isNotEmpty) ...[
              const Text(
                'Your estimated eligibility',
                style: AppTextStyles.title,
              ),

              const SizedBox(height: AppSpacing.md),

              ..._results.map(
                _buildResultCard,
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            const BannerAdWidget(),

            const SizedBox(height: AppSpacing.lg),

            _buildDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _buildMoneyField(
            label: 'Monthly Income',
            controller: _incomeController,
            icon: Icons.currency_rupee_rounded,
          ),

          const SizedBox(height: AppSpacing.lg),

          _buildMoneyField(
            label: 'Existing Monthly EMIs',
            controller: _emiController,
            icon: Icons.credit_card_rounded,
          ),

          const SizedBox(height: AppSpacing.lg),

          const Text(
            'Employment Type',
            style: AppTextStyles.sectionTitle,
          ),

          const SizedBox(height: AppSpacing.sm),

          SegmentedButton<EmploymentType>(
            segments: const [
              ButtonSegment(
                value: EmploymentType.salaried,
                label: Text('Salaried'),
                icon: Icon(
                  Icons.work_outline_rounded,
                ),
              ),
              ButtonSegment(
                value: EmploymentType.selfEmployed,
                label: Text('Self Employed'),
                icon: Icon(
                  Icons.business_center_outlined,
                ),
              ),
            ],
            selected: {
              _employmentType,
            },
            onSelectionChanged: (selection) {
              setState(() {
                _employmentType =
                    selection.first;
              });
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          _buildNumberField(
            label: 'Age',
            controller: _ageController,
            icon: Icons.person_outline_rounded,
          ),

          const SizedBox(height: AppSpacing.lg),

          _buildNumberField(
            label: 'Credit Score',
            controller: _creditScoreController,
            icon: Icons.speed_rounded,
          ),

          const SizedBox(height: AppSpacing.lg),

          const Text(
            'Preferred Loan Tenure',
            style: AppTextStyles.sectionTitle,
          ),

          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _tenure.toDouble(),
                  min: 1,
                  max: 30,
                  divisions: 29,
                  label: '$_tenure years',
                  onChanged: (value) {
                    setState(() {
                      _tenure =
                          value.round();
                    });
                  },
                ),
              ),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  '$_tenure Y',
                  style:
                  AppTextStyles.sectionTitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoneyField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType:
      const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        prefixText: '₹ ',
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildResultCard(
      LoanEligibilityResult result,
      ) {
    final isHome =
        result.loanType == 'Home Loan';

    final isPersonal =
        result.loanType == 'Personal Loan';

    final icon = isHome
        ? Icons.home_rounded
        : isPersonal
        ? Icons.credit_card_rounded
        : result.loanType == 'Car Loan'
        ? Icons.directions_car_rounded
        : Icons.school_rounded;

    final iconColor = isHome
        ? AppColors.primary
        : isPersonal
        ? AppColors.gold
        : AppColors.silver;

    return Container(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.md,
      ),
      padding: const EdgeInsets.all(
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusLg,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.10,
              ),
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 27,
            ),
          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  result.loanType,
                  style:
                  AppTextStyles.sectionTitle,
                ),

                const SizedBox(height: 5),

                Text(
                  '${_formatAmount(result.minimumAmount)} – '
                      '${_formatAmount(result.maximumAmount)}',
                  style: AppTextStyles.price,
                ),

                const SizedBox(height: 3),

                Text(
                  result.description,
                  style:
                  AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.silverLight,
        borderRadius: BorderRadius.circular(
          AppSpacing.radiusMd,
        ),
      ),
      child: const Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'This is an indicative estimate for educational '
                  'purposes only. Actual loan eligibility, interest '
                  'rate and approval depend on the lender and your '
                  'complete financial profile.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}