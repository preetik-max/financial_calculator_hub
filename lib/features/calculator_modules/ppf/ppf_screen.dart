import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'ppf_calculator.dart';
import 'ppf_model.dart';
import 'widgets/ppf_result_card.dart';

class PpfScreen extends StatefulWidget {
  const PpfScreen({super.key});

  @override
  State<PpfScreen> createState() => _PpfScreenState();
}

class _PpfScreenState extends State<PpfScreen> {
  final TextEditingController _investmentController = TextEditingController(
    text: '150000',
  );

  final TextEditingController _rateController = TextEditingController(
    text: '7.10',
  );

  final TextEditingController _tenureController = TextEditingController(
    text: '15',
  );

  PpfResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _investmentController.dispose();
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
    final double investment = _parseDouble(_investmentController.text);
    final double rate = _parseDouble(_rateController.text);
    final int tenure = _parseInt(_tenureController.text);

    if (investment <= 0 || rate < 0 || tenure <= 0) {
      setState(() {
        _result = null;
      });
      return;
    }

    setState(() {
      _result = PpfCalculator.calculate(
        PpfInput(
          annualInvestment: investment,
          annualInterestRate: rate,
          tenureYears: tenure,
        ),
      );
    });
  }

  void _reset() {
    _investmentController.text = '150000';
    _rateController.text = '7.10';
    _tenureController.text = '15';

    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PPF Calculator'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),

                    const SizedBox(height: 20),

                    _buildInputCard(context),

                    const SizedBox(height: 20),

                    if (_result != null) PpfResultCard(result: _result!),

                    if (_result == null) _buildValidationMessage(context),

                    const SizedBox(height: 20),

                    _buildInfoCard(context),
                  ],
                ),
              ),
            ),

            // Centralized banner advertisement.
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.82),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.account_balance_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PPF Calculator',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Estimate your PPF maturity amount and interest earned.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Investment Details', style: AppTextStyles.sectionTitle),

            const SizedBox(height: 18),

            _buildMoneyField(
              controller: _investmentController,
              label: 'Annual Investment',
              hint: 'Enter annual investment',
              prefix: '₹',
              helper: 'Maximum PPF investment: ₹1,50,000 per financial year',
            ),

            const SizedBox(height: 16),

            _buildNumberField(
              controller: _rateController,
              label: 'Interest Rate',
              hint: 'Enter interest rate',
              suffix: '%',
              helper: 'Default rate: 7.10%',
            ),

            const SizedBox(height: 16),

            _buildNumberField(
              controller: _tenureController,
              label: 'Investment Period',
              hint: 'Enter years',
              suffix: 'Years',
              helper: 'Standard PPF maturity period: 15 years',
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _calculate,
                    icon: const Icon(Icons.calculate_outlined),
                    label: const Text('Calculate'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoneyField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String prefix,
    required String helper,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: '$prefix ',
        helperText: helper,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String suffix,
    required String helper,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        suffixText: suffix,
        helperText: helper,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  Widget _buildValidationMessage(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.negative.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.negative),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Please enter a valid annual investment, interest rate and tenure.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.silverLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary),

                const SizedBox(width: 8),

                Text('About PPF', style: AppTextStyles.sectionTitle),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Public Provident Fund (PPF) is a long-term savings scheme '
              'with a standard maturity period of 15 years. Interest is '
              'compounded annually and the applicable rate may be revised '
              'by the government.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),

            const SizedBox(height: 12),

            const _InfoRow(
              icon: Icons.calendar_month_outlined,
              text: 'Standard maturity period: 15 years',
            ),

            const SizedBox(height: 8),

            const _InfoRow(
              icon: Icons.currency_rupee_rounded,
              text: 'Maximum annual contribution: ₹1.50 lakh',
            ),

            const SizedBox(height: 8),

            const _InfoRow(
              icon: Icons.trending_up_rounded,
              text: 'Interest is compounded annually',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
