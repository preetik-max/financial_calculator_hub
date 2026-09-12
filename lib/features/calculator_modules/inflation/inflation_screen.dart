import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import 'inflation_calculator.dart';
import 'inflation_model.dart';
import 'widgets/inflation_result_card.dart';

class InflationScreen extends StatefulWidget {
  const InflationScreen({super.key});

  @override
  State<InflationScreen> createState() => _InflationScreenState();
}

class _InflationScreenState extends State<InflationScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: '100000',
  );

  final TextEditingController _rateController = TextEditingController(
    text: '6',
  );

  final TextEditingController _yearsController = TextEditingController(
    text: '10',
  );

  InflationResult? _result;

  @override
  void initState() {
    super.initState();

    _calculate();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _yearsController.dispose();
    super.dispose();
  }

  double _parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }

  int _parseInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }

  void _calculate() {
    final double amount = _parseDouble(_amountController.text);
    final double rate = _parseDouble(_rateController.text);
    final int years = _parseInt(_yearsController.text);

    if (amount <= 0 || years <= 0) {
      setState(() {
        _result = null;
      });
      return;
    }

    final InflationInput input = InflationInput(
      currentAmount: amount,
      inflationRate: rate < 0 ? 0 : rate,
      years: years,
    );

    setState(() {
      _result = InflationCalculator.calculate(input);
    });
  }

  void _reset() {
    _amountController.text = '100000';
    _rateController.text = '6';
    _yearsController.text = '10';

    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        title: Text('Inflation Calculator', style: AppTextStyles.title),
        actions: [
          IconButton(
            tooltip: 'Reset',
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Inflation Calculator', style: AppTextStyles.headline),

                    const SizedBox(height: 6),

                    Text(
                      'See how inflation can affect the future cost '
                      'of money.',
                      style: AppTextStyles.body,
                    ),

                    const SizedBox(height: 22),

                    _InputCard(
                      amountController: _amountController,
                      rateController: _rateController,
                      yearsController: _yearsController,
                      onChanged: _calculate,
                    ),

                    const SizedBox(height: 18),

                    if (_result != null)
                      InflationResultCard(result: _result!)
                    else
                      _EmptyResultCard(),

                    const SizedBox(height: 18),

                    _FormulaCard(),

                    const SizedBox(height: 18),

                    Text('Example', style: AppTextStyles.sectionTitle),

                    const SizedBox(height: 8),

                    Text(
                      'If something costs ₹1,00,000 today and inflation '
                      'averages 6% for 10 years, its estimated future '
                      'cost will be around ₹1,79,085.',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
            ),

            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final TextEditingController amountController;
  final TextEditingController rateController;
  final TextEditingController yearsController;
  final VoidCallback onChanged;

  const _InputCard({
    required this.amountController,
    required this.rateController,
    required this.yearsController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.border.withOpacity(0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Details', style: AppTextStyles.sectionTitle),

            const SizedBox(height: 18),

            _CurrencyField(
              controller: amountController,
              label: 'Current Amount',
              hint: 'e.g. 100000',
              icon: Icons.currency_rupee_rounded,
              onChanged: onChanged,
            ),

            const SizedBox(height: 16),

            _NumberField(
              controller: rateController,
              label: 'Inflation Rate',
              hint: 'e.g. 6',
              suffix: '%',
              icon: Icons.trending_up_rounded,
              onChanged: onChanged,
            ),

            const SizedBox(height: 16),

            _NumberField(
              controller: yearsController,
              label: 'Time Period',
              hint: 'e.g. 10',
              suffix: 'Years',
              icon: Icons.calendar_month_outlined,
              onChanged: onChanged,
              integerOnly: true,
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onChanged,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Calculate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrencyField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final VoidCallback onChanged;

  const _CurrencyField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        prefixText: '₹ ',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String suffix;
  final IconData icon;
  final VoidCallback onChanged;
  final bool integerOnly;

  const _NumberField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.suffix,
    required this.icon,
    required this.onChanged,
    this.integerOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !integerOnly),
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _FormulaCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Formula', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Text(
            'Future Cost = Current Amount × '
            '(1 + Inflation Rate / 100)ⁿ',
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text('n = number of years', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _EmptyResultCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.7)),
      ),
      child: Column(
        children: [
          Icon(Icons.calculate_outlined, size: 42, color: AppColors.textMuted),
          const SizedBox(height: 10),
          Text('Enter valid values', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 4),
          Text(
            'Enter an amount and time period to see the result.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
