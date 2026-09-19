class CreditCardModel {
  final String id;
  final String bankName;
  final String cardName;
  final String logoAsset;
  final String joiningFee;
  final String annualFee;
  final String description;
  final List<String> benefits;
  final String eligibility;
  final String affiliateUrl;

  const CreditCardModel({
    required this.id,
    required this.bankName,
    required this.cardName,
    required this.logoAsset,
    required this.joiningFee,
    required this.annualFee,
    required this.description,
    required this.benefits,
    required this.eligibility,
    required this.affiliateUrl,
  });
}
