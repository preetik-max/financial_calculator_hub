class FdInput {
  final double principal;
  final double annualInterestRate;
  final int tenureYears;
  final int compoundingFrequency;

  const FdInput({
    required this.principal,
    required this.annualInterestRate,
    required this.tenureYears,
    required this.compoundingFrequency,
  });
}

class FdResult {
  final double principal;
  final double annualInterestRate;
  final int tenureYears;
  final int compoundingFrequency;

  final double maturityAmount;
  final double totalInterest;

  const FdResult({
    required this.principal,
    required this.annualInterestRate,
    required this.tenureYears,
    required this.compoundingFrequency,
    required this.maturityAmount,
    required this.totalInterest,
  });

  double get interestPercentage {
    if (maturityAmount <= 0) {
      return 0;
    }

    return (totalInterest / maturityAmount) * 100;
  }

  double get principalPercentage {
    if (maturityAmount <= 0) {
      return 0;
    }

    return (principal / maturityAmount) * 100;
  }
}
