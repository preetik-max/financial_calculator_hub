import 'dart:math' as math;

import 'home_loan_model.dart';

class HomeLoanCalculator {
  HomeLoanCalculator._();

  static HomeLoanResult calculate(HomeLoanInput input) {
    final double principal = input.loanAmount;
    final double annualRate = input.annualInterestRate;
    final int years = input.tenureYears;

    if (principal <= 0) {
      return const HomeLoanResult(
        loanAmount: 0,
        annualInterestRate: 0,
        tenureYears: 0,
        tenureMonths: 0,
        monthlyEmi: 0,
        totalInterest: 0,
        totalPayment: 0,
      );
    }

    if (years <= 0) {
      return HomeLoanResult(
        loanAmount: principal,
        annualInterestRate: annualRate,
        tenureYears: years,
        tenureMonths: 0,
        monthlyEmi: 0,
        totalInterest: 0,
        totalPayment: 0,
      );
    }

    final int months = years * 12;

    final double monthlyRate = annualRate / 12 / 100;

    double monthlyEmi;

    // Zero-interest case.
    if (monthlyRate == 0) {
      monthlyEmi = principal / months;
    } else {
      final double factor = math.pow(1 + monthlyRate, months).toDouble();

      monthlyEmi = principal * monthlyRate * factor / (factor - 1);
    }

    final double totalPayment = monthlyEmi * months;

    final double totalInterest = math
        .max(0, totalPayment - principal)
        .toDouble();

    return HomeLoanResult(
      loanAmount: principal,
      annualInterestRate: annualRate,
      tenureYears: years,
      tenureMonths: months,
      monthlyEmi: monthlyEmi,
      totalInterest: totalInterest,
      totalPayment: totalPayment,
    );
  }
}
