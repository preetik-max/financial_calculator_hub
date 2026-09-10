import 'package:flutter/material.dart';

class AboutUsDialog extends StatelessWidget {
  const AboutUsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      title: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Icon(
              Icons.calculate_outlined,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(child: Text('Financial Calculator Hub')),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Finora Labs',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              'Simple Tools. Smarter Financial Decisions.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Financial Calculator Hub is developed by '
              'Finora Labs to provide simple, fast and '
              'easy-to-use financial calculators for '
              'everyday financial planning.',
              style: TextStyle(height: 1.5),
            ),

            const SizedBox(height: 16),

            const Text(
              'Our goal is to make financial calculations '
              'simple and accessible for everyone.',
              style: TextStyle(height: 1.5),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              child: const Text(
                'Disclaimer: Calculations provided by this '
                'app are for informational and educational '
                'purposes only and should not be considered '
                'financial advice.',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
            ),

            const SizedBox(height: 16),

            const Center(
              child: Text('Version 1.0.0', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
