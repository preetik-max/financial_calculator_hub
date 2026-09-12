import 'dart:math' as math;

import 'cagr_model.dart';

class CagrCalculator {
  CagrCalculator._();

  /// CAGR formula:
  ///
  /// CAGR = (Final Value / Initial Value) ^ (1 / Years) - 1
  ///
  /// Example:
  /// Initial = ₹1,00,000
  /// Final   = ₹2,00,000
  /// Period  = 5 years
  ///
  /// CAGR ≈ 14.87%
  static CagrResult? calculate(CagrInput input) {
    final double initial = input.initialInvestment;
    final double finalValue = input.finalValue;
    final double years = input.periodYears;

    if (initial <= 0) {
      return null;
    }

    if (finalValue <= 0) {
      return null;
    }

    if (years <= 0) {
      return null;
    }

    final double cagrDecimal =
        math.pow(finalValue / initial, 1.0 / years).toDouble() - 1.0;

    final double cagrPercentage = cagrDecimal * 100.0;

    final double profit = finalValue - initial;

    final double growthPercentage = (profit / initial) * 100.0;

    return CagrResult(
      initialInvestment: initial,
      finalValue: finalValue,
      profit: profit,
      growthPercentage: growthPercentage,
      cagr: cagrPercentage,
      periodYears: years,
    );
  }
}
