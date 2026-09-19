import '../../../core/affiliate/personal_loan_affiliate_config.dart';
import '../models/personal_loan_model.dart';

class PersonalLoanData {
  PersonalLoanData._();

  static const List<PersonalLoanModel> loans = [
    PersonalLoanModel(
      id: PersonalLoanAffiliateConfig.sbiId,
      bankName: 'SBI',
      productName: 'SBI Personal Loan',
      logoAsset: 'assets/images/loans/sbi.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore personal loan options from SBI and apply through our partner.',
      benefits: [
        'Personal loan options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: PersonalLoanAffiliateConfig.sbiUrl,
    ),

    PersonalLoanModel(
      id: PersonalLoanAffiliateConfig.hdfcId,
      bankName: 'HDFC Bank',
      productName: 'HDFC Personal Loan',
      logoAsset: 'assets/images/loans/hdfc.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore personal loan options from HDFC Bank and apply through our partner.',
      benefits: [
        'Personal loan options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: PersonalLoanAffiliateConfig.hdfcUrl,
    ),

    PersonalLoanModel(
      id: PersonalLoanAffiliateConfig.axisId,
      bankName: 'Axis Bank',
      productName: 'Axis Personal Loan',
      logoAsset: 'assets/images/loans/axis.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore personal loan options from Axis Bank and apply through our partner.',
      benefits: [
        'Personal loan options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: PersonalLoanAffiliateConfig.axisUrl,
    ),

    PersonalLoanModel(
      id: PersonalLoanAffiliateConfig.iciciId,
      bankName: 'ICICI Bank',
      productName: 'ICICI Personal Loan',
      logoAsset: 'assets/images/loans/icici.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore personal loan options from ICICI Bank and apply through our partner.',
      benefits: [
        'Personal loan options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: PersonalLoanAffiliateConfig.iciciUrl,
    ),
  ];
}
