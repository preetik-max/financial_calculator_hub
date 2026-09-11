import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ads/banner_ad_widget.dart';
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
  // ---------------------------------------------------------------------------
  // Controllers
  // ---------------------------------------------------------------------------

  final TextEditingController _incomeController = TextEditingController(
    text: '50000',
  );

  final TextEditingController _emiController = TextEditingController(text: '0');

  final TextEditingController _ageController = TextEditingController(
    text: '30',
  );

  final TextEditingController _creditScoreController = TextEditingController(
    text: '750',
  );

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  EmploymentType _employmentType = EmploymentType.salaried;

  int _tenure = 5;

  List<LoanEligibilityResult> _results = [];

  double _availableEmi = 0.0;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _calculate();
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _emiController.dispose();
    _ageController.dispose();
    _creditScoreController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Calculation
  // ---------------------------------------------------------------------------

  void _calculate() {
    FocusScope.of(context).unfocus();

    final double? income = double.tryParse(_incomeController.text.trim());

    final double? emi = double.tryParse(_emiController.text.trim());

    final int? age = int.tryParse(_ageController.text.trim());

    final int? creditScore = int.tryParse(_creditScoreController.text.trim());

    // -------------------------------------------------------------------------
    // Validation
    // -------------------------------------------------------------------------

    if (income == null || income <= 0) {
      _showError('Please enter a valid monthly income.');
      return;
    }

    if (emi == null || emi < 0) {
      _showError('Existing EMI cannot be negative.');
      return;
    }

    if (emi > income) {
      _showError('Existing EMI cannot be greater than your monthly income.');
      return;
    }

    if (age == null || age < 18 || age > 70) {
      _showError('Age must be between 18 and 70 years.');
      return;
    }

    if (creditScore == null || creditScore < 300 || creditScore > 900) {
      _showError('Credit score must be between 300 and 900.');
      return;
    }

    // -------------------------------------------------------------------------
    // Input
    // -------------------------------------------------------------------------

    final LoanEligibilityInput input = LoanEligibilityInput(
      monthlyIncome: income,
      existingEmi: emi,
      age: age,
      creditScore: creditScore,
      employmentType: _employmentType,
      tenureYears: _tenure,
    );

    // -------------------------------------------------------------------------
    // Calculate loan results
    // -------------------------------------------------------------------------

    final List<LoanEligibilityResult> results =
        LoanEligibilityCalculator.calculate(input);

    // -------------------------------------------------------------------------
    // Calculate indicative EMI capacity
    // -------------------------------------------------------------------------

    double foir;

    if (creditScore >= 750) {
      foir = 0.50;
    } else if (creditScore >= 700) {
      foir = 0.45;
    } else if (creditScore >= 650) {
      foir = 0.40;
    } else {
      foir = 0.35;
    }

    if (_employmentType == EmploymentType.selfEmployed) {
      foir -= 0.05;
    }

    foir = foir.clamp(0.30, 0.50);

    final double maximumTotalEmi = income * foir;

    final double availableEmi = math.max(0.0, maximumTotalEmi - emi);

    setState(() {
      _results = results;
      _availableEmi = availableEmi;
    });
  }

  // ---------------------------------------------------------------------------
  // WhatsApp Advisor
  // ---------------------------------------------------------------------------

  Future<void> _openWhatsAppAdvisor() async {
    const String phoneNumber = '918318950758';

    final String income = _incomeController.text.trim();

    final String existingEmi = _emiController.text.trim();

    final String age = _ageController.text.trim();

    final String creditScore = _creditScoreController.text.trim();

    final String employment = _employmentType == EmploymentType.salaried
        ? 'Salaried'
        : 'Self Employed';

    final String tenure = '$_tenure years';

    // -------------------------------------------------------------------------
    // Build eligibility results for WhatsApp
    // -------------------------------------------------------------------------

    final String resultMessage = _results.isEmpty
        ? 'Eligibility calculation has not been completed yet.'
        : _results
              .map(
                (result) =>
                    '${result.loanType}: '
                    '${_formatAmount(result.minimumAmount)}'
                    ' - '
                    '${_formatAmount(result.maximumAmount)}',
              )
              .join('\n');

    // -------------------------------------------------------------------------
    // Lead message
    // -------------------------------------------------------------------------

    final String message =
        '''
Hello, I need help with my loan eligibility.

I used the Finora Financial Calculator and would like personalised guidance.

MY PROFILE
--------------------
Monthly Income: ₹$income
Existing Monthly EMI: ₹$existingEmi
Employment Type: $employment
Age: $age
Credit Score: $creditScore
Preferred Loan Tenure: $tenure

EMI CAPACITY
--------------------
Available EMI Capacity: ${_formatAmount(_availableEmi)}

ESTIMATED ELIGIBILITY
--------------------
$resultMessage

I would like guidance on:

• Suitable loan options
• Interest rate / ROI comparison
• Improving my loan eligibility
• Improving my credit profile
• Understanding which loan option may suit me

Please guide me on the available options.

Thank you.
''';

    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: '/$phoneNumber',
      queryParameters: {'text': message},
    );

    try {
      final bool launched = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        _showError('Unable to open WhatsApp. Please try again.');
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showError('Unable to open WhatsApp. Please try again.');
    }
  }

  // ---------------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------------

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // ---------------------------------------------------------------------------
  // Amount formatting
  // ---------------------------------------------------------------------------

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    }

    if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)} L';
    }

    if (amount >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(1)}K';
    }

    return '₹${amount.toStringAsFixed(0)}';
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Eligibility')),

      // -----------------------------------------------------------------------
      // Floating WhatsApp chatbot
      // -----------------------------------------------------------------------
      floatingActionButton: FloatingActionButton(
        onPressed: _openWhatsAppAdvisor,
        tooltip: 'Chat with Financial Advisor',
        backgroundColor: const Color(0xFF168A4A),
        foregroundColor: Colors.white,
        elevation: 6,
        child: const Icon(Icons.chat_rounded, size: 28),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            // -----------------------------------------------------------------
            // Header
            // -----------------------------------------------------------------
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

            // -----------------------------------------------------------------
            // Input card
            // -----------------------------------------------------------------
            _buildInputCard(),

            const SizedBox(height: AppSpacing.xl),

            // -----------------------------------------------------------------
            // Calculate button
            // -----------------------------------------------------------------
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _calculate,
                icon: const Icon(Icons.calculate_rounded),
                label: const Text('CHECK ELIGIBILITY'),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // -----------------------------------------------------------------
            // Results
            // -----------------------------------------------------------------
            if (_results.isNotEmpty) ...[
              _buildEmiCapacityCard(),

              const SizedBox(height: AppSpacing.xl),

              const Text(
                'Your estimated eligibility',
                style: AppTextStyles.title,
              ),

              const SizedBox(height: AppSpacing.md),

              ..._results.map(_buildResultCard),
            ],

            const SizedBox(height: AppSpacing.xl),

            // -----------------------------------------------------------------
            // Banner
            // -----------------------------------------------------------------
            const BannerAdWidget(),

            const SizedBox(height: AppSpacing.lg),

            // -----------------------------------------------------------------
            // Disclaimer
            // -----------------------------------------------------------------
            _buildDisclaimer(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Input card
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
          // Monthly income
          _buildMoneyField(
            label: 'Monthly Income',
            controller: _incomeController,
            icon: Icons.currency_rupee_rounded,
            hint: 'e.g. 75000',
          ),

          const SizedBox(height: AppSpacing.lg),

          // Existing EMI
          _buildMoneyField(
            label: 'Existing Monthly EMIs',
            controller: _emiController,
            icon: Icons.credit_card_rounded,
            hint: 'e.g. 0',
          ),

          const SizedBox(height: AppSpacing.lg),

          // Employment
          const Text('Employment Type', style: AppTextStyles.sectionTitle),

          const SizedBox(height: AppSpacing.sm),

          SizedBox(
            width: double.infinity,
            child: SegmentedButton<EmploymentType>(
              segments: const [
                ButtonSegment<EmploymentType>(
                  value: EmploymentType.salaried,
                  label: Text('Salaried'),
                  icon: Icon(Icons.work_outline_rounded),
                ),
                ButtonSegment<EmploymentType>(
                  value: EmploymentType.selfEmployed,
                  label: Text('Self Employed'),
                  icon: Icon(Icons.business_center_outlined),
                ),
              ],
              selected: {_employmentType},
              onSelectionChanged: (Set<EmploymentType> selection) {
                if (selection.isEmpty) {
                  return;
                }

                setState(() {
                  _employmentType = selection.first;
                });
              },
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Age
          _buildNumberField(
            label: 'Age',
            controller: _ageController,
            icon: Icons.person_outline_rounded,
            hint: '18 - 70',
          ),

          const SizedBox(height: AppSpacing.lg),

          // Credit score
          _buildNumberField(
            label: 'Credit Score',
            controller: _creditScoreController,
            icon: Icons.speed_rounded,
            hint: '300 - 900',
          ),

          const SizedBox(height: AppSpacing.lg),

          // Tenure
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
                  onChanged: (double value) {
                    setState(() {
                      _tenure = value.round();
                    });
                  },
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              SizedBox(
                width: 60,
                child: Text(
                  '$_tenure Y',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.sectionTitle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Money field
  // ---------------------------------------------------------------------------

  Widget _buildMoneyField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        prefixText: '₹ ',
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Number field
  // ---------------------------------------------------------------------------

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // EMI capacity
  // ---------------------------------------------------------------------------

  Widget _buildEmiCapacityCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F67A5), Color(0xFF344A82)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available EMI Capacity',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatAmount(_availableEmi),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'Indicative maximum additional EMI',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Result card
  // ---------------------------------------------------------------------------

  Widget _buildResultCard(LoanEligibilityResult result) {
    final bool isHome = result.loanType == 'Home Loan';

    final bool isPersonal = result.loanType == 'Personal Loan';

    final bool isCar = result.loanType == 'Car Loan';

    final IconData icon = isHome
        ? Icons.home_rounded
        : isPersonal
        ? Icons.credit_card_rounded
        : isCar
        ? Icons.directions_car_rounded
        : Icons.school_rounded;

    final Color iconColor = isHome
        ? AppColors.primary
        : isPersonal
        ? AppColors.gold
        : AppColors.silver;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 27),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.loanType, style: AppTextStyles.sectionTitle),

                const SizedBox(height: 5),

                Text(
                  '${_formatAmount(result.minimumAmount)}'
                  ' – '
                  '${_formatAmount(result.maximumAmount)}',
                  style: AppTextStyles.price,
                ),

                const SizedBox(height: 5),

                Text(result.description, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Disclaimer
  // ---------------------------------------------------------------------------

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.silverLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: AppColors.textSecondary,
          ),

          SizedBox(width: 8),

          Expanded(
            child: Text(
              'This calculator provides an indicative estimate '
              'for financial planning only. Actual loan eligibility, '
              'interest rate and approved amount depend on the lender, '
              'income verification, credit profile, existing obligations '
              'and other applicable factors.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}
