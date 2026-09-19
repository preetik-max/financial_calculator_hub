import '../../../core/affiliate/home_loan_affiliate_config.dart';
import '../models/home_loan_model.dart';

class HomeLoanData {
  HomeLoanData._();

  static const List<HomeLoanModel> loans = [
    HomeLoanModel(
      id: HomeLoanAffiliateConfig.sbiId,
      bankName: 'SBI',
      productName: 'SBI Home Loan',
      logoAsset: 'assets/images/home_loans/sbi.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore home loan options from SBI and apply through our partner.',
      benefits: [
        'Housing finance options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: HomeLoanAffiliateConfig.sbiUrl,
    ),
    HomeLoanModel(
      id: HomeLoanAffiliateConfig.hdfcId,
      bankName: 'HDFC Bank',
      productName: 'HDFC Home Loan',
      logoAsset: 'assets/images/home_loans/hdfc.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore home loan options from HDFC Bank and apply through our partner.',
      benefits: [
        'Housing finance options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: HomeLoanAffiliateConfig.hdfcUrl,
    ),
    HomeLoanModel(
      id: HomeLoanAffiliateConfig.axisId,
      bankName: 'Axis Bank',
      productName: 'Axis Home Loan',
      logoAsset: 'assets/images/home_loans/axis.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore home loan options from Axis Bank and apply through our partner.',
      benefits: [
        'Housing finance options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: HomeLoanAffiliateConfig.axisUrl,
    ),
    HomeLoanModel(
      id: HomeLoanAffiliateConfig.iciciId,
      bankName: 'ICICI Bank',
      productName: 'ICICI Home Loan',
      logoAsset: 'assets/images/home_loans/icici.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore home loan options from ICICI Bank and apply through our partner.',
      benefits: [
        'Housing finance options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: HomeLoanAffiliateConfig.iciciUrl,
    ),
  ];
}
