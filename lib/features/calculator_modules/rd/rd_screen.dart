import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import 'rd_calculator.dart';
import 'rd_model.dart';
import 'widgets/rd_result_card.dart';

class RdScreen extends StatefulWidget {
  const RdScreen({super.key});

  @override
  State<RdScreen> createState() => _RdScreenState();
}

class _RdScreenState extends State<RdScreen> {
  final TextEditingController _monthlyController = TextEditingController(
    text: '5000',
  );

  final TextEditingController _rateController = TextEditingController(
    text: '7',
  );

  final TextEditingController _tenureController = TextEditingController(
    text: '5',
  );

  RdResult? _result;

  @override
  void initState() {
    super.initState();

    _calculate();
  }

  @override
  void dispose() {
    _monthlyController.dispose();
    _rateController.dispose();
    _tenureController.dispose();

    super.dispose();
  }

  void _calculate() {
    final double? monthly = double.tryParse(_monthlyController.text.trim());

    final double? rate = double.tryParse(_rateController.text.trim());

    final int? years = int.tryParse(_tenureController.text.trim());

    if (monthly == null ||
        rate == null ||
        years == null ||
        monthly <= 0 ||
        rate < 0 ||
        years <= 0) {
      setState(() {
        _result = null;
      });

      return;
    }

    final RdInput input = RdInput(
      monthlyDeposit: monthly,
      annualInterestRate: rate,
      tenureYears: years,
    );

    setState(() {
      _result = RdCalculator.calculate(input);
    });
  }

  void _reset() {
    _monthlyController.text = '5000';
    _rateController.text = '7';
    _tenureController.text = '5';

    _calculate();
  }

  String? _validateMonthly(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter monthly deposit';
    }

    final double? amount = double.tryParse(value);

    if (amount == null || amount <= 0) {
      return 'Enter a valid amount';
    }

    return null;
  }

  String? _validateRate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter interest rate';
    }

    final double? rate = double.tryParse(value);

    if (rate == null || rate < 0 || rate > 30) {
      return 'Enter rate between 0% and 30%';
    }

    return null;
  }

  String? _validateTenure(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter tenure';
    }

    final int? years = int.tryParse(value);

    if (years == null || years < 1 || years > 30) {
      return 'Enter tenure between 1 and 30 years';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('RD Calculator'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const Text(
                'Recurring Deposit Calculator',
                style: AppTextStyles.headline,
              ),
              const SizedBox(height: 6),
              const Text(
                'Calculate your RD maturity amount and interest',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: AppSpacing.xl),

              _buildInputCard(),

              const SizedBox(height: AppSpacing.lg),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _calculate,
                  child: const Text('Calculate RD'),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ),

              if (_result != null) ...[
                const SizedBox(height: AppSpacing.xxl),
                RdResultCard(result: _result!),
              ],

              const SizedBox(height: AppSpacing.xxl),

              // Centralized AdMob implementation.
              const BannerAdWidget(),

              const SizedBox(height: AppSpacing.lg),

              _buildDisclaimer(),
            ],
          ),
        ),
      ),
    );
  }

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
          const Text('Investment Details', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: _monthlyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Monthly Deposit',
              prefixText: '₹ ',
              hintText: 'e.g. 5000',
            ),
            onChanged: (_) {
              setState(() {});
            },
            validator: _validateMonthly,
          ),

          const SizedBox(height: AppSpacing.md),

          TextFormField(
            controller: _rateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Annual Interest Rate',
              suffixText: '% p.a.',
              hintText: 'e.g. 7',
            ),
            onChanged: (_) {
              setState(() {});
            },
            validator: _validateRate,
          ),

          const SizedBox(height: AppSpacing.md),

          TextFormField(
            controller: _tenureController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Tenure',
              suffixText: 'years',
              hintText: 'e.g. 5',
            ),
            onChanged: (_) {
              setState(() {});
            },
            validator: _validateTenure,
            onFieldSubmitted: (_) {
              _calculate();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'Disclaimer: This calculator provides an indicative estimate. '
        'Actual RD maturity may vary depending on the bank, compounding '
        'method, deposit dates, applicable taxes, and other terms.',
        style: AppTextStyles.caption,
      ),
    );
  }
}
