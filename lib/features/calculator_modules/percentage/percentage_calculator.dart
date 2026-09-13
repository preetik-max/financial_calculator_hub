import 'percentage_model.dart';

class PercentageCalculator {
  PercentageCalculator._();

  static PercentageResult calculate(PercentageInput input) {
    final double first = input.firstValue;
    final double second = input.secondValue;

    switch (input.mode) {
      // X% of Y
      //
      // Result = (X / 100) × Y
      case PercentageMode.percentageOf:
        final double result = (first / 100) * second;

        return PercentageResult(
          mode: input.mode,
          firstValue: first,
          secondValue: second,
          result: result,
          percentageChange: first,
        );

      // X is what % of Y?
      //
      // Result = (X / Y) × 100
      case PercentageMode.whatPercentage:
        if (second == 0) {
          return PercentageResult(
            mode: input.mode,
            firstValue: first,
            secondValue: second,
            result: 0,
            percentageChange: 0,
          );
        }

        final double result = (first / second) * 100;

        return PercentageResult(
          mode: input.mode,
          firstValue: first,
          secondValue: second,
          result: result,
          percentageChange: result,
        );

      // Percentage increase/decrease
      //
      // Change = New - Old
      // Percentage change = ((New - Old) / Old) × 100
      case PercentageMode.increaseDecrease:
        if (second == 0) {
          return PercentageResult(
            mode: input.mode,
            firstValue: first,
            secondValue: second,
            result: 0,
            percentageChange: 0,
          );
        }

        final double change = first - second;
        final double percentageChange = (change / second) * 100;

        return PercentageResult(
          mode: input.mode,
          firstValue: first,
          secondValue: second,
          result: change,
          percentageChange: percentageChange,
        );
    }
  }
}
