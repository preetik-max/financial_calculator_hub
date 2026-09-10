import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../salary_model.dart';

class SalaryResultCard extends StatelessWidget {
  final SalaryResult result;

  const SalaryResultCard({super.key, required this.result});

  String _money(double value) {
    return '₹${value.round().toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)},')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estimated In-Hand Salary',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _money(result.monthlyInHand),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${_money(result.annualInHand)} per year',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
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
                'Monthly Breakdown',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.md),
              _row('Gross Salary', result.monthlyGross),
              _row('Employee PF', result.monthlyPf),
              _row('Professional Tax', result.monthlyProfessionalTax),
              _row('Other Deductions', result.monthlyOtherDeductions),
              const Divider(height: 24),
              _row(
                'Total Deductions',
                result.monthlyTotalDeductions,
                bold: true,
              ),
              _row('Net In-Hand', result.monthlyInHand, bold: true),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.goldLight,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.gold,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Your estimated annual take-home is '
                  '${_money(result.annualInHand)}.',
                  style: AppTextStyles.body,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: bold
                  ? const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )
                  : AppTextStyles.body,
            ),
          ),
          Text(
            _money(value),
            style: bold
                ? const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  )
                : AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
