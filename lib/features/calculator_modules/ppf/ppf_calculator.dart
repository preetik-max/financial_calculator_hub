import 'ppf_model.dart';

class PpfCalculator {
  PpfCalculator._();

  static PpfResult calculate(PpfInput input) {
    final double annualInvestment = input.annualInvestment;
    final double annualRate = input.annualInterestRate;
    final int years = input.tenureYears;

    if (annualInvestment <= 0 || years <= 0) {
      return PpfResult(
        annualInvestment: annualInvestment > 0 ? annualInvestment : 0,
        annualInterestRate: annualRate >= 0 ? annualRate : 0,
        tenureYears: years > 0 ? years : 0,
        totalInvestment: 0,
        totalInterest: 0,
        maturityAmount: 0,
      );
    }

    if (annualRate < 0) {
      return PpfResult(
        annualInvestment: annualInvestment,
        annualInterestRate: 0,
        tenureYears: years,
        totalInvestment: annualInvestment * years,
        totalInterest: 0,
        maturityAmount: annualInvestment * years,
      );
    }

    /*
     * PPF calculation model:
     *
     * Annual contribution is assumed to be made at the
     * beginning of each financial year.
     *
     * Interest is then compounded annually.
     *
     * This gives the commonly used PPF calculator approximation
     * for an annual-investment input.
     */

    final double rate = annualRate / 100;

    double balance = 0;
    double totalInvestment = 0;

    for (int year = 1; year <= years; year++) {
      balance += annualInvestment;
      totalInvestment += annualInvestment;

      final double interest = balance * rate;

      balance += interest;
    }

    final double maturityAmount = balance;

    final double totalInterest = (maturityAmount - totalInvestment).clamp(
      0,
      double.infinity,
    );

    return PpfResult(
      annualInvestment: annualInvestment,
      annualInterestRate: annualRate,
      tenureYears: years,
      totalInvestment: totalInvestment,
      totalInterest: totalInterest,
      maturityAmount: maturityAmount,
    );
  }
}
