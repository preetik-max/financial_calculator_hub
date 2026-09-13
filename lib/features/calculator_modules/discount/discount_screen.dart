import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import 'discount_calculator.dart';
import 'discount_model.dart';
import 'widgets/discount_result_card.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final TextEditingController _priceController = TextEditingController(
    text: '10000',
  );

  final TextEditingController _discountController = TextEditingController(
    text: '10',
  );

  DiscountResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  void _calculate() {
    final double price =
        double.tryParse(_priceController.text.replaceAll(',', '')) ?? 0;

    final double discount = double.tryParse(_discountController.text) ?? 0;

    setState(() {
      _result = DiscountCalculator.calculate(
        DiscountInput(originalPrice: price, discountPercent: discount),
      );
    });
  }

  void _reset() {
    _priceController.text = '10000';
    _discountController.text = '10';

    _calculate();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Discount Calculator'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
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
                    Text('Discount Calculator', style: AppTextStyles.headline),
                    const SizedBox(height: 6),
                    Text(
                      'Calculate your discount and final purchase price.',
                      style: AppTextStyles.body,
                    ),

                    const SizedBox(height: 24),

                    _InputCard(
                      priceController: _priceController,
                      discountController: _discountController,
                      onChanged: _calculate,
                    ),

                    const SizedBox(height: 20),

                    if (_result != null) DiscountResultCard(result: _result!),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _calculate,
                        child: const Text('Calculate'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _reset,
                        child: const Text('Reset'),
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
  final TextEditingController priceController;
  final TextEditingController discountController;
  final VoidCallback onChanged;

  const _InputCard({
    required this.priceController,
    required this.discountController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter Details', style: AppTextStyles.sectionTitle),

          const SizedBox(height: 18),

          Text(
            'Original Price',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              prefixText: '₹ ',
              hintText: 'Enter original price',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Discount Percentage',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          TextField(
            controller: discountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => onChanged(),
            decoration: InputDecoration(
              suffixText: '%',
              hintText: 'Enter discount percentage',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
