class CagrInput {
  final double initialInvestment;
  final double finalValue;
  final double periodYears;

  const CagrInput({
    required this.initialInvestment,
    required this.finalValue,
    required this.periodYears,
  });
}

class CagrResult {
  final double initialInvestment;
  final double finalValue;
  final double profit;
  final double growthPercentage;
  final double cagr;
  final double periodYears;

  const CagrResult({
    required this.initialInvestment,
    required this.finalValue,
    required this.profit,
    required this.growthPercentage,
    required this.cagr,
    required this.periodYears,
  });
}
