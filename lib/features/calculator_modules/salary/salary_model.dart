class SalaryInput {
  final double monthlyGross;
  final double pfPercent;
  final double professionalTax;
  final double otherDeductions;

  const SalaryInput({
    required this.monthlyGross,
    required this.pfPercent,
    required this.professionalTax,
    required this.otherDeductions,
  });
}

class SalaryResult {
  final double monthlyGross;
  final double monthlyPf;
  final double monthlyProfessionalTax;
  final double monthlyOtherDeductions;
  final double monthlyTotalDeductions;
  final double monthlyInHand;
  final double annualGross;
  final double annualDeductions;
  final double annualInHand;

  const SalaryResult({
    required this.monthlyGross,
    required this.monthlyPf,
    required this.monthlyProfessionalTax,
    required this.monthlyOtherDeductions,
    required this.monthlyTotalDeductions,
    required this.monthlyInHand,
    required this.annualGross,
    required this.annualDeductions,
    required this.annualInHand,
  });
}
