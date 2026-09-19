class FixedDepositModel {
  final String id;
  final String bankName;
  final String productName;
  final String logoAsset;
  final String minimumDeposit;
  final String tenure;
  final String interestRate;
  final String description;
  final List<String> benefits;
  final String eligibility;
  final String affiliateUrl;

  const FixedDepositModel({
    required this.id,
    required this.bankName,
    required this.productName,
    required this.logoAsset,
    required this.minimumDeposit,
    required this.tenure,
    required this.interestRate,
    required this.description,
    required this.benefits,
    required this.eligibility,
    required this.affiliateUrl,
  });
}
