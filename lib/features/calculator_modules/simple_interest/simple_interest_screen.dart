import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'simple_interest_calculator.dart';
import 'simple_interest_model.dart';
import 'widgets/simple_interest_result_card.dart';

class SimpleInterestScreen extends StatefulWidget {
  const SimpleInterestScreen({super.key});

  @override
  State<SimpleInterestScreen> createState() => _SimpleInterestScreenState();
}

class _SimpleInterestScreenState extends State<SimpleInterestScreen> {
  final _principalController = TextEditingController(text: '100000');

  final _rateController = TextEditingController(text: '8');

  final _timeController = TextEditingController(text: '5');

  SimpleInterestResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  double _parse(TextEditingController controller) {
    return double.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;
  }

  void _calculate() {
    final input = SimpleInterestInput(
      principal: _parse(_principalController),
      annualRate: _parse(_rateController),
      timeYears: _parse(_timeController),
    );

    setState(() {
      _result = SimpleInterestCalculator.calculate(input);
    });
  }

  void _reset() {
    _principalController.text = '100000';
    _rateController.text = '8';
    _timeController.text = '5';

    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    // AppTextStyles uses static styles.

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Simple Interest Calculator'),
        elevation: 0,
      ),
      bottomNavigationBar: const BannerAdWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Simple Interest', style: AppTextStyles.headline),
              const SizedBox(height: 6),
              Text(
                'Calculate interest and maturity amount easily.',
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 20),

              _InputCard(
                principalController: _principalController,
                rateController: _rateController,
                timeController: _timeController,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _reset,
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _calculate,
                      child: const Text('Calculate'),
                    ),
                  ),
                ],
              ),

              if (_result != null) ...[
                const SizedBox(height: 20),
                SimpleInterestResultCard(result: _result!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final TextEditingController principalController;
  final TextEditingController rateController;
  final TextEditingController timeController;

  const _InputCard({
    required this.principalController,
    required this.rateController,
    required this.timeController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _AmountField(
              controller: principalController,
              label: 'Principal Amount',
              prefix: '₹ ',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),

            _AmountField(
              controller: rateController,
              label: 'Annual Interest Rate',
              suffix: ' %',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),

            _AmountField(
              controller: timeController,
              label: 'Time Period',
              suffix: ' years',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Formula: Simple Interest = (Principal × Rate × Time) ÷ 100',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? prefix;
  final String? suffix;
  final TextInputType keyboardType;

  const _AmountField({
    required this.controller,
    required this.label,
    required this.keyboardType,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: (_) {},
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
