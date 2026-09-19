import 'package:flutter/material.dart';

import '../../../core/affiliate/affiliate_url_service.dart';
import '../data/home_loan_data.dart';
import '../models/home_loan_model.dart';

class HomeLoansScreen extends StatelessWidget {
  const HomeLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Loans'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: HomeLoanData.loans.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _HomeLoanCard(loan: HomeLoanData.loans[index]);
        },
      ),
    );
  }
}

class _HomeLoanCard extends StatelessWidget {
  final HomeLoanModel loan;

  const _HomeLoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductHeader(
              logoAsset: loan.logoAsset,
              bankName: loan.bankName,
              productName: loan.productName,
              fallbackIcon: Icons.home_work_rounded,
            ),

            const SizedBox(height: 16),

            Text(loan.description, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 14),

            ...loan.benefits.map((benefit) => _BenefitRow(benefit: benefit)),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    title: 'Loan Amount',
                    value: loan.loanAmount,
                  ),
                ),
                Expanded(
                  child: _InfoItem(title: 'Tenure', value: loan.tenure),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    title: 'Interest Rate',
                    value: loan.interestRate,
                  ),
                ),
                Expanded(
                  child: _InfoItem(
                    title: 'Processing Fee',
                    value: loan.processingFee,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _EligibilityBox(text: loan.eligibility),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  AffiliateUrlService.open(
                    context: context,
                    url: loan.affiliateUrl,
                  );
                },
                child: const Text('Apply Now'),
              ),
            ),

            const SizedBox(height: 8),

            _RedirectText(),
          ],
        ),
      ),
    );
  }
}

class _ProductHeader extends StatelessWidget {
  final String logoAsset;
  final String bankName;
  final String productName;
  final IconData fallbackIcon;

  const _ProductHeader({
    required this.logoAsset,
    required this.bankName,
    required this.productName,
    required this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 58,
          height: 58,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: Image.asset(
            logoAsset,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) {
              return Icon(
                fallbackIcon,
                size: 30,
                color: theme.colorScheme.primary,
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bankName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(productName, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final String benefit;

  const _BenefitRow({required this.benefit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(benefit, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String value;

  const _InfoItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.bodySmall),
        const SizedBox(height: 3),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EligibilityBox extends StatelessWidget {
  final String text;

  const _EligibilityBox({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}

class _RedirectText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'You will be redirected to the application partner.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
      ),
    );
  }
}
