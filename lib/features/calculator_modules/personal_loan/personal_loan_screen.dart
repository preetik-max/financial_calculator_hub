import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/ads/banner_ad_widget.dart';
import 'personal_loan_calculator.dart';

class PersonalLoanScreen extends StatefulWidget {
  const PersonalLoanScreen({super.key});

  @override
  State<PersonalLoanScreen> createState() => _PersonalLoanScreenState();
}

class _PersonalLoanScreenState extends State<PersonalLoanScreen> {
  final TextEditingController _loanAmountController = TextEditingController(
    text: '500000',
  );

  final TextEditingController _interestRateController = TextEditingController(
    text: '12',
  );

  final TextEditingController _tenureController = TextEditingController(
    text: '5',
  );

  bool _tenureInYears = true;

  PersonalLoanResult? _result;

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _calculate() {
    final loanAmount = double.tryParse(
      _loanAmountController.text.replaceAll(',', '').trim(),
    );

    final interestRate = double.tryParse(_interestRateController.text.trim());

    final tenureValue = int.tryParse(_tenureController.text.trim());

    if (loanAmount == null ||
        interestRate == null ||
        tenureValue == null ||
        loanAmount <= 0 ||
        interestRate < 0 ||
        tenureValue <= 0) {
      setState(() {
        _result = null;
      });
      return;
    }

    final tenureMonths = _tenureInYears ? tenureValue * 12 : tenureValue;

    try {
      final result = PersonalLoanCalculator.calculate(
        loanAmount: loanAmount,
        annualInterestRate: interestRate,
        tenureMonths: tenureMonths,
      );

      setState(() {
        _result = result;
      });
    } catch (_) {
      setState(() {
        _result = null;
      });
    }
  }

  String _formatCurrency(double value) {
    return _currencyFormat.format(value);
  }

  String _formatMonths(int months) {
    final years = months ~/ 12;
    final remainingMonths = months % 12;

    if (remainingMonths == 0) {
      return '$years ${years == 1 ? 'Year' : 'Years'}';
    }

    if (years == 0) {
      return '$remainingMonths Months';
    }

    return '$years Years $remainingMonths Months';
  }

  InputDecoration _inputDecoration({
    required String label,
    required String prefix,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixText: prefix,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
      ),
    );
  }

  Widget _resultCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.currency_rupee_rounded,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    final result = _result;

    if (result == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monthly EMI',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _formatCurrency(result.monthlyEmi),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  'Loan Amount',
                  _formatCurrency(result.loanAmount),
                ),
              ),
              Expanded(
                child: _summaryItem(
                  'Interest',
                  _formatCurrency(result.totalInterest),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _summaryItem(
                  'Total Payment',
                  _formatCurrency(result.totalPayment),
                ),
              ),
              Expanded(
                child: _summaryItem(
                  'Tenure',
                  _formatMonths(result.tenureMonths),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Loan Calculator')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Calculate your personal loan EMI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Enter your loan details to estimate monthly EMI, total interest and repayment.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _loanAmountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _inputDecoration(
                  label: 'Loan Amount',
                  prefix: '₹ ',
                  icon: Icons.currency_rupee_rounded,
                ),
                onChanged: (_) => _calculate(),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _interestRateController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: _inputDecoration(
                  label: 'Annual Interest Rate',
                  prefix: '',
                  icon: Icons.percent_rounded,
                ).copyWith(suffixText: '%'),
                onChanged: (_) => _calculate(),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _tenureController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  label: _tenureInYears ? 'Loan Tenure' : 'Loan Tenure',
                  prefix: '',
                  icon: Icons.calendar_month_rounded,
                ).copyWith(suffixText: _tenureInYears ? 'Years' : 'Months'),
                onChanged: (_) => _calculate(),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  ChoiceChip(
                    label: const Text('Years'),
                    selected: _tenureInYears,
                    onSelected: (selected) {
                      if (!selected) {
                        return;
                      }

                      setState(() {
                        _tenureInYears = true;
                      });

                      _calculate();
                    },
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Months'),
                    selected: !_tenureInYears,
                    onSelected: (selected) {
                      if (!selected) {
                        return;
                      }

                      setState(() {
                        _tenureInYears = false;
                      });

                      _calculate();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _summaryCard(),

              if (_result != null) ...[
                const SizedBox(height: 16),

                _resultCard(
                  title: 'Monthly EMI',
                  value: _formatCurrency(_result!.monthlyEmi),
                  icon: Icons.payments_outlined,
                ),

                const SizedBox(height: 12),

                _resultCard(
                  title: 'Total Interest',
                  value: _formatCurrency(_result!.totalInterest),
                  icon: Icons.percent_rounded,
                ),

                const SizedBox(height: 12),

                _resultCard(
                  title: 'Total Repayment',
                  value: _formatCurrency(_result!.totalPayment),
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ],

              const SizedBox(height: 20),

              const Text(
                'Note: This is an estimate. Actual EMI, fees and applicable charges may vary by lender.',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SafeArea(top: false, child: BannerAdWidget()),
    );
  }
}
