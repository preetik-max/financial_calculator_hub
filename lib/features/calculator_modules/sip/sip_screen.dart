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
  final TextEditingController _monthlyController = TextEditingController(
    text: '5000',
  );

  final TextEditingController _returnController = TextEditingController(
    text: '12',
  );

  int _years = 10;

  SipResult? _result;

  @override
  void initState() {
    super.initState();

    // IMPORTANT:
    // Do not call _calculateSip() directly from initState().
    //
    // _calculateSip() uses FocusScope.of(context), which depends on
    // inherited widgets. The widget tree is not fully ready during initState.
    //
    // Run the initial calculation after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _calculateSip(initialCalculation: true);
    });
  }

  @override
  void dispose() {
    _monthlyController.dispose();
    _returnController.dispose();

    super.dispose();
  }

  double _parse(TextEditingController controller) {
    return double.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;
  }

  void _calculateSip({bool initialCalculation = false}) {
    // Only remove keyboard focus when the user explicitly
    // presses Calculate.
    //
    // Do NOT do this during initState.
    if (!initialCalculation && mounted) {
      FocusScope.of(context).unfocus();
    }

    final double monthly = _parse(_monthlyController);

    final double expectedReturn = _parse(_returnController);

    // ------------------------------------------------------------
    // Validation
    // ------------------------------------------------------------

    if (monthly < 500) {
      if (!initialCalculation) {
        _showMessage('Monthly SIP amount should be at least ₹500.');
      }

      setState(() {
        _result = null;
      });

      return;
    }

    if (monthly > 1000000) {
      if (!initialCalculation) {
        _showMessage('Monthly SIP amount cannot exceed ₹10,00,000.');
      }

      setState(() {
        _result = null;
      });

      return;
    }

    if (expectedReturn < 0 || expectedReturn > 50) {
      if (!initialCalculation) {
        _showMessage('Expected return should be between 0% and 50%.');
      }

      setState(() {
        _result = null;
      });

      return;
    }

    if (_years < 1 || _years > 40) {
      if (!initialCalculation) {
        _showMessage('Investment period should be between 1 and 40 years.');
      }

      setState(() {
        _result = null;
      });

      return;
    }

    // ------------------------------------------------------------
    // Calculate
    // ------------------------------------------------------------

    final SipInput input = SipInput(
      monthlyInvestment: monthly,
      expectedReturn: expectedReturn,
      investmentYears: _years,
    );

    final SipResult result = SipCalculator.calculate(input);

    if (!mounted) return;

    setState(() {
      _result = result;
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  String _formatInput(double value) {
    if (value <= 0) {
      return '0';
    }

    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SIP Calculator'), centerTitle: true),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // ========================================================
                  // HEADER
                  // ========================================================
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

                  // ========================================================
                  // INPUT CARD
                  // ========================================================
                  Container(
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

                        // ------------------------------------------------
                        // Monthly SIP
                        // ------------------------------------------------
                        _inputField(
                          controller: _monthlyController,
                          label: 'Monthly SIP Amount',
                          prefix: '₹ ',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // ------------------------------------------------
                        // Expected Return
                        // ------------------------------------------------
                        _inputField(
                          controller: _returnController,
                          label: 'Expected Return Rate',
                          suffix: ' % p.a.',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // ------------------------------------------------
                        // Investment Period
                        // ------------------------------------------------
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

                        const SizedBox(height: AppSpacing.sm),

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
                        ),

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('1 year', style: AppTextStyles.caption),
                            Text('40 years', style: AppTextStyles.caption),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // ------------------------------------------------
                        // Calculate Button
                        // ------------------------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _calculateSip(initialCalculation: false);
                            },
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
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ========================================================
                  // RESULT
                  // ========================================================
                  if (_result != null) SipResultCard(result: _result!),

                  if (_result != null) const SizedBox(height: AppSpacing.xl),

                  // ========================================================
                  // HOW IT WORKS
                  // ========================================================
                  _infoCard(),

                  const SizedBox(height: AppSpacing.lg),

                  // ========================================================
                  // DISCLAIMER
                  // ========================================================
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'Disclaimer: SIP returns are market-linked and '
                      'not guaranteed. This calculator provides an '
                      'illustrative estimate based on the expected '
                      'annual return entered by you.',
                      style: AppTextStyles.caption,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ========================================================
                  // BANNER AD
                  // ========================================================
                  const BannerAdWidget(),

                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        suffixText: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
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
          Text('How SIP Calculation Works', style: AppTextStyles.sectionTitle),

          SizedBox(height: AppSpacing.md),

          Text(
            'The calculator estimates the future value of your '
            'monthly SIP investment using the monthly equivalent '
            'of the expected annual return.',
            style: AppTextStyles.body,
          ),

          SizedBox(height: AppSpacing.md),

          Text(
            'Your actual mutual fund returns may be higher or lower '
            'because market returns are not fixed.',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
