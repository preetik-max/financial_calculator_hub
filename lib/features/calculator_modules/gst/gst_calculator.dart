import 'gst_model.dart';

class GstCalculator {
  GstCalculator._();

  static GstResult calculate(GstInput input) {
    final double amount = input.amount;
    final double rate = input.gstRate;

    if (amount <= 0 || rate < 0) {
      return GstResult(
        originalAmount: amount,
        gstRate: rate,
        mode: input.mode,
        baseAmount: 0,
        gstAmount: 0,
        finalAmount: 0,
      );
    }

    if (input.mode == GstCalculationMode.addGst) {
      final double gstAmount = amount * rate / 100;
      final double finalAmount = amount + gstAmount;

      return GstResult(
        originalAmount: amount,
        gstRate: rate,
        mode: input.mode,
        baseAmount: amount,
        gstAmount: gstAmount,
        finalAmount: finalAmount,
      );
    }

    // GST-inclusive amount:
    //
    // Base = Inclusive Amount × 100 / (100 + GST%)
    //
    // GST = Inclusive Amount - Base
    final double baseAmount = amount * 100 / (100 + rate);
    final double gstAmount = amount - baseAmount;

    return GstResult(
      originalAmount: amount,
      gstRate: rate,
      mode: input.mode,
      baseAmount: baseAmount,
      gstAmount: gstAmount,
      finalAmount: amount,
    );
  }
}
