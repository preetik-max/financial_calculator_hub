import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/lead/lead_contact_button.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import 'loan_eligibility_calculator.dart';
import 'loan_eligibility_model.dart';

class LoanEligibilityScreen extends StatefulWidget {
  const LoanEligibilityScreen({super.key});

  @override
  State<LoanEligibilityScreen> createState() => _LoanEligibilityScreenState();
}

class _LoanEligibilityScreenState extends State<LoanEligibilityScreen> {
  final TextEditingController _incomeController = TextEditingController();

  final TextEditingController _emiController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _creditScoreController = TextEditingController();

  EmploymentType _employmentType = EmploymentType.salaried;

  int _tenure = 20;

  List<LoanEligibilityResult> _results = [];

  @override
  void dispose() {
    _incomeController.dispose();
    _emiController.dispose();
    _ageController.dispose();
    _creditScoreController.dispose();
    super.dispose();
  }

  double _parseAmount(String value) {
    return double.tryParse(
          value.replaceAll(',', '').replaceAll('₹', '').trim(),
        ) ??
        0;
  }

  String _formatAmount(double amount) {
    if (amount <= 0) {
      return '₹0';
    }

    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    }

    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    }

    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }

    return '₹${amount.round()}';
  }

  void _calculate() {
    final double monthlyIncome = _parseAmount(_incomeController.text);

    final double existingEmi = _parseAmount(_emiController.text);

    final int age = int.tryParse(_ageController.text.trim()) ?? 0;

    final int creditScore =
        int.tryParse(_creditScoreController.text.trim()) ?? 0;

    if (monthlyIncome <= 0) {
      _showError('Please enter your monthly income.');
      return;
    }

    if (age <= 0) {
      _showError('Please enter your age.');
      return;
    }

    if (creditScore <= 0) {
      _showError('Please enter your credit score.');
      return;
    }

    final LoanEligibilityInput input = LoanEligibilityInput(
      monthlyIncome: monthlyIncome,
      existingEmi: existingEmi,
      age: age,
      creditScore: creditScore,
      employmentType: _employmentType,
      tenureYears: _tenure,
    );

    final List<LoanEligibilityResult> results =
        LoanEligibilityCalculator.calculate(input);

    setState(() {
      _results = results;
    });
  }

  String _buildWhatsAppMessage() {
    final String income = _incomeController.text.trim();

    final String existingEmi = _emiController.text.trim();

    final String age = _ageController.text.trim();

    final String creditScore = _creditScoreController.text.trim();

    final String employment = _employmentType == EmploymentType.salaried
        ? 'Salaried'
        : 'Self Employed';

    final String eligibilityText = _results.isEmpty
        ? 'I have not calculated my eligibility yet.'
        : _results
              .map(
                (result) =>
                    '${result.loanType}: '
                    '${_formatAmount(result.minimumAmount)} '
                    'to '
                    '${_formatAmount(result.maximumAmount)}',
              )
              .join('\n');

    return '''
Hello, I need help with my loan eligibility.

I used the Finora Financial Calculator and would like personalised guidance.

MY PROFILE
--------------------
Monthly Income: ₹$income
Existing Monthly EMI: ₹$existingEmi
Employment Type: $employment
Age: $age
Credit Score: $creditScore
Preferred Loan Tenure: $_tenure years

ESTIMATED ELIGIBILITY
--------------------
$eligibilityText

I would like guidance on:

• Suitable loan options
• Interest rate comparison
• Improving my loan eligibility
• Improving my credit profile
• Understanding suitable loan options

Please guide me on the available options.

Thank you.
''';
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildEmploymentSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Employment Type', style: AppTextStyles.sectionTitle),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<EmploymentType>(
          segments: const [
            ButtonSegment<EmploymentType>(
              value: EmploymentType.salaried,
              label: Text('Salaried'),
              icon: Icon(Icons.badge_outlined),
            ),
            ButtonSegment<EmploymentType>(
              value: EmploymentType.selfEmployed,
              label: Text('Self Employed'),
              icon: Icon(Icons.business_center_outlined),
            ),
          ],
          selected: <EmploymentType>{_employmentType},
          onSelectionChanged: (Set<EmploymentType> selection) {
            setState(() {
              _employmentType = selection.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTenureSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Loan Tenure', style: AppTextStyles.sectionTitle),
            Text('$_tenure years', style: AppTextStyles.title),
          ],
        ),
        Slider(
          value: _tenure.toDouble(),
          min: 1,
          max: 30,
          divisions: 29,
          label: '$_tenure years',
          onChanged: (double value) {
            setState(() {
              _tenure = value.round();
            });
          },
        ),
      ],
    );
  }

  Widget _buildResultCard(LoanEligibilityResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    result.loanType,
                    style: AppTextStyles.sectionTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              result.maximumAmount > 0
                  ? '${_formatAmount(result.minimumAmount)} - '
                        '${_formatAmount(result.maximumAmount)}'
                  : 'Not eligible',
              style: AppTextStyles.price,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(result.description, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Eligibility Result', style: AppTextStyles.title),
        const SizedBox(height: AppSpacing.sm),
        ..._results.map(_buildResultCard),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Eligibility')),

      // ---------------------------------------------------------
      // CENTRALIZED WHATSAPP LEAD BUTTON
      // ---------------------------------------------------------
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: LeadContactButton(
        message: _buildWhatsAppMessage(),
        tooltip: 'Chat with Financial Advisor',
        onError: () {
          _showError('Unable to open WhatsApp. Please try again.');
        },
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Check Loan Eligibility',
                style: AppTextStyles.headline,
              ),

              const SizedBox(height: AppSpacing.xs),

              const Text(
                'Estimate how much loan you may be eligible for based on your income and profile.',
                style: AppTextStyles.body,
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildTextField(
                controller: _incomeController,
                label: 'Monthly Income',
                hint: 'Example: 75000',
                icon: Icons.currency_rupee,
              ),

              const SizedBox(height: AppSpacing.md),

              _buildTextField(
                controller: _emiController,
                label: 'Existing Monthly EMI',
                hint: 'Example: 10000',
                icon: Icons.payments_outlined,
              ),

              const SizedBox(height: AppSpacing.md),

              _buildEmploymentSelector(),

              const SizedBox(height: AppSpacing.md),

              _buildTextField(
                controller: _ageController,
                label: 'Age',
                hint: 'Example: 30',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: AppSpacing.md),

              _buildTextField(
                controller: _creditScoreController,
                label: 'Credit Score',
                hint: 'Example: 750',
                icon: Icons.credit_score_outlined,
              ),

              const SizedBox(height: AppSpacing.md),

              _buildTenureSelector(),

              const SizedBox(height: AppSpacing.md),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _calculate,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Calculate Eligibility'),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildResults(),

              const SizedBox(height: AppSpacing.lg),

              // Centralized banner ad.
              const BannerAdWidget(),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
