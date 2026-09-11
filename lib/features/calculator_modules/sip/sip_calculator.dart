import 'dart:math' as math;

import 'sip_model.dart';

class SipCalculator {
  SipCalculator._();

  /// Standard monthly SIP calculation.
  ///
  /// This implementation assumes the SIP contribution is made
  /// at the END of each month.
  ///
  /// FV = P × [((1 + r)^n - 1) / r]
  ///
  /// P = monthly SIP investment
  /// r = monthly return rate
  /// n = total number of months
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

    final double monthlyRate = annualReturn / 100.0 / 12.0;

    double maturityValue;

    if (monthlyRate == 0) {
      maturityValue = investedAmount;
    } else {
      final double factor =
      math.pow(1.0 + monthlyRate, months).toDouble();

      // END-OF-MONTH SIP
      maturityValue =
          monthlyInvestment *
              ((factor - 1.0) / monthlyRate);
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