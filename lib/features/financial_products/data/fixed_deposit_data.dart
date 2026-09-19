import '../../../core/affiliate/fixed_deposit_affiliate_config.dart';
import '../models/fixed_deposit_model.dart';

class FixedDepositData {
  FixedDepositData._();

  static const List<FixedDepositModel> deposits = [
    FixedDepositModel(
      id: FixedDepositAffiliateConfig.sbiId,
      bankName: 'SBI',
      productName: 'SBI Fixed Deposit',
      logoAsset: 'assets/images/fixed_deposits/sbi.png',
      minimumDeposit: 'Check current offer',
      tenure: 'As per offer',
      interestRate: 'Check current rate',
      description:
          'Explore fixed deposit options from SBI and connect through our partner.',
      benefits: [
        'Fixed deposit options',
        'Different tenure choices',
        'Online application',
      ],
      eligibility:
          'Interest rate, tenure and other terms are subject to the selected deposit product.',
      affiliateUrl: FixedDepositAffiliateConfig.sbiUrl,
    ),
    FixedDepositModel(
      id: FixedDepositAffiliateConfig.hdfcId,
      bankName: 'HDFC Bank',
      productName: 'HDFC Fixed Deposit',
      logoAsset: 'assets/images/fixed_deposits/hdfc.png',
      minimumDeposit: 'Check current offer',
      tenure: 'As per offer',
      interestRate: 'Check current rate',
      description:
          'Explore fixed deposit options from HDFC Bank and connect through our partner.',
      benefits: [
        'Fixed deposit options',
        'Different tenure choices',
        'Online application',
      ],
      eligibility:
          'Interest rate, tenure and other terms are subject to the selected deposit product.',
      affiliateUrl: FixedDepositAffiliateConfig.hdfcUrl,
    ),
    FixedDepositModel(
      id: FixedDepositAffiliateConfig.axisId,
      bankName: 'Axis Bank',
      productName: 'Axis Fixed Deposit',
      logoAsset: 'assets/images/fixed_deposits/axis.png',
      minimumDeposit: 'Check current offer',
      tenure: 'As per offer',
      interestRate: 'Check current rate',
      description:
          'Explore fixed deposit options from Axis Bank and connect through our partner.',
      benefits: [
        'Fixed deposit options',
        'Different tenure choices',
        'Online application',
      ],
      eligibility:
          'Interest rate, tenure and other terms are subject to the selected deposit product.',
      affiliateUrl: FixedDepositAffiliateConfig.axisUrl,
    ),
    FixedDepositModel(
      id: FixedDepositAffiliateConfig.iciciId,
      bankName: 'ICICI Bank',
      productName: 'ICICI Fixed Deposit',
      logoAsset: 'assets/images/fixed_deposits/icici.png',
      minimumDeposit: 'Check current offer',
      tenure: 'As per offer',
      interestRate: 'Check current rate',
      description:
          'Explore fixed deposit options from ICICI Bank and connect through our partner.',
      benefits: [
        'Fixed deposit options',
        'Different tenure choices',
        'Online application',
      ],
      eligibility:
          'Interest rate, tenure and other terms are subject to the selected deposit product.',
      affiliateUrl: FixedDepositAffiliateConfig.iciciUrl,
    ),
  ];
}
