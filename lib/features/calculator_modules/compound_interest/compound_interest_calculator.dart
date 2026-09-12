import 'dart:math' as math;

import 'compound_interest_model.dart';

class CompoundInterestCalculator {
  CompoundInterestCalculator._();

  static CompoundInterestResult calculate(CompoundInterestInput input) {
    final double principal = input.principal;
    final double annualRate = input.annualRate;
    final double timeYears = input.timeYears;

    if (principal <= 0 || timeYears <= 0) {
      return CompoundInterestResult(
        principal: principal > 0 ? principal : 0,
        annualRate: annualRate > 0 ? annualRate : 0,
        timeYears: timeYears > 0 ? timeYears : 0,
        frequency: input.frequency,
        compoundInterest: 0,
        maturityAmount: principal > 0 ? principal : 0,
      );
    }

    // If rate is zero, there is no interest.
    if (annualRate == 0) {
      return CompoundInterestResult(
        principal: principal,
        annualRate: 0,
        timeYears: timeYears,
        frequency: input.frequency,
        compoundInterest: 0,
        maturityAmount: principal,
      );
    }

    final int n = input.frequency.periodsPerYear;

    final double ratePerPeriod = annualRate / 100 / n;

    final double numberOfPeriods = n * timeYears;

    final double factor = math
        .pow(1 + ratePerPeriod, numberOfPeriods)
        .toDouble();

    final double maturityAmount = principal * factor;

    final double compoundInterest = math
        .max(0, maturityAmount - principal)
        .toDouble();

    return CompoundInterestResult(
      principal: principal,
      annualRate: annualRate,
      timeYears: timeYears,
      frequency: input.frequency,
      compoundInterest: compoundInterest,
      maturityAmount: maturityAmount,
    );
  }
}
