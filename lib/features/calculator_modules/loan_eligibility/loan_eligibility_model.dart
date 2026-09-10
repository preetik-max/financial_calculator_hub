enum EmploymentType {
  salaried,
  selfEmployed,
}

class LoanEligibilityInput {
  final double monthlyIncome;
  final double existingEmi;
  final int age;
  final int creditScore;
  final EmploymentType employmentType;
  final int tenureYears;

  const LoanEligibilityInput({
    required this.monthlyIncome,
    required this.existingEmi,
    required this.age,
    required this.creditScore,
    required this.employmentType,
    required this.tenureYears,
  });
}

class LoanEligibilityResult {
  final String loanType;
  final double minimumAmount;
  final double maximumAmount;
  final String description;

  const LoanEligibilityResult({
    required this.loanType,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.description,
  });
}