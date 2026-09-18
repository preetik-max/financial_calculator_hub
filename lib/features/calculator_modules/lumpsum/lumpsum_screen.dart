import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import 'lumpsum_calculator.dart';
import 'lumpsum_model.dart';
import 'widgets/lumpsum_result_card.dart';

class LumpsumScreen extends StatefulWidget {
  const LumpsumScreen({super.key});

  @override
  State<LumpsumScreen> createState() => _LumpsumScreenState();
}

class _LumpsumScreenState extends State<LumpsumScreen> {
  final TextEditingController _investmentController = TextEditingController(
    text: '100000',
  );

  final TextEditingController _returnController = TextEditingController(
    text: '12',
  );

  int _investmentPeriod = 10;

  LumpsumResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _investmentController.dispose();
    _returnController.dispose();
    super.dispose();
  }

  double _parseNumber(String value) {
    final cleaned = value.replaceAll(',', '').replaceAll('₹', '').trim();
    return double.tryParse(cleaned) ?? 0;
  }

  void _calculate() {
    final double investment = _parseNumber(_investmentController.text);
    final double annualReturn = _parseNumber(_returnController.text);

    final result = LumpsumCalculator.calculate(
      LumpsumInput(
        investmentAmount: investment,
        annualReturnRate: annualReturn,
        investmentPeriodYears: _investmentPeriod,
      ),
    );

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Lumpsum Calculator'),
      ),

      // ============================================================
      // ADMOB BANNER
      // ============================================================
      bottomNavigationBar: const SafeArea(top: false, child: BannerAdWidget()),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _investmentCard(),

            const SizedBox(height: AppSpacing.xl),

            if (_result != null) LumpsumResultCard(result: _result!),

            const SizedBox(height: AppSpacing.xl),

            _disclaimer(),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _investmentCard() {
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

          TextField(
            controller: _investmentController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Initial Investment',
              prefixText: '₹ ',
              prefixIcon: Icon(Icons.account_balance_wallet_outlined),
            ),
            onChanged: (_) => _calculate(),
          ),

          const SizedBox(height: AppSpacing.md),

          TextField(
            controller: _returnController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Expected Return Rate',
              suffixText: '% p.a.',
              prefixIcon: Icon(Icons.percent_rounded),
            ),
            onChanged: (_) => _calculate(),
          ),

          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Investment Period', style: AppTextStyles.body),
              Text(
                '$_investmentPeriod '
                '${_investmentPeriod == 1 ? 'year' : 'years'}',
                style: AppTextStyles.sectionTitle,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          Slider(
            value: _investmentPeriod.toDouble(),
            min: 1,
            max: 40,
            divisions: 39,
            activeColor: AppColors.primary,
            label: '$_investmentPeriod years',
            onChanged: (value) {
              setState(() {
                _investmentPeriod = value.round();
              });

              _calculate();
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1 year', style: AppTextStyles.caption),
              Text('40 years', style: AppTextStyles.caption),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate_outlined),
              label: const Text('Calculate Lumpsum'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _disclaimer() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Lumpsum calculations are estimates based on the '
        'expected annual return entered by you. Actual market '
        'returns are not guaranteed and may be higher or lower.',
        style: AppTextStyles.caption,
      ),
    );
  }
}
