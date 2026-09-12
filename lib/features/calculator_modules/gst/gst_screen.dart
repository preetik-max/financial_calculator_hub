import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'gst_calculator.dart';
import 'gst_model.dart';
import 'widgets/gst_result_card.dart';

class GstScreen extends StatefulWidget {
  const GstScreen({super.key});

  @override
  State<GstScreen> createState() => _GstScreenState();
}

class _GstScreenState extends State<GstScreen> {
  final TextEditingController _amountController = TextEditingController(
    text: '10000',
  );

  GstCalculationMode _mode = GstCalculationMode.addGst;

  double _gstRate = 18;

  GstResult? _result;

  final List<double> _gstRates = const [5, 12, 18, 28];

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double _parseAmount() {
    return double.tryParse(
          _amountController.text.replaceAll(',', '').replaceAll('₹', '').trim(),
        ) ??
        0;
  }

  void _calculate() {
    final double amount = _parseAmount();

    if (amount <= 0) {
      setState(() {
        _result = null;
      });
      return;
    }

    final GstResult result = GstCalculator.calculate(
      GstInput(amount: amount, gstRate: _gstRate, mode: _mode),
    );

    setState(() {
      _result = result;
    });
  }

  void _reset() {
    setState(() {
      _amountController.text = '10000';
      _gstRate = 18;
      _mode = GstCalculationMode.addGst;
    });

    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GST Calculator'), centerTitle: true),
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

                    const SizedBox(height: 18),

                    _buildInputCard(context),

                    const SizedBox(height: 18),

                    if (_result != null) GstResultCard(result: _result!),

                    if (_result == null) _buildValidationMessage(context),

                    const SizedBox(height: 18),

                    _buildInfoCard(context),
                  ],
                ),
              ),
            ),

            // Centralized advertisement.
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
              Icons.receipt_long_rounded,
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
                  'GST Calculator',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Calculate GST amount, base price and final price.',
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
            Text('GST Details', style: AppTextStyles.sectionTitle),

            const SizedBox(height: 18),

            _buildModeSelector(context),

            const SizedBox(height: 18),

            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: _mode == GstCalculationMode.addGst
                    ? 'Base Amount'
                    : 'GST Inclusive Amount',
                hintText: 'Enter amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'GST Rate',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _gstRates.map((rate) {
                final bool selected = _gstRate == rate;

                return ChoiceChip(
                  label: Text('${rate.toStringAsFixed(0)}%'),
                  selected: selected,
                  onSelected: (_) {
                    setState(() {
                      _gstRate = rate;
                    });

                    _calculate();
                  },
                );
              }).toList(),
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

  Widget _buildModeSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _modeButton(
              context,
              mode: GstCalculationMode.addGst,
              title: 'Add GST',
              icon: Icons.add_rounded,
            ),
          ),
          Expanded(
            child: _modeButton(
              context,
              mode: GstCalculationMode.removeGst,
              title: 'Remove GST',
              icon: Icons.remove_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(
    BuildContext context, {
    required GstCalculationMode mode,
    required String title,
    required IconData icon,
  }) {
    final bool selected = _mode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _mode = mode;
        });

        _calculate();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: selected
              ? Theme.of(context).colorScheme.surface
              : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: selected
              ? [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? AppColors.primary
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.primary : null,
                ),
              ),
            ),
          ],
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
              'Please enter a valid amount greater than zero.',
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
                Text('GST Calculation', style: AppTextStyles.sectionTitle),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              'Use Add GST when you have a pre-GST price and want to '
              'calculate the GST and final price. Use Remove GST when '
              'the amount already includes GST and you want to find '
              'the original base price.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),

            const SizedBox(height: 12),

            const _InfoRow(
              icon: Icons.add_circle_outline_rounded,
              text: 'Add GST: Base Amount × GST Rate ÷ 100',
            ),

            const SizedBox(height: 8),

            const _InfoRow(
              icon: Icons.remove_circle_outline_rounded,
              text: 'Remove GST: Inclusive Amount × 100 ÷ (100 + GST Rate)',
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
