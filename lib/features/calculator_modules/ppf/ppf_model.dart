class PpfInput {
  final double annualInvestment;
  final double annualInterestRate;
  final int tenureYears;

  const PpfInput({
    required this.annualInvestment,
    required this.annualInterestRate,
    required this.tenureYears,
  });
}

class PpfResult {
  final double annualInvestment;
  final double annualInterestRate;
  final int tenureYears;

  final double totalInvestment;
  final double totalInterest;
  final double maturityAmount;

  const PpfResult({
    required this.annualInvestment,
    required this.annualInterestRate,
    required this.tenureYears,
    required this.totalInvestment,
    required this.totalInterest,
    required this.maturityAmount,
  });

  double get investmentPercentage {
    if (maturityAmount <= 0) {
      return 0;
    }

    return (totalInvestment / maturityAmount) * 100;
  }

  double get interestPercentage {
    if (maturityAmount <= 0) {
      return 0;
    }

    return (totalInterest / maturityAmount) * 100;
  }
}
