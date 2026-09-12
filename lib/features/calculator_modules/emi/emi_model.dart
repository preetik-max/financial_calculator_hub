class EmiInput {
  final double loanAmount;
  final double annualInterestRate;
  final int tenureYears;

  const EmiInput({
    required this.loanAmount,
    required this.annualInterestRate,
    required this.tenureYears,
  });
}

class EmiResult {
  final double loanAmount;
  final double annualInterestRate;
  final int tenureYears;
  final int tenureMonths;

  final double monthlyEmi;
  final double totalInterest;
  final double totalPayment;

  const EmiResult({
    required this.loanAmount,
    required this.annualInterestRate,
    required this.tenureYears,
    required this.tenureMonths,
    required this.monthlyEmi,
    required this.totalInterest,
    required this.totalPayment,
  });

  double get principalPercentage {
    if (totalPayment <= 0) {
      return 0;
    }

    return (loanAmount / totalPayment) * 100;
  }

  double get interestPercentage {
    if (totalPayment <= 0) {
      return 0;
    }

    return (totalInterest / totalPayment) * 100;
  }
}
