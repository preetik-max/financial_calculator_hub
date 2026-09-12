import 'dart:math' as math;

import 'fd_model.dart';

class FdCalculator {
  FdCalculator._();

  static FdResult calculate(FdInput input) {
    final double principal = input.principal;
    final double annualRate = input.annualInterestRate;
    final int years = input.tenureYears;
    final int frequency = input.compoundingFrequency;

    if (principal <= 0 || years <= 0) {
      return FdResult(
        principal: math.max(0, principal).toDouble(),
        annualInterestRate: math.max(0, annualRate).toDouble(),
        tenureYears: math.max(0, years),
        compoundingFrequency: frequency,
        maturityAmount: math.max(0, principal).toDouble(),
        totalInterest: 0,
      );
    }

    if (annualRate <= 0) {
      return FdResult(
        principal: principal,
        annualInterestRate: annualRate,
        tenureYears: years,
        compoundingFrequency: frequency,
        maturityAmount: principal,
        totalInterest: 0,
      );
    }

    final int safeFrequency = frequency <= 0 ? 4 : frequency;

    /*
     * Compound interest formula:
     *
     * A = P × (1 + r/n)^(n×t)
     *
     * P = Principal
     * r = Annual interest rate
     * n = Number of compounding periods per year
     * t = Tenure in years
     */

    final double rate = annualRate / 100;

    final double maturityAmount =
        principal * math.pow(1 + rate / safeFrequency, safeFrequency * years);

    final double totalInterest = math
        .max(0, maturityAmount - principal)
        .toDouble();

    return FdResult(
      principal: principal,
      annualInterestRate: annualRate,
      tenureYears: years,
      compoundingFrequency: safeFrequency,
      maturityAmount: maturityAmount,
      totalInterest: totalInterest,
    );
  }
}
