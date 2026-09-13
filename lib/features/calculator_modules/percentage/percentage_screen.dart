import 'package:flutter/material.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import 'percentage_calculator.dart';
import 'percentage_model.dart';
import 'widgets/percentage_result_card.dart';

class PercentageScreen extends StatefulWidget {
  const PercentageScreen({super.key});

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  PercentageMode _mode = PercentageMode.percentageOf;

  final TextEditingController _firstController = TextEditingController(
    text: '20',
  );

  final TextEditingController _secondController = TextEditingController(
    text: '5000',
  );

  PercentageResult? _result;

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  double _parse(String value) {
    return double.tryParse(value.replaceAll(',', '').trim()) ?? 0;
  }

  void _calculate() {
    final double first = _parse(_firstController.text);
    final double second = _parse(_secondController.text);

    setState(() {
      _result = PercentageCalculator.calculate(
        PercentageInput(mode: _mode, firstValue: first, secondValue: second),
      );
    });
  }

  void _changeMode(PercentageMode mode) {
    setState(() {
      _mode = mode;
      _result = null;
    });

    _calculate();
  }

  String get _firstLabel {
    switch (_mode) {
      case PercentageMode.percentageOf:
        return 'Percentage (%)';

      case PercentageMode.whatPercentage:
        return 'First Value';

      case PercentageMode.increaseDecrease:
        return 'New Value';
    }
  }

  String get _secondLabel {
    switch (_mode) {
      case PercentageMode.percentageOf:
        return 'Value';

      case PercentageMode.whatPercentage:
        return 'Total Value';

      case PercentageMode.increaseDecrease:
        return 'Old Value';
    }
  }

  String get _firstHint {
    switch (_mode) {
      case PercentageMode.percentageOf:
        return 'Enter percentage';

      case PercentageMode.whatPercentage:
        return 'Enter first value';

      case PercentageMode.increaseDecrease:
        return 'Enter new value';
    }
  }

  String get _secondHint {
    switch (_mode) {
      case PercentageMode.percentageOf:
        return 'Enter value';

      case PercentageMode.whatPercentage:
        return 'Enter total value';

      case PercentageMode.increaseDecrease:
        return 'Enter old value';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        title: const Text('Percentage Calculator', style: AppTextStyles.title),
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
                    const Text(
                      'Calculate percentages quickly',
                      style: AppTextStyles.body,
                    ),
                    const SizedBox(height: 18),

                    _ModeSelector(selectedMode: _mode, onChanged: _changeMode),

                    const SizedBox(height: 20),

                    _InputCard(
                      firstController: _firstController,
                      secondController: _secondController,
                      firstLabel: _firstLabel,
                      secondLabel: _secondLabel,
                      firstHint: _firstHint,
                      secondHint: _secondHint,
                      mode: _mode,
                      onCalculate: _calculate,
                    ),

                    const SizedBox(height: 20),

                    if (_result != null) PercentageResultCard(result: _result!),

                    const SizedBox(height: 20),

                    _FormulaCard(mode: _mode),
                  ],
                ),
              ),
            ),

            // Centralized AdMob component.
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  final PercentageMode selectedMode;
  final ValueChanged<PercentageMode> onChanged;

  const _ModeSelector({required this.selectedMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              title: '% of',
              icon: Icons.percent_rounded,
              selected: selectedMode == PercentageMode.percentageOf,
              onTap: () => onChanged(PercentageMode.percentageOf),
            ),
          ),
          Expanded(
            child: _ModeButton(
              title: 'What %',
              icon: Icons.help_outline_rounded,
              selected: selectedMode == PercentageMode.whatPercentage,
              onTap: () => onChanged(PercentageMode.whatPercentage),
            ),
          ),
          Expanded(
            child: _ModeButton(
              title: 'Change',
              icon: Icons.swap_vert_rounded,
              selected: selectedMode == PercentageMode.increaseDecrease,
              onTap: () => onChanged(PercentageMode.increaseDecrease),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          child: Column(
            children: [
              Icon(
                icon,
                size: 19,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final TextEditingController firstController;
  final TextEditingController secondController;
  final String firstLabel;
  final String secondLabel;
  final String firstHint;
  final String secondHint;
  final PercentageMode mode;
  final VoidCallback onCalculate;

  const _InputCard({
    required this.firstController,
    required this.secondController,
    required this.firstLabel,
    required this.secondLabel,
    required this.firstHint,
    required this.secondHint,
    required this.mode,
    required this.onCalculate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter Values', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 18),

          _InputField(
            controller: firstController,
            label: firstLabel,
            hint: firstHint,
            suffix: mode == PercentageMode.percentageOf ? '%' : null,
          ),

          const SizedBox(height: 16),

          _InputField(
            controller: secondController,
            label: secondLabel,
            hint: secondHint,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onCalculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'Calculate',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? suffix;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormulaCard extends StatelessWidget {
  final PercentageMode mode;

  const _FormulaCard({required this.mode});

  @override
  Widget build(BuildContext context) {
    String title;
    String formula;
    String example;

    switch (mode) {
      case PercentageMode.percentageOf:
        title = 'Formula';
        formula = 'Percentage ÷ 100 × Value';
        example = '20% of 5,000 = 1,000';

      case PercentageMode.whatPercentage:
        title = 'Formula';
        formula = '(First Value ÷ Total Value) × 100';
        example = '1,000 ÷ 5,000 × 100 = 20%';

      case PercentageMode.increaseDecrease:
        title = 'Formula';
        formula = '((New − Old) ÷ Old) × 100';
        example = '5,000 → 6,000 = 20% increase';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 8),
          Text(
            formula,
            style: AppTextStyles.body.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(example, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
