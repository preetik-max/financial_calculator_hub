import 'package:flutter/material.dart';

import '../age_model.dart';

class AgeResultCard extends StatelessWidget {
  final AgeResult result;

  const AgeResultCard({super.key, required this.result});

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Age',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${result.years} Years',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${result.months} Months • ${result.days} Days',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _row(
              'Age',
              '${result.years} years '
                  '${result.months} months '
                  '${result.days} days',
            ),

            _row(
              'Total Months',
              '${result.totalMonths} months '
                  '${result.days} days',
            ),

            _row(
              'Total Weeks',
              '${result.totalWeeks} weeks '
                  '${result.remainingWeeksDays} days',
            ),

            _row('Total Days', _formatNumber(result.totalDays)),

            _row('Total Hours', _formatNumber(result.totalHours)),

            _row('Total Minutes', _formatNumber(result.totalMinutes)),

            _row('Total Seconds', _formatNumber(result.totalSeconds)),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.cake_outlined),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Next birthday in '
                    '${result.daysUntilBirthday} days',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 3, child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
