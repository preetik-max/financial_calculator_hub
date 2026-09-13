import 'package:flutter/material.dart';

enum CalculatorCategory { all, investment, loans, savings, tax, tools }

class CalculatorItem {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final CalculatorCategory categoryType;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final bool isAvailable;

  const CalculatorItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.categoryType,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.isAvailable = true,
  });
}

class CalculatorCatalog {
  CalculatorCatalog._();

  static const List<CalculatorItem> all = [
    // ============================================================
    // INVESTMENT
    // ============================================================
    CalculatorItem(
      id: 'sip',
      title: 'SIP Calculator',
      subtitle: 'Calculate returns on monthly investments',
      category: 'Investment',
      categoryType: CalculatorCategory.investment,
      icon: Icons.savings_outlined,
      iconColor: Color(0xFF2563EB),
      backgroundColor: Color(0xFFE8F0FF),
    ),

    CalculatorItem(
      id: 'lumpsum',
      title: 'Lumpsum Calculator',
      subtitle: 'Calculate returns on one-time investments',
      category: 'Investment',
      categoryType: CalculatorCategory.investment,
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFF16A34A),
      backgroundColor: Color(0xFFE8F8EF),
    ),

    CalculatorItem(
      id: 'cagr',
      title: 'CAGR Calculator',
      subtitle: 'Calculate annualized investment growth',
      category: 'Investment',
      categoryType: CalculatorCategory.investment,
      icon: Icons.show_chart_rounded,
      iconColor: Color(0xFF7C3AED),
      backgroundColor: Color(0xFFF3E8FF),
    ),

    // ============================================================
    // LOANS
    // ============================================================
    CalculatorItem(
      id: 'loan_eligibility',
      title: 'Loan Eligibility',
      subtitle: 'Estimate how much loan you may qualify for',
      category: 'Loans',
      categoryType: CalculatorCategory.loans,
      icon: Icons.account_balance_rounded,
      iconColor: Color(0xFF2563EB),
      backgroundColor: Color(0xFFE8F0FF),
      isAvailable: true,
    ),

    CalculatorItem(
      id: 'emi',
      title: 'EMI Calculator',
      subtitle: 'Calculate monthly loan payments',
      category: 'Loans',
      categoryType: CalculatorCategory.loans,
      icon: Icons.payments_outlined,
      iconColor: Color(0xFF2563EB),
      backgroundColor: Color(0xFFE8F0FF),
    ),

    CalculatorItem(
      id: 'home_loan',
      title: 'Home Loan Calculator',
      subtitle: 'Calculate home loan EMI and interest',
      category: 'Loans',
      categoryType: CalculatorCategory.loans,
      icon: Icons.home_outlined,
      iconColor: Color(0xFFEA580C),
      backgroundColor: Color(0xFFFFEDE5),
    ),

    CalculatorItem(
      id: 'personal_loan',
      title: 'Personal Loan Calculator',
      subtitle: 'Calculate personal loan repayment',
      category: 'Loans',
      categoryType: CalculatorCategory.loans,
      icon: Icons.account_balance_wallet_outlined,
      iconColor: Color(0xFF0891B2),
      backgroundColor: Color(0xFFE6F7FA),
    ),

    // ============================================================
    // SAVINGS
    // ============================================================
    CalculatorItem(
      id: 'fd',
      title: 'FD Calculator',
      subtitle: 'Calculate fixed deposit maturity',
      category: 'Savings',
      categoryType: CalculatorCategory.savings,
      icon: Icons.lock_clock_outlined,
      iconColor: Color(0xFFD97706),
      backgroundColor: Color(0xFFFFF7E6),
    ),

    CalculatorItem(
      id: 'rd',
      title: 'RD Calculator',
      subtitle: 'Calculate recurring deposit maturity',
      category: 'Savings',
      categoryType: CalculatorCategory.savings,
      icon: Icons.repeat_rounded,
      iconColor: Color(0xFF16A34A),
      backgroundColor: Color(0xFFE8F8EF),
    ),

    CalculatorItem(
      id: 'ppf',
      title: 'PPF Calculator',
      subtitle: 'Calculate PPF maturity and returns',
      category: 'Savings',
      categoryType: CalculatorCategory.savings,
      icon: Icons.account_balance_outlined,
      iconColor: Color(0xFF7C3AED),
      backgroundColor: Color(0xFFF3E8FF),
    ),

    // ============================================================
    // TAX
    // ============================================================
    CalculatorItem(
      id: 'gst',
      title: 'GST Calculator',
      subtitle: 'Calculate GST amount and final price',
      category: 'Tax',
      categoryType: CalculatorCategory.tax,
      icon: Icons.receipt_long_outlined,
      iconColor: Color(0xFF0891B2),
      backgroundColor: Color(0xFFE6F7FA),
    ),
    CalculatorItem(
      id: 'salary',
      title: 'Salary Calculator',
      subtitle: 'Calculate monthly in-hand salary',
      category: 'Tools',
      categoryType: CalculatorCategory.tools,
      icon: Icons.payments_rounded,
      iconColor: Color(0xFF0891B2),
      backgroundColor: Color(0xFFE6F7FA),
    ),

    // ============================================================
    // TOOLS
    // ============================================================
    CalculatorItem(
      id: 'simple_interest',
      title: 'Simple Interest',
      subtitle: 'Calculate simple interest quickly',
      category: 'Tools',
      categoryType: CalculatorCategory.tools,
      icon: Icons.calculate_outlined,
      iconColor: Color(0xFF2563EB),
      backgroundColor: Color(0xFFE8F0FF),
    ),

    CalculatorItem(
      id: 'compound_interest',
      title: 'Compound Interest',
      subtitle: 'Calculate compound interest and maturity',
      category: 'Tools',
      categoryType: CalculatorCategory.tools,
      icon: Icons.auto_graph_rounded,
      iconColor: Color(0xFF16A34A),
      backgroundColor: Color(0xFFE8F8EF),
    ),

    CalculatorItem(
      id: 'inflation',
      title: 'Inflation Calculator',
      subtitle: 'Understand the future value of money',
      category: 'Tools',
      categoryType: CalculatorCategory.tools,
      icon: Icons.currency_rupee_rounded,
      iconColor: Color(0xFFEA580C),
      backgroundColor: Color(0xFFFFEDE5),
    ),

    CalculatorItem(
      id: 'percentage',
      title: 'Percentage Calculator',
      subtitle: 'Calculate percentages instantly',
      category: 'Tools',
      categoryType: CalculatorCategory.tools,
      icon: Icons.percent_rounded,
      iconColor: Color(0xFF7C3AED),
      backgroundColor: Color(0xFFF3E8FF),
    ),
    CalculatorItem(
      id: 'age',
      title: 'Age Calculator',
      subtitle: 'Calculate your exact age',
      category: 'Tools',
      categoryType: CalculatorCategory.tools,
      icon: Icons.cake_outlined,
      iconColor: Color(0xFFDB2777),
      backgroundColor: Color(0xFFFCE7F3),
    ),

    CalculatorItem(
      id: 'discount',
      title: 'Discount Calculator',
      subtitle: 'Calculate discounts and final prices',
      category: 'Tools',
      categoryType: CalculatorCategory.tools,
      icon: Icons.local_offer_outlined,
      iconColor: Color(0xFFD97706),
      backgroundColor: Color(0xFFFFF7E6),
    ),
  ];

  static List<CalculatorItem> byCategory(CalculatorCategory category) {
    if (category == CalculatorCategory.all) {
      return all;
    }

    return all.where((item) => item.categoryType == category).toList();
  }

  static List<CalculatorItem> search(
    String query,
    CalculatorCategory category,
  ) {
    final normalized = query.trim().toLowerCase();

    return byCategory(category).where((item) {
      if (normalized.isEmpty) {
        return true;
      }

      return item.title.toLowerCase().contains(normalized) ||
          item.subtitle.toLowerCase().contains(normalized) ||
          item.category.toLowerCase().contains(normalized);
    }).toList();
  }
}
