import 'dart:math' as math;

import 'rd_model.dart';

class RdCalculator {
  RdCalculator._();

  /// Calculates recurring deposit maturity.
  ///
  /// The calculation uses quarterly compounding and calculates
  /// each monthly installment separately because every installment
  /// remains invested for a different period.
  static RdResult calculate(RdInput input) {
    final double monthlyDeposit = input.monthlyDeposit;
    final double annualRate = input.annualInterestRate;
    final int years = input.tenureYears;

    if (monthlyDeposit <= 0 || years <= 0) {
      return const RdResult(
        monthlyDeposit: 0,
        annualInterestRate: 0,
        tenureYears: 0,
        tenureMonths: 0,
        totalDeposited: 0,
        interestEarned: 0,
        maturityAmount: 0,
      );
    }

    final int months = years * 12;

    final double quarterlyRate = annualRate / 4 / 100;

    double maturityAmount = 0;

    for (int month = 1; month <= months; month++) {
      final double quarters = (months - month + 1) / 3;

      final double factor = quarterlyRate == 0
          ? 1
          : math.pow(1 + quarterlyRate, quarters).toDouble();

      maturityAmount += monthlyDeposit * factor;
    }

    final double totalDeposited = monthlyDeposit * months;

    final double interestEarned = math
        .max(0, maturityAmount - totalDeposited)
        .toDouble();

    return RdResult(
      monthlyDeposit: monthlyDeposit,
      annualInterestRate: annualRate,
      tenureYears: years,
      tenureMonths: months,
      totalDeposited: totalDeposited,
      interestEarned: interestEarned,
      maturityAmount: maturityAmount,
    );
  }
}
