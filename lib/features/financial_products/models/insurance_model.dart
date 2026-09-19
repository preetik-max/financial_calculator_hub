class InsuranceModel {
  final String id;
  final String providerName;
  final String productName;
  final String logoAsset;
  final String insuranceType;
  final String coverage;
  final String description;
  final List<String> benefits;
  final String eligibility;
  final String affiliateUrl;

  const InsuranceModel({
    required this.id,
    required this.providerName,
    required this.productName,
    required this.logoAsset,
    required this.insuranceType,
    required this.coverage,
    required this.description,
    required this.benefits,
    required this.eligibility,
    required this.affiliateUrl,
  });
}
