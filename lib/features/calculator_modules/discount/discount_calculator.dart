import 'discount_model.dart';

class DiscountCalculator {
  DiscountCalculator._();

  static DiscountResult calculate(DiscountInput input) {
    final double price = input.originalPrice;
    final double discountPercent = input.discountPercent
        .clamp(0, 100)
        .toDouble();

    if (price <= 0) {
      return const DiscountResult(
        originalPrice: 0,
        discountPercent: 0,
        discountAmount: 0,
        finalPrice: 0,
      );
    }

    final double discountAmount = price * discountPercent / 100;
    final double finalPrice = price - discountAmount;

    return DiscountResult(
      originalPrice: price,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      finalPrice: finalPrice,
    );
  }
}
