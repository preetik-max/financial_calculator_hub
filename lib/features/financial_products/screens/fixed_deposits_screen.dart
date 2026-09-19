import 'package:flutter/material.dart';

import '../../../core/affiliate/affiliate_url_service.dart';
import '../data/fixed_deposit_data.dart';
import '../models/fixed_deposit_model.dart';

class FixedDepositsScreen extends StatelessWidget {
  const FixedDepositsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fixed Deposits'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: FixedDepositData.deposits.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _FixedDepositCard(deposit: FixedDepositData.deposits[index]);
        },
      ),
    );
  }
}

class _FixedDepositCard extends StatelessWidget {
  final FixedDepositModel deposit;

  const _FixedDepositCard({required this.deposit});

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
                _Logo(assetPath: deposit.logoAsset),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deposit.bankName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deposit.productName,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(deposit.description, style: theme.textTheme.bodyMedium),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _Info(
                    title: 'Minimum Deposit',
                    value: deposit.minimumDeposit,
                  ),
                ),
                Expanded(
                  child: _Info(title: 'Tenure', value: deposit.tenure),
                ),
              ],
            ),

            const SizedBox(height: 14),

            _Info(title: 'Interest Rate', value: deposit.interestRate),

            const SizedBox(height: 14),

            ...deposit.benefits.map(
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

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      deposit.eligibility,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  AffiliateUrlService.open(
                    context: context,
                    url: deposit.affiliateUrl,
                  );
                },
                child: const Text('View & Apply'),
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

  const _Logo({required this.assetPath});

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
          return Icon(
            Icons.account_balance_outlined,
            size: 30,
            color: theme.colorScheme.primary,
          );
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
