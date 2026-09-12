class SimpleInterestInput {
  final double principal;
  final double annualRate;
  final double timeYears;

  const SimpleInterestInput({
    required this.principal,
    required this.annualRate,
    required this.timeYears,
  });
}

class SimpleInterestResult {
  final double principal;
  final double annualRate;
  final double timeYears;
  final double interest;
  final double maturityAmount;

  const SimpleInterestResult({
    required this.principal,
    required this.annualRate,
    required this.timeYears,
    required this.interest,
    required this.maturityAmount,
  });

  double get principalPercentage {
    if (maturityAmount <= 0) return 0;
    return (principal / maturityAmount) * 100;
  }

  double get interestPercentage {
    if (maturityAmount <= 0) return 0;
    return (interest / maturityAmount) * 100;
  }
}
