import '../../../core/affiliate/credit_card_affiliate_config.dart';
import '../models/credit_card_model.dart';

class CreditCardData {
  CreditCardData._();

  static const List<CreditCardModel> cards = [
    CreditCardModel(
      id: CreditCardAffiliateConfig.sbiId,
      bankName: 'SBI Card',
      cardName: 'SBI Credit Cards',
      logoAsset: 'assets/images/cards/sbi.png',
      joiningFee: 'Check offer',
      annualFee: 'Check offer',
      description:
          'Explore SBI credit card options and apply through our partner.',
      benefits: [
        'Multiple card options',
        'Reward and cashback options',
        'Online application',
      ],
      eligibility: 'Eligibility depends on the selected SBI credit card.',
      affiliateUrl: CreditCardAffiliateConfig.sbiUrl,
    ),

    CreditCardModel(
      id: CreditCardAffiliateConfig.hdfcId,
      bankName: 'HDFC Bank',
      cardName: 'HDFC Credit Cards',
      logoAsset: 'assets/images/cards/hdfc.png',
      joiningFee: 'Check offer',
      annualFee: 'Check offer',
      description:
          'Explore HDFC Bank credit card options and apply through our partner.',
      benefits: [
        'Multiple card options',
        'Reward options',
        'Online application',
      ],
      eligibility: 'Eligibility depends on the selected HDFC credit card.',
      affiliateUrl: CreditCardAffiliateConfig.hdfcUrl,
    ),

    CreditCardModel(
      id: CreditCardAffiliateConfig.axisId,
      bankName: 'Axis Bank',
      cardName: 'Axis Credit Cards',
      logoAsset: 'assets/images/cards/axis.png',
      joiningFee: 'Check offer',
      annualFee: 'Check offer',
      description:
          'Explore Axis Bank credit card options and apply through our partner.',
      benefits: [
        'Multiple card options',
        'Reward and cashback options',
        'Online application',
      ],
      eligibility: 'Eligibility depends on the selected Axis credit card.',
      affiliateUrl: CreditCardAffiliateConfig.axisUrl,
    ),

    CreditCardModel(
      id: CreditCardAffiliateConfig.iciciId,
      bankName: 'ICICI Bank',
      cardName: 'ICICI Credit Cards',
      logoAsset: 'assets/images/cards/icici.png',
      joiningFee: 'Check offer',
      annualFee: 'Check offer',
      description:
          'Explore ICICI Bank credit card options and apply through our partner.',
      benefits: [
        'Multiple card options',
        'Reward options',
        'Online application',
      ],
      eligibility: 'Eligibility depends on the selected ICICI credit card.',
      affiliateUrl: CreditCardAffiliateConfig.iciciUrl,
    ),
  ];
}
