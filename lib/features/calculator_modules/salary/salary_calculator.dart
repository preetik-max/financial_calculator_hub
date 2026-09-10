import 'salary_model.dart';

class SalaryCalculator {
  SalaryCalculator._();

  static SalaryResult calculate(SalaryInput input) {
    final gross = input.monthlyGross < 0 ? 0.0 : input.monthlyGross;

    final pfPercent = input.pfPercent.clamp(0.0, 100.0).toDouble();

    final pf = gross * pfPercent / 100.0;

    final professionalTax = input.professionalTax < 0
        ? 0.0
        : input.professionalTax;

    final otherDeductions = input.otherDeductions < 0
        ? 0.0
        : input.otherDeductions;

    final totalDeductions = pf + professionalTax + otherDeductions;

    final inHand = (gross - totalDeductions)
        .clamp(0.0, double.infinity)
        .toDouble();

    return SalaryResult(
      monthlyGross: gross,
      monthlyPf: pf,
      monthlyProfessionalTax: professionalTax,
      monthlyOtherDeductions: otherDeductions,
      monthlyTotalDeductions: totalDeductions,
      monthlyInHand: inHand,
      annualGross: gross * 12,
      annualDeductions: totalDeductions * 12,
      annualInHand: inHand * 12,
    );
  }
}
