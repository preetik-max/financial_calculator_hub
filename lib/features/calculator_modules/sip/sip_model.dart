class SipInput {
  final double monthlyInvestment;
  final double expectedReturn;
  final int investmentYears;

  const SipInput({
    required this.monthlyInvestment,
    required this.expectedReturn,
    required this.investmentYears,
  });
}

class SipResult {
  final double monthlyInvestment;
  final double expectedReturn;
  final int investmentYears;
  final int totalMonths;

  final double investedAmount;
  final double estimatedReturns;
  final double maturityValue;

  const SipResult({
    required this.monthlyInvestment,
    required this.expectedReturn,
    required this.investmentYears,
    required this.totalMonths,
    required this.investedAmount,
    required this.estimatedReturns,
    required this.maturityValue,
  });
}