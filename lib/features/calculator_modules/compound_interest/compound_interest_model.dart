enum CompoundingFrequency { yearly, halfYearly, quarterly, monthly }

extension CompoundingFrequencyExtension on CompoundingFrequency {
  String get label {
    switch (this) {
      case CompoundingFrequency.yearly:
        return 'Yearly';
      case CompoundingFrequency.halfYearly:
        return 'Half-yearly';
      case CompoundingFrequency.quarterly:
        return 'Quarterly';
      case CompoundingFrequency.monthly:
        return 'Monthly';
    }
  }

  int get periodsPerYear {
    switch (this) {
      case CompoundingFrequency.yearly:
        return 1;
      case CompoundingFrequency.halfYearly:
        return 2;
      case CompoundingFrequency.quarterly:
        return 4;
      case CompoundingFrequency.monthly:
        return 12;
    }
  }
}

class CompoundInterestInput {
  final double principal;
  final double annualRate;
  final double timeYears;
  final CompoundingFrequency frequency;

  const CompoundInterestInput({
    required this.principal,
    required this.annualRate,
    required this.timeYears,
    required this.frequency,
  });
}

class CompoundInterestResult {
  final double principal;
  final double annualRate;
  final double timeYears;
  final CompoundingFrequency frequency;

  final double compoundInterest;
  final double maturityAmount;

  const CompoundInterestResult({
    required this.principal,
    required this.annualRate,
    required this.timeYears,
    required this.frequency,
    required this.compoundInterest,
    required this.maturityAmount,
  });

  double get principalPercentage {
    if (maturityAmount <= 0) {
      return 0;
    }

    return (principal / maturityAmount) * 100;
  }

  double get interestPercentage {
    if (maturityAmount <= 0) {
      return 0;
    }

    return (compoundInterest / maturityAmount) * 100;
  }
}
