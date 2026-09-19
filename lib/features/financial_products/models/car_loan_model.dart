class CarLoanModel {
  final String id;
  final String bankName;
  final String productName;
  final String logoAsset;
  final String loanAmount;
  final String tenure;
  final String interestRate;
  final String processingFee;
  final String description;
  final List<String> benefits;
  final String eligibility;
  final String affiliateUrl;

  const CarLoanModel({
    required this.id,
    required this.bankName,
    required this.productName,
    required this.logoAsset,
    required this.loanAmount,
    required this.tenure,
    required this.interestRate,
    required this.processingFee,
    required this.description,
    required this.benefits,
    required this.eligibility,
    required this.affiliateUrl,
  });
}
