import 'package:flutter/material.dart';

import '../../../core/affiliate/affiliate_url_service.dart';
import '../data/car_loan_data.dart';
import '../models/car_loan_model.dart';

class CarLoansScreen extends StatelessWidget {
  const CarLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Loans'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: CarLoanData.loans.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _CarLoanCard(loan: CarLoanData.loans[index]);
        },
      ),
    );
  }
}

class _CarLoanCard extends StatelessWidget {
  final CarLoanModel loan;

  const _CarLoanCard({required this.loan});

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
            Row(
              children: [
                _Logo(
                  assetPath: loan.logoAsset,
                  icon: Icons.directions_car_rounded,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.bankName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(loan.productName, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(loan.description, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 14),

            ...loan.benefits.map(
              (benefit) => Padding(
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
                    Expanded(
                      child: Text(benefit, style: theme.textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _Info(title: 'Loan Amount', value: loan.loanAmount),
                ),
                Expanded(
                  child: _Info(title: 'Tenure', value: loan.tenure),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _Info(
                    title: 'Interest Rate',
                    value: loan.interestRate,
                  ),
                ),
                Expanded(
                  child: _Info(
                    title: 'Processing Fee',
                    value: loan.processingFee,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _Eligibility(text: loan.eligibility),

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

            Center(
              child: Text(
                'You will be redirected to the application partner.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String assetPath;
  final IconData icon;

  const _Logo({required this.assetPath, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return Icon(icon, size: 30, color: theme.colorScheme.primary);
        },
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String title;
  final String value;

  const _Info({required this.title, required this.value});

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

class _Eligibility extends StatelessWidget {
  final String text;

  const _Eligibility({required this.text});

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
