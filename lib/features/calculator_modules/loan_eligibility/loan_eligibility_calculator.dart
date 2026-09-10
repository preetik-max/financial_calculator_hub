import 'dart:math' as math;

import 'loan_eligibility_model.dart';

class LoanEligibilityCalculator {
  LoanEligibilityCalculator._();

  static List<LoanEligibilityResult> calculate(LoanEligibilityInput input) {
    final double income = input.monthlyIncome.toDouble();
    final double existingEmi = input.existingEmi.toDouble();

    if (income <= 0) {
      return [];
    }

    // ---------------------------------------------------------------------------
    // Indicative FOIR assumptions
    // ---------------------------------------------------------------------------
    //
    // FOIR = Fixed Obligation to Income Ratio.
    //
    // This is an educational estimate only.
    // Actual eligibility depends on the lender, income proof,
    // credit history, obligations, property/vehicle, etc.
    //
    double foir;

    if (input.creditScore >= 750) {
      foir = 0.50;
    } else if (input.creditScore >= 700) {
      foir = 0.45;
    } else if (input.creditScore >= 650) {
      foir = 0.40;
    } else {
      foir = 0.35;
    }

    if (input.employmentType == EmploymentType.selfEmployed) {
      foir -= 0.05;
    }

    final double maximumTotalEmi = income * foir;

    final double availableEmi = math
        .max(0.0, maximumTotalEmi - existingEmi)
        .toDouble();

    if (availableEmi <= 0) {
      return [
        const LoanEligibilityResult(
          loanType: 'Personal Loan',
          minimumAmount: 0,
          maximumAmount: 0,
          description: 'No additional EMI capacity based on the current inputs',
        ),
        const LoanEligibilityResult(
          loanType: 'Home Loan',
          minimumAmount: 0,
          maximumAmount: 0,
          description: 'No additional EMI capacity based on the current inputs',
        ),
        const LoanEligibilityResult(
          loanType: 'Car Loan',
          minimumAmount: 0,
          maximumAmount: 0,
          description: 'No additional EMI capacity based on the current inputs',
        ),
        const LoanEligibilityResult(
          loanType: 'Education Loan',
          minimumAmount: 0,
          maximumAmount: 0,
          description: 'No additional EMI capacity based on the current inputs',
        ),
      ];
    }

    return [
      _calculatePersonalLoan(
        availableEmi,
        input.tenureYears,
        input.creditScore,
        input.age,
      ),
      _calculateHomeLoan(availableEmi, input.creditScore, input.age),
      _calculateCarLoan(
        availableEmi,
        input.tenureYears,
        input.creditScore,
        input.age,
      ),
      _calculateEducationLoan(availableEmi, input.creditScore),
    ];
  }

  // ---------------------------------------------------------------------------
  // Personal Loan
  // ---------------------------------------------------------------------------

  static LoanEligibilityResult _calculatePersonalLoan(
    double availableEmi,
    int tenureYears,
    int creditScore,
    int age,
  ) {
    const double annualRate = 0.13;

    final int safeTenure = tenureYears.clamp(1, 7);

    final double amount = _loanFromEmi(
      availableEmi * 0.75,
      annualRate,
      safeTenure,
    );

    final double adjusted = _adjustForProfile(amount, creditScore, age);

    return LoanEligibilityResult(
      loanType: 'Personal Loan',
      minimumAmount: adjusted * 0.75,
      maximumAmount: adjusted,
      description: 'Estimated unsecured loan eligibility',
    );
  }

  // ---------------------------------------------------------------------------
  // Home Loan
  // ---------------------------------------------------------------------------

  static LoanEligibilityResult _calculateHomeLoan(
    double availableEmi,
    int creditScore,
    int age,
  ) {
    const double annualRate = 0.085;
    const int tenureYears = 20;

    final double amount = _loanFromEmi(
      availableEmi * 0.90,
      annualRate,
      tenureYears,
    );

    final double adjusted = _adjustForProfile(amount, creditScore, age);

    return LoanEligibilityResult(
      loanType: 'Home Loan',
      minimumAmount: adjusted * 0.80,
      maximumAmount: adjusted,
      description: 'Estimated home loan eligibility',
    );
  }

  // ---------------------------------------------------------------------------
  // Car Loan
  // ---------------------------------------------------------------------------

  static LoanEligibilityResult _calculateCarLoan(
    double availableEmi,
    int tenureYears,
    int creditScore,
    int age,
  ) {
    const double annualRate = 0.095;

    final int safeTenure = tenureYears.clamp(3, 7);

    final double amount = _loanFromEmi(
      availableEmi * 0.60,
      annualRate,
      safeTenure,
    );

    final double adjusted = _adjustForProfile(amount, creditScore, age);

    return LoanEligibilityResult(
      loanType: 'Car Loan',
      minimumAmount: adjusted * 0.80,
      maximumAmount: adjusted,
      description: 'Estimated vehicle loan eligibility',
    );
  }

  // ---------------------------------------------------------------------------
  // Education Loan
  // ---------------------------------------------------------------------------

  static LoanEligibilityResult _calculateEducationLoan(
    double availableEmi,
    int creditScore,
  ) {
    final double incomeBasedAmount = availableEmi * 60.0;

    final double amount = math.min(incomeBasedAmount, 1000000.0).toDouble();

    final double adjusted = _adjustForCreditScore(amount, creditScore);

    return LoanEligibilityResult(
      loanType: 'Education Loan',
      minimumAmount: adjusted * 0.70,
      maximumAmount: adjusted,
      description: 'Indicative education loan estimate',
    );
  }

  // ---------------------------------------------------------------------------
  // EMI -> Loan Amount
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
  // Profile adjustment
  // ---------------------------------------------------------------------------

  static double _adjustForProfile(double amount, int creditScore, int age) {
    double multiplier = 1.0;

    if (creditScore >= 800) {
      multiplier = 1.05;
    } else if (creditScore >= 750) {
      multiplier = 1.00;
    } else if (creditScore >= 700) {
      multiplier = 0.90;
    } else if (creditScore >= 650) {
      multiplier = 0.75;
    } else {
      multiplier = 0.50;
    }

    // Indicative age adjustment.
    if (age < 23) {
      multiplier *= 0.85;
    } else if (age > 55) {
      multiplier *= 0.85;
    } else if (age > 50) {
      multiplier *= 0.92;
    }

    return amount * multiplier;
  }

  // ---------------------------------------------------------------------------
  // Credit score adjustment
  // ---------------------------------------------------------------------------

  static double _adjustForCreditScore(double amount, int creditScore) {
    if (creditScore >= 800) {
      return amount * 1.05;
    }

    if (creditScore >= 750) {
      return amount;
    }

    if (creditScore >= 700) {
      return amount * 0.90;
    }

    if (creditScore >= 650) {
      return amount * 0.75;
    }

    return amount * 0.50;
  }
}
