import '../../../core/affiliate/insurance_affiliate_config.dart';
import '../models/insurance_model.dart';

class InsuranceData {
  InsuranceData._();

  static const List<InsuranceModel> products = [
    InsuranceModel(
      id: InsuranceAffiliateConfig.sbiId,
      providerName: 'SBI',
      productName: 'SBI Insurance',
      logoAsset: 'assets/images/insurance/sbi.png',
      insuranceType: 'Insurance',
      coverage: 'As per selected plan',
      description:
          'Explore insurance options from SBI and connect through our partner.',
      benefits: [
        'Multiple insurance options',
        'Plan-based coverage',
        'Online enquiry/application',
      ],
      eligibility:
          'Coverage, premium and eligibility depend on the selected insurance product.',
      affiliateUrl: InsuranceAffiliateConfig.sbiUrl,
    ),
    InsuranceModel(
      id: InsuranceAffiliateConfig.hdfcId,
      providerName: 'HDFC',
      productName: 'HDFC Insurance',
      logoAsset: 'assets/images/insurance/hdfc.png',
      insuranceType: 'Insurance',
      coverage: 'As per selected plan',
      description:
          'Explore insurance options from HDFC and connect through our partner.',
      benefits: [
        'Multiple insurance options',
        'Plan-based coverage',
        'Online enquiry/application',
      ],
      eligibility:
          'Coverage, premium and eligibility depend on the selected insurance product.',
      affiliateUrl: InsuranceAffiliateConfig.hdfcUrl,
    ),
    InsuranceModel(
      id: InsuranceAffiliateConfig.axisId,
      providerName: 'Axis',
      productName: 'Axis Insurance',
      logoAsset: 'assets/images/insurance/axis.png',
      insuranceType: 'Insurance',
      coverage: 'As per selected plan',
      description:
          'Explore insurance options from Axis and connect through our partner.',
      benefits: [
        'Multiple insurance options',
        'Plan-based coverage',
        'Online enquiry/application',
      ],
      eligibility:
          'Coverage, premium and eligibility depend on the selected insurance product.',
      affiliateUrl: InsuranceAffiliateConfig.axisUrl,
    ),
    InsuranceModel(
      id: InsuranceAffiliateConfig.iciciId,
      providerName: 'ICICI',
      productName: 'ICICI Insurance',
      logoAsset: 'assets/images/insurance/icici.png',
      insuranceType: 'Insurance',
      coverage: 'As per selected plan',
      description:
          'Explore insurance options from ICICI and connect through our partner.',
      benefits: [
        'Multiple insurance options',
        'Plan-based coverage',
        'Online enquiry/application',
      ],
      eligibility:
          'Coverage, premium and eligibility depend on the selected insurance product.',
      affiliateUrl: InsuranceAffiliateConfig.iciciUrl,
    ),
  ];
}
