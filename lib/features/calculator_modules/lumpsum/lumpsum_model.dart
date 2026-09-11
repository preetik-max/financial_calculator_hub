class LumpsumInput {
  final double investmentAmount;
  final double annualReturnRate;
  final int investmentPeriodYears;

  const LumpsumInput({
    required this.investmentAmount,
    required this.annualReturnRate,
    required this.investmentPeriodYears,
  });
}

class LumpsumResult {
  final double investedAmount;
  final double estimatedReturns;
  final double maturityValue;
  final double annualReturnRate;
  final int investmentPeriodYears;

  const LumpsumResult({
    required this.investedAmount,
    required this.estimatedReturns,
    required this.maturityValue,
    required this.annualReturnRate,
    required this.investmentPeriodYears,
  });

  double get investedPercentage {
    if (maturityValue <= 0) {
      return 0;
    }

    return (investedAmount / maturityValue) * 100;
  }

  double get returnsPercentage {
    if (maturityValue <= 0) {
      return 0;
    }

    return (estimatedReturns / maturityValue) * 100;
  }
}
