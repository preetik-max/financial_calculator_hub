class PersonalLoanResult {
  final double loanAmount;
  final double interestRate;
  final int tenureMonths;
  final double monthlyEmi;
  final double totalInterest;
  final double totalPayment;

  const PersonalLoanResult({
    required this.loanAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.monthlyEmi,
    required this.totalInterest,
    required this.totalPayment,
  });
}

class PersonalLoanCalculator {
  PersonalLoanCalculator._();

  static PersonalLoanResult calculate({
    required double loanAmount,
    required double annualInterestRate,
    required int tenureMonths,
  }) {
    if (loanAmount <= 0) {
      throw ArgumentError('Loan amount must be greater than zero.');
    }

    if (annualInterestRate < 0) {
      throw ArgumentError('Interest rate cannot be negative.');
    }

    if (tenureMonths <= 0) {
      throw ArgumentError('Tenure must be greater than zero.');
    }

    final monthlyRate = annualInterestRate / 12 / 100;

    double emi;

    if (monthlyRate == 0) {
      emi = loanAmount / tenureMonths;
    } else {
      final factor = _pow(1 + monthlyRate, tenureMonths);

      emi = loanAmount * monthlyRate * factor / (factor - 1);
    }

    final totalPayment = emi * tenureMonths;
    final totalInterest = totalPayment - loanAmount;

    return PersonalLoanResult(
      loanAmount: loanAmount,
      interestRate: annualInterestRate,
      tenureMonths: tenureMonths,
      monthlyEmi: emi,
      totalInterest: totalInterest,
      totalPayment: totalPayment,
    );
  }

  static double _pow(double base, int exponent) {
    double result = 1;

    for (var i = 0; i < exponent; i++) {
      result *= base;
    }

    return result;
  }
}
