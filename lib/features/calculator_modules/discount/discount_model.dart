class DiscountInput {
  final double originalPrice;
  final double discountPercent;

  const DiscountInput({
    required this.originalPrice,
    required this.discountPercent,
  });
}

class DiscountResult {
  final double originalPrice;
  final double discountPercent;
  final double discountAmount;
  final double finalPrice;

  const DiscountResult({
    required this.originalPrice,
    required this.discountPercent,
    required this.discountAmount,
    required this.finalPrice,
  });

  double get savingsPercent => discountPercent;

  double get finalPricePercent {
    if (originalPrice <= 0) {
      return 0;
    }

    return (finalPrice / originalPrice) * 100;
  }
}
