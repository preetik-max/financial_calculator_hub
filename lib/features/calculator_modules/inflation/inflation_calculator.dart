import 'dart:math' as math;

import 'inflation_model.dart';

class InflationCalculator {
  InflationCalculator._();

  static InflationResult calculate(InflationInput input) {
    final double amount = input.currentAmount;
    final double rate = input.inflationRate;
    final int years = input.years;

    if (amount <= 0 || years <= 0) {
      return InflationResult(
        currentAmount: math.max(0, amount).toDouble(),
        inflationRate: math.max(0, rate).toDouble(),
        years: math.max(0, years),
        futureCost: math.max(0, amount).toDouble(),
        inflationIncrease: 0,
        purchasingPower: math.max(0, amount).toDouble(),
        increasePercentage: 0,
      );
    }

    final double annualFactor = 1 + (rate / 100);

    final double futureCost = amount * math.pow(annualFactor, years);

    final double inflationIncrease = math
        .max(0, futureCost - amount)
        .toDouble();

    final double purchasingPower = futureCost > 0
        ? (amount / futureCost) * 100
        : 0;

    final double increasePercentage = amount > 0
        ? ((futureCost - amount) / amount) * 100
        : 0;

    return InflationResult(
      currentAmount: amount,
      inflationRate: rate,
      years: years,
      futureCost: futureCost,
      inflationIncrease: inflationIncrease,
      purchasingPower: purchasingPower,
      increasePercentage: increasePercentage,
    );
  }
}
