import 'dart:math' as math;

import 'loan_eligibility_model.dart';

class LoanEligibilityCalculator {
  LoanEligibilityCalculator._();

  /// Calculates indicative loan eligibility.
  ///
  /// IMPORTANT:
  /// This is an educational/planning estimate.
  /// Actual lender eligibility may differ based on lender policy,
  /// income verification, credit history, existing obligations,
  /// property/vehicle value, age, employment profile and other factors.
  static List<LoanEligibilityResult> calculate(LoanEligibilityInput input) {
    final double income = math.max(0.0, input.monthlyIncome);
    final double existingEmi = math.max(0.0, input.existingEmi);

    if (income <= 0) {
      return [];
    }

    final int creditScore = input.creditScore.clamp(300, 900);
    final int age = input.age.clamp(18, 70);

    // ---------------------------------------------------------------------------
    // 1. Determine indicative FOIR
    // ---------------------------------------------------------------------------
    //
    // FOIR = Fixed Obligations to Income Ratio.
    //
    // The existing EMI is deducted from the maximum total EMI capacity.
    //
    double foir = _foirForCreditScore(creditScore);

    // Self-employed profiles are given a slightly more conservative
    // assumption because income can vary more significantly.
    if (input.employmentType == EmploymentType.selfEmployed) {
      foir -= 0.05;
    }

    foir = foir.clamp(0.30, 0.50);

    final double maximumTotalEmi = income * foir;

    final double availableEmi = math.max(0.0, maximumTotalEmi - existingEmi);

    if (availableEmi <= 0) {
      return _noEligibilityResults();
    }

    // ---------------------------------------------------------------------------
    // 2. Credit-score factor
    // ---------------------------------------------------------------------------
    //
    // Credit score affects the indicative amount conservatively.
    // We do NOT increase the amount above the base EMI capacity.
    //
    final double creditFactor = _creditScoreFactor(creditScore);

    // ---------------------------------------------------------------------------
    // 3. Calculate each loan type
    // ---------------------------------------------------------------------------

    return [
      _calculatePersonalLoan(
        availableEmi: availableEmi,
        tenureYears: input.tenureYears,
        creditFactor: creditFactor,
        age: age,
      ),
      _calculateHomeLoan(
        availableEmi: availableEmi,
        creditFactor: creditFactor,
        age: age,
      ),
      _calculateCarLoan(
        availableEmi: availableEmi,
        tenureYears: input.tenureYears,
        creditFactor: creditFactor,
        age: age,
      ),
      _calculateEducationLoan(
        availableEmi: availableEmi,
        creditFactor: creditFactor,
      ),
    ];
  }

  // ---------------------------------------------------------------------------
  // FOIR
  // ---------------------------------------------------------------------------

  static double _foirForCreditScore(int creditScore) {
    if (creditScore >= 750) {
      return 0.50;
    }

    if (creditScore >= 700) {
      return 0.45;
    }

    if (creditScore >= 650) {
      return 0.40;
    }

    return 0.35;
  }

  // ---------------------------------------------------------------------------
  // Credit score factor
  // ---------------------------------------------------------------------------

  static double _creditScoreFactor(int creditScore) {
    if (creditScore >= 800) {
      return 1.00;
    }

    if (creditScore >= 750) {
      return 1.00;
    }

    if (creditScore >= 700) {
      return 0.90;
    }

    if (creditScore >= 650) {
      return 0.80;
    }

    return 0.65;
  }

  // ---------------------------------------------------------------------------
  // Personal Loan
  // ---------------------------------------------------------------------------

  static LoanEligibilityResult _calculatePersonalLoan({
    required double availableEmi,
    required int tenureYears,
    required double creditFactor,
    required int age,
  }) {
    const double annualRate = 0.13;

    final int safeTenure = tenureYears.clamp(1, 7);

    final double ageFactor = _ageFactor(age, maximumAge: 60);

    final double amount = _loanFromEmi(availableEmi, annualRate, safeTenure);

    final double adjustedAmount = amount * creditFactor * ageFactor;

    return LoanEligibilityResult(
      loanType: 'Personal Loan',
      minimumAmount: _minimumRange(adjustedAmount, 0.80),
      maximumAmount: adjustedAmount,
      description: 'Indicative unsecured loan estimate based on EMI capacity',
    );
  }

  // ---------------------------------------------------------------------------
  // Home Loan
  // ---------------------------------------------------------------------------

  static LoanEligibilityResult _calculateHomeLoan({
    required double availableEmi,
    required double creditFactor,
    required int age,
  }) {
    const double annualRate = 0.085;
    const int tenureYears = 20;

    final double ageFactor = _ageFactor(age, maximumAge: 65);

    final double amount = _loanFromEmi(availableEmi, annualRate, tenureYears);

    final double adjustedAmount = amount * creditFactor * ageFactor;

    return LoanEligibilityResult(
      loanType: 'Home Loan',
      minimumAmount: _minimumRange(adjustedAmount, 0.85),
      maximumAmount: adjustedAmount,
      description: 'Indicative home loan estimate based on EMI capacity',
    );
  }

  // ---------------------------------------------------------------------------
  // Car Loan
  // ---------------------------------------------------------------------------

  static LoanEligibilityResult _calculateCarLoan({
    required double availableEmi,
    required int tenureYears,
    required double creditFactor,
    required int age,
  }) {
    const double annualRate = 0.095;

    final int safeTenure = tenureYears.clamp(3, 7);

    final double ageFactor = _ageFactor(age, maximumAge: 65);

    final double amount = _loanFromEmi(availableEmi, annualRate, safeTenure);

    final double adjustedAmount = amount * creditFactor * ageFactor;

    return LoanEligibilityResult(
      loanType: 'Car Loan',
      minimumAmount: _minimumRange(adjustedAmount, 0.85),
      maximumAmount: adjustedAmount,
      description: 'Indicative vehicle loan estimate based on EMI capacity',
    );
  }

  // ---------------------------------------------------------------------------
  // Education Loan
  // ---------------------------------------------------------------------------

  static LoanEligibilityResult _calculateEducationLoan({
    required double availableEmi,
    required double creditFactor,
  }) {
    // Education loans are highly dependent on course, institution,
    // collateral and lender policy. Therefore this is intentionally capped.
    const double annualRate = 0.095;
    const int tenureYears = 10;
    const double maximumAmount = 1000000.0;

    final double amount = _loanFromEmi(availableEmi, annualRate, tenureYears);

    final double adjustedAmount = math.min(
      amount * creditFactor,
      maximumAmount,
    );

    return LoanEligibilityResult(
      loanType: 'Education Loan',
      minimumAmount: _minimumRange(adjustedAmount, 0.75),
      maximumAmount: adjustedAmount,
      description:
          'Indicative education loan estimate; actual limits vary by lender',
    );
  }

  // ---------------------------------------------------------------------------
  // EMI -> Principal
  // ---------------------------------------------------------------------------

  static double _loanFromEmi(double emi, double annualRate, int years) {
    if (emi <= 0 || years <= 0) {
      return 0.0;
    }

    final double monthlyRate = annualRate / 12.0;
    final int months = years * 12;

    if (monthlyRate == 0) {
      return emi * months;
    }

    final double factor = math.pow(1.0 + monthlyRate, months).toDouble();

    return emi * ((factor - 1.0) / (monthlyRate * factor));
  }

  // ---------------------------------------------------------------------------
  // Age factor
  // ---------------------------------------------------------------------------

  static double _ageFactor(int age, {required int maximumAge}) {
    if (age < 21) {
      return 0.85;
    }

    if (age > maximumAge) {
      return 0.75;
    }

    if (age > 55) {
      return 0.90;
    }

    if (age > 50) {
      return 0.95;
    }

    return 1.00;
  }

  // ---------------------------------------------------------------------------
  // Result range
  // ---------------------------------------------------------------------------

  static double _minimumRange(double amount, double factor) {
    return math.max(0.0, amount * factor);
  }

  // ---------------------------------------------------------------------------
  // No eligibility
  // ---------------------------------------------------------------------------

  static List<LoanEligibilityResult> _noEligibilityResults() {
    const String message =
        'No additional EMI capacity based on the current inputs';

    return const [
      LoanEligibilityResult(
        loanType: 'Personal Loan',
        minimumAmount: 0,
        maximumAmount: 0,
        description: message,
      ),
      LoanEligibilityResult(
        loanType: 'Home Loan',
        minimumAmount: 0,
        maximumAmount: 0,
        description: message,
      ),
      LoanEligibilityResult(
        loanType: 'Car Loan',
        minimumAmount: 0,
        maximumAmount: 0,
        description: message,
      ),
      LoanEligibilityResult(
        loanType: 'Education Loan',
        minimumAmount: 0,
        maximumAmount: 0,
        description: message,
      ),
    ];
  }
}
