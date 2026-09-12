class RdInput {
  final double monthlyDeposit;
  final double annualInterestRate;
  final int tenureYears;

  const RdInput({
    required this.monthlyDeposit,
    required this.annualInterestRate,
    required this.tenureYears,
  });
}

class RdResult {
  final double monthlyDeposit;
  final double annualInterestRate;
  final int tenureYears;
  final int tenureMonths;

  final double totalDeposited;
  final double interestEarned;
  final double maturityAmount;

  const RdResult({
    required this.monthlyDeposit,
    required this.annualInterestRate,
    required this.tenureYears,
    required this.tenureMonths,
    required this.totalDeposited,
    required this.interestEarned,
    required this.maturityAmount,
  });

  double get principalPercentage {
    if (maturityAmount <= 0) {
      return 0;
    }

    return (totalDeposited / maturityAmount) * 100;
  }

  double get interestPercentage {
    if (maturityAmount <= 0) {
      return 0;
    }

    return (interestEarned / maturityAmount) * 100;
  }
}
