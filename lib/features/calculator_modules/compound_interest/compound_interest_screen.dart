import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'compound_interest_calculator.dart';
import 'compound_interest_model.dart';
import 'widgets/compound_interest_result_card.dart';

class CompoundInterestScreen extends StatefulWidget {
  const CompoundInterestScreen({super.key});

  @override
  State<CompoundInterestScreen> createState() => _CompoundInterestScreenState();
}

class _CompoundInterestScreenState extends State<CompoundInterestScreen> {
  final TextEditingController _principalController = TextEditingController(
    text: '100000',
  );

  final TextEditingController _rateController = TextEditingController(
    text: '8',
  );

  final TextEditingController _timeController = TextEditingController(
    text: '5',
  );

  CompoundingFrequency _frequency = CompoundingFrequency.yearly;

  CompoundInterestResult _result = CompoundInterestCalculator.calculate(
    const CompoundInterestInput(
      principal: 100000,
      annualRate: 8,
      timeYears: 5,
      frequency: CompoundingFrequency.yearly,
    ),
  );

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
    final input = CompoundInterestInput(
      principal: _parse(_principalController),
      annualRate: _parse(_rateController),
      timeYears: _parse(_timeController),
      frequency: _frequency,
    );

    setState(() {
      _result = CompoundInterestCalculator.calculate(input);
    });
  }

  void _reset() {
    _principalController.text = '100000';
    _rateController.text = '8';
    _timeController.text = '5';

    setState(() {
      _frequency = CompoundingFrequency.yearly;
    });

    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Compound Interest', style: AppTextStyles.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Compound Interest Calculator',
                      style: AppTextStyles.headline,
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'Calculate compound interest and maturity amount.',
                      style: AppTextStyles.body,
                    ),

                    const SizedBox(height: 20),

                    _InputCard(
                      controller: _principalController,
                      label: 'Principal Amount',
                      prefix: '₹ ',
                    ),

                    const SizedBox(height: 14),

                    _InputCard(
                      controller: _rateController,
                      label: 'Annual Interest Rate',
                      suffix: ' %',
                    ),

                    const SizedBox(height: 14),

                    _InputCard(
                      controller: _timeController,
                      label: 'Time Period',
                      suffix: ' years',
                    ),

                    const SizedBox(height: 18),

                    _FrequencyCard(
                      frequency: _frequency,
                      onChanged: (value) {
                        setState(() {
                          _frequency = value;
                        });

                        _calculate();
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _reset,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            child: const Text('Reset'),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _calculate,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              'Calculate',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    CompoundInterestResultCard(result: _result),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Formula', style: AppTextStyles.sectionTitle),
                          SizedBox(height: 10),
                          Text(
                            'A = P × (1 + R/n)ⁿᵗ',
                            style: AppTextStyles.body,
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Compound Interest = A − P',
                            style: AppTextStyles.body,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'P = Principal, R = Annual Rate, '
                            'n = Compounding Frequency, '
                            't = Time in Years',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Centralized AdMob banner.
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? prefix;
  final String? suffix;

  const _InputCard({
    required this.controller,
    required this.label,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
        style: AppTextStyles.title,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.caption,
          prefixText: prefix,
          suffixText: suffix,
          prefixStyle: AppTextStyles.body,
          suffixStyle: AppTextStyles.body,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  final CompoundingFrequency frequency;
  final ValueChanged<CompoundingFrequency> onChanged;

  const _FrequencyCard({required this.frequency, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Compounding Frequency',
            style: AppTextStyles.sectionTitle,
          ),

          const SizedBox(height: 12),

          DropdownButtonFormField<CompoundingFrequency>(
            initialValue: frequency,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
            ),
            items: CompoundingFrequency.values
                .map(
                  (item) => DropdownMenuItem<CompoundingFrequency>(
                    value: item,
                    child: Text(
                      item.label,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
