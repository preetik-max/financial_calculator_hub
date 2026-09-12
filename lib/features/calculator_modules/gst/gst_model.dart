enum GstCalculationMode { addGst, removeGst }

class GstInput {
  final double amount;
  final double gstRate;
  final GstCalculationMode mode;

  const GstInput({
    required this.amount,
    required this.gstRate,
    required this.mode,
  });
}

class GstResult {
  final double originalAmount;
  final double gstRate;
  final GstCalculationMode mode;

  final double baseAmount;
  final double gstAmount;
  final double finalAmount;

  const GstResult({
    required this.originalAmount,
    required this.gstRate,
    required this.mode,
    required this.baseAmount,
    required this.gstAmount,
    required this.finalAmount,
  });

  double get basePercentage {
    if (finalAmount <= 0) {
      return 0;
    }

    return (baseAmount / finalAmount) * 100;
  }

  double get gstPercentage {
    if (finalAmount <= 0) {
      return 0;
    }

    return (gstAmount / finalAmount) * 100;
  }
}
