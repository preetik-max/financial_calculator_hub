enum PercentageMode { percentageOf, whatPercentage, increaseDecrease }

class PercentageInput {
  final PercentageMode mode;
  final double firstValue;
  final double secondValue;

  const PercentageInput({
    required this.mode,
    required this.firstValue,
    required this.secondValue,
  });
}

class PercentageResult {
  final PercentageMode mode;
  final double firstValue;
  final double secondValue;
  final double result;
  final double percentageChange;

  const PercentageResult({
    required this.mode,
    required this.firstValue,
    required this.secondValue,
    required this.result,
    required this.percentageChange,
  });

  bool get isIncrease => mode == PercentageMode.increaseDecrease && result >= 0;

  bool get isDecrease => mode == PercentageMode.increaseDecrease && result < 0;
}
