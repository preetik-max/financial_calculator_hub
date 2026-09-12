class InflationInput {
  final double currentAmount;
  final double inflationRate;
  final int years;

  const InflationInput({
    required this.currentAmount,
    required this.inflationRate,
    required this.years,
  });
}

class InflationResult {
  final double currentAmount;
  final double inflationRate;
  final int years;

  final double futureCost;
  final double inflationIncrease;
  final double purchasingPower;
  final double increasePercentage;

  const InflationResult({
    required this.currentAmount,
    required this.inflationRate,
    required this.years,
    required this.futureCost,
    required this.inflationIncrease,
    required this.purchasingPower,
    required this.increasePercentage,
  });

  double get currentValuePercentage {
    if (futureCost <= 0) {
      return 0;
    }

    return (currentAmount / futureCost) * 100;
  }

  double get inflationPercentage {
    if (futureCost <= 0) {
      return 0;
    }

    return (inflationIncrease / futureCost) * 100;
  }
}
