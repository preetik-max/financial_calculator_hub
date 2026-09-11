import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import 'sip_calculator.dart';
import 'sip_model.dart';
import 'widgets/sip_result_card.dart';

class SipScreen extends StatefulWidget {
  const SipScreen({super.key});

  @override
  State<SipScreen> createState() => _SipScreenState();
}

class _SipScreenState extends State<SipScreen> {
  final TextEditingController _monthlyController =
  TextEditingController(text: '5000');

  final TextEditingController _returnController =
  TextEditingController(text: '12');

  int _years = 10;

  SipResult? _result;

  String? _monthlyError;
  String? _returnError;

  @override
  void initState() {
    super.initState();

    _calculateSip();
  }

  @override
  void dispose() {
    _monthlyController.dispose();
    _returnController.dispose();

    super.dispose();
  }

  double _parse(TextEditingController controller) {
    return double.tryParse(
      controller.text.replaceAll(',', '').trim(),
    ) ??
        0;
  }

  void _calculateSip() {
    FocusScope.of(context).unfocus();

    final double monthly = _parse(_monthlyController);
    final double expectedReturn = _parse(_returnController);

    String? monthlyError;
    String? returnError;

    if (monthly <= 0) {
      monthlyError = 'Enter a valid monthly SIP amount';
    }

    if (expectedReturn < 0 || expectedReturn > 100) {
      returnError = 'Return rate must be between 0% and 100%';
    }

    setState(() {
      _monthlyError = monthlyError;
      _returnError = returnError;
    });

    if (monthlyError != null || returnError != null) {
      setState(() {
        _result = null;
      });

      return;
    }

    final input = SipInput(
      monthlyInvestment: monthly,
      expectedReturn: expectedReturn,
      investmentYears: _years,
    );

    final result = SipCalculator.calculate(input);

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SIP Calculator'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  const Text(
                    'Plan Your SIP Investment',
                    style: AppTextStyles.headline,
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Estimate your investment value and potential returns.',
                    style: AppTextStyles.body,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  _investmentCard(),

                  const SizedBox(height: AppSpacing.xl),

                  if (_result != null) ...[
                    SipResultCard(result: _result!),
                    const SizedBox(height: AppSpacing.xl),
                  ],

                  _infoCard(),

                  const SizedBox(height: AppSpacing.lg),

                  const Text(
                    'Disclaimer: SIP returns shown here are estimates for '
                        'educational purposes only. Actual mutual fund returns '
                        'are market-linked and may be higher or lower. This '
                        'calculator does not constitute investment advice.',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),

            const BannerAdWidget(),
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
          const Text(
            'Investment Details',
            style: AppTextStyles.sectionTitle,
          ),

          const SizedBox(height: AppSpacing.lg),

          TextField(
            controller: _monthlyController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            onSubmitted: (_) => _calculateSip(),
            decoration: InputDecoration(
              labelText: 'Monthly SIP Amount',
              prefixText: '₹ ',
              errorText: _monthlyError,
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          TextField(
            controller: _returnController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            onSubmitted: (_) => _calculateSip(),
            decoration: InputDecoration(
              labelText: 'Expected Return Rate',
              suffixText: '% p.a.',
              errorText: _returnError,
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(AppSpacing.radiusMd),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Investment Period',
                style: AppTextStyles.body,
              ),
              Text(
                '$_years years',
                style: AppTextStyles.sectionTitle,
              ),
            ],
          ),

          Slider(
            value: _years.toDouble(),
            min: 1,
            max: 40,
            divisions: 39,
            label: '$_years years',
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                _years = value.round();
              });
            },
            onChangeEnd: (_) {
              if (_result != null) {
                _calculateSip();
              }
            },
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 year',
                style: AppTextStyles.caption,
              ),
              Text(
                '40 years',
                style: AppTextStyles.caption,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _calculateSip,
              icon: const Icon(Icons.calculate_rounded),
              label: const Text(
                'Calculate SIP',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How SIP Calculation Works',
            style: AppTextStyles.sectionTitle,
          ),

          SizedBox(height: AppSpacing.md),

          Text(
            'The calculator assumes a fixed monthly SIP investment '
                'and a constant expected annual return rate.',
            style: AppTextStyles.body,
          ),

          SizedBox(height: AppSpacing.sm),

          Text(
            'Each SIP contribution is treated as an end-of-month '
                'investment so the result remains consistent with the '
                'formula used in this calculator.',
            style: AppTextStyles.caption,
          ),

          SizedBox(height: AppSpacing.sm),

          Text(
            'Actual mutual fund returns are market-linked and can '
                'vary significantly over time.',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}