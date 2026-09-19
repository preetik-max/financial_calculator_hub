import '../../../core/affiliate/car_loan_affiliate_config.dart';
import '../models/car_loan_model.dart';

class CarLoanData {
  CarLoanData._();

  static const List<CarLoanModel> loans = [
    CarLoanModel(
      id: CarLoanAffiliateConfig.sbiId,
      bankName: 'SBI',
      productName: 'SBI Car Loan',
      logoAsset: 'assets/images/car_loans/sbi.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore car loan options from SBI and apply through our partner.',
      benefits: [
        'New and eligible vehicle finance options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: CarLoanAffiliateConfig.sbiUrl,
    ),
    CarLoanModel(
      id: CarLoanAffiliateConfig.hdfcId,
      bankName: 'HDFC Bank',
      productName: 'HDFC Car Loan',
      logoAsset: 'assets/images/car_loans/hdfc.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore car loan options from HDFC Bank and apply through our partner.',
      benefits: [
        'Vehicle finance options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: CarLoanAffiliateConfig.hdfcUrl,
    ),
    CarLoanModel(
      id: CarLoanAffiliateConfig.axisId,
      bankName: 'Axis Bank',
      productName: 'Axis Car Loan',
      logoAsset: 'assets/images/car_loans/axis.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore car loan options from Axis Bank and apply through our partner.',
      benefits: [
        'Vehicle finance options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: CarLoanAffiliateConfig.axisUrl,
    ),
    CarLoanModel(
      id: CarLoanAffiliateConfig.iciciId,
      bankName: 'ICICI Bank',
      productName: 'ICICI Car Loan',
      logoAsset: 'assets/images/car_loans/icici.png',
      loanAmount: 'As per eligibility',
      tenure: 'As per offer',
      interestRate: 'Check current offer',
      processingFee: 'Check current offer',
      description:
          'Explore car loan options from ICICI Bank and apply through our partner.',
      benefits: [
        'Vehicle finance options',
        'Flexible repayment options',
        'Online application',
      ],
      eligibility:
          'Eligibility, loan amount, interest rate and tenure are subject to lender criteria.',
      affiliateUrl: CarLoanAffiliateConfig.iciciUrl,
    ),
  ];
}
