import 'dart:math' as math;

import 'lumpsum_model.dart';

class LumpsumCalculator {
  LumpsumCalculator._();

  static LumpsumResult? calculate(LumpsumInput input) {
    final double principal = input.investmentAmount;
    final double annualRate = input.annualReturnRate;
    final int years = input.investmentPeriodYears;

    if (principal <= 0) {
      return null;
    }

    if (annualRate < 0) {
      return null;
    }

    if (years <= 0) {
      return null;
    }

    /*
     * Standard lumpsum compound-growth formula:
     *
     * Maturity Value = P × (1 + r)^n
     *
     * P = initial investment
     * r = annual return rate / 100
     * n = investment period in years
     *
     * Example:
     *
     * ₹1,00,000
     * 12% annual return
     * 10 years
     *
     * = 100000 × (1.12)^10
     */

    final double rate = annualRate / 100.0;

    final double maturityValue =
        principal * math.pow(1.0 + rate, years).toDouble();

    final double estimatedReturns = math
        .max(0.0, maturityValue - principal)
        .toDouble();

    return LumpsumResult(
      investedAmount: principal,
      estimatedReturns: estimatedReturns,
      maturityValue: maturityValue,
      annualReturnRate: annualRate,
      investmentPeriodYears: years,
    );
  }
}
