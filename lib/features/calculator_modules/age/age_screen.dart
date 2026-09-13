import 'package:flutter/material.dart';

import 'age_calculator.dart';
import 'age_model.dart';
import 'widgets/age_result_card.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final AgeCalculator _calculator = const AgeCalculator();

  late DateTime _dateOfBirth;
  late DateTime _ageAtDate;

  AgeResult? _result;

  @override
  void initState() {
    super.initState();

    final today = _dateOnly(DateTime.now());

    _ageAtDate = today;

    // Default DOB is 29 years before today.
    _dateOfBirth = DateTime(today.year - 29, today.month, today.day);
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _selectDateOfBirth() async {
    final today = _dateOnly(DateTime.now());

    final selected = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: today,
      helpText: 'Select Date of Birth',
      cancelText: 'CANCEL',
      confirmText: 'SELECT',
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _dateOfBirth = _dateOnly(selected);
      _result = null;
    });
  }

  Future<void> _selectAgeAtDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _ageAtDate,
      firstDate: _dateOfBirth,
      lastDate: DateTime(2100),
      helpText: 'Calculate Age At',
      cancelText: 'CANCEL',
      confirmText: 'SELECT',
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _ageAtDate = _dateOnly(selected);
      _result = null;
    });
  }

  void _calculate() {
    if (_ageAtDate.isBefore(_dateOfBirth)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Age at date cannot be before date of birth.'),
        ),
      );
      return;
    }

    try {
      final result = _calculator.calculate(
        dateOfBirth: _dateOfBirth,
        ageAtDate: _ageAtDate,
      );

      setState(() {
        _result = result;
      });
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message?.toString() ?? 'Invalid dates.')),
      );
    }
  }

  void _reset() {
    final today = _dateOnly(DateTime.now());

    setState(() {
      _ageAtDate = today;

      _dateOfBirth = DateTime(today.year - 29, today.month, today.day);

      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Age Calculator'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIntroCard(theme),

              const SizedBox(height: 20),

              _buildDateInput(
                title: 'Date of Birth',
                subtitle: 'Enter your date of birth',
                date: _dateOfBirth,
                icon: Icons.cake_outlined,
                onTap: _selectDateOfBirth,
              ),

              const SizedBox(height: 14),

              _buildDateInput(
                title: 'Age at Date',
                subtitle: 'Calculate your age on a specific date',
                date: _ageAtDate,
                icon: Icons.event_outlined,
                onTap: _selectAgeAtDate,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: FilledButton.icon(
                        onPressed: _calculate,
                        icon: const Icon(Icons.calculate_outlined),
                        label: const Text(
                          'Calculate Age',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 54,
                    width: 54,
                    child: OutlinedButton(
                      onPressed: _reset,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Icon(Icons.refresh),
                    ),
                  ),
                ],
              ),

              if (_result != null) ...[
                const SizedBox(height: 20),
                AgeResultCard(result: _result!),
              ],

              const SizedBox(height: 20),

              _buildInfoCard(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.72),
          ],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.person_outline, color: Colors.white, size: 36),
          SizedBox(height: 12),
          Text(
            'Age Calculator',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Find your exact age in years, months and days.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput({
    required String title,
    required String subtitle,
    required DateTime date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(date),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.calendar_month_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text(
                  'About Age Calculator',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Calculate your exact age based on your date of '
              'birth and any selected date. The result includes '
              'years, months, days, total days, weeks, hours, '
              'minutes and seconds.',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
