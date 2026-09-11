import 'dart:math' as math;

import 'sip_model.dart';

class SipCalculator {
  SipCalculator._();

  /// Calculates SIP maturity value.
  ///
  /// Method:
  ///
  /// 1. Convert annual return into an effective monthly rate:
  ///
  ///    monthlyRate = (1 + annualRate)^(1/12) - 1
  ///
  /// 2. Calculate future value of monthly SIP:
  ///
  ///    FV = P × [((1 + r)^n - 1) / r] × (1 + r)
  ///
  /// P = monthly SIP investment
  /// r = effective monthly return
  /// n = number of monthly investments
  ///
  /// The final (1 + r) assumes the SIP contribution occurs
  /// at the beginning of each monthly period.
  static SipResult calculate(SipInput input) {
    final double monthlyInvestment = input.monthlyInvestment
        .clamp(0.0, 100000000.0)
        .toDouble();

    final double annualReturn = input.expectedReturn
        .clamp(0.0, 100.0)
        .toDouble();

    final int years = input.investmentYears.clamp(1, 50);

    if (monthlyInvestment <= 0) {
      return const SipResult(
        monthlyInvestment: 0,
        expectedReturn: 0,
        investmentYears: 0,
        totalMonths: 0,
        investedAmount: 0,
        estimatedReturns: 0,
        maturityValue: 0,
      );
    }

    final int months = years * 12;

    final double investedAmount = monthlyInvestment * months;

    // ---------------------------------------------------------------
    // Effective monthly return
    // ---------------------------------------------------------------
    //
    // Do NOT use:
    //
    // annualReturn / 12
    //
    // because that treats the annual percentage as a nominal
    // monthly rate.
    //
    // Instead:
    //
    // monthlyRate = (1 + annualRate)^(1/12) - 1
    //
    final double annualRateDecimal = annualReturn / 100.0;

    final double monthlyRate =
        math.pow(1.0 + annualRateDecimal, 1.0 / 12.0).toDouble() - 1.0;

    double maturityValue;

    // ---------------------------------------------------------------
    // Zero-return case
    // ---------------------------------------------------------------

    if (monthlyRate.abs() < 1e-12) {
      maturityValue = investedAmount;
    } else {
      final double factor = math.pow(1.0 + monthlyRate, months).toDouble();

      maturityValue =
          monthlyInvestment *
          ((factor - 1.0) / monthlyRate) *
          (1.0 + monthlyRate);
    }

    final double estimatedReturns = math
        .max(0.0, maturityValue - investedAmount)
        .toDouble();

    return SipResult(
      monthlyInvestment: monthlyInvestment,
      expectedReturn: annualReturn,
      investmentYears: years,
      totalMonths: months,
      investedAmount: investedAmount,
      estimatedReturns: estimatedReturns,
      maturityValue: maturityValue,
    );
  }
}
