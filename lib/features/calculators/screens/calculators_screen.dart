import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

import '../../calculator_modules/loan_eligibility/loan_eligibility_screen.dart';
import '../../calculator_modules/salary/salary_screen.dart';

import '../data/calculator_catalog.dart';
import '../widgets/calculator_category_tabs.dart';
import '../widgets/calculator_list_item.dart';
import '../widgets/calculator_search.dart';

class CalculatorsScreen extends StatefulWidget {
  const CalculatorsScreen({super.key});

  @override
  State<CalculatorsScreen> createState() => _CalculatorsScreenState();
}

class _CalculatorsScreenState extends State<CalculatorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  CalculatorCategory _selectedCategory = CalculatorCategory.all;

  String _searchQuery = '';

  final Set<String> _favorites = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ================================================================
  // FILTERED CALCULATORS
  // ================================================================

  List<CalculatorItem> get _calculators {
    return CalculatorCatalog.search(_searchQuery, _selectedCategory);
  }

  // ================================================================
  // POPULAR SECTION VISIBILITY
  // ================================================================

  bool get _showingPopular =>
      _searchQuery.isEmpty && _selectedCategory == CalculatorCategory.all;

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final calculators = _calculators;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // ============================================================
          // HEADER
          // ============================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.lg,
              AppSpacing.lg,
              0,
            ),
            sliver: SliverToBoxAdapter(child: _header()),
          ),

          // ============================================================
          // SEARCH
          // ============================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: CalculatorSearch(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),

          // ============================================================
          // CATEGORY TABS
          // ============================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: CalculatorCategoryTabs(
                selectedCategory: _selectedCategory,
                onChanged: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
            ),
          ),

          // ============================================================
          // POPULAR CALCULATORS
          // ============================================================
          if (_showingPopular)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              sliver: SliverToBoxAdapter(child: _popularSection()),
            ),

          // ============================================================
          // CALCULATOR LIST
          // ============================================================
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              _showingPopular ? 0 : AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xxl,
            ),
            sliver: calculators.isEmpty
                ? SliverToBoxAdapter(child: _emptyState())
                : SliverList.builder(
                    itemCount: calculators.length,
                    itemBuilder: (context, index) {
                      final calculator = calculators[index];

                      return CalculatorListItem(
                        calculator: calculator,
                        isFavorite: _favorites.contains(calculator.id),
                        onFavoriteTap: () {
                          _toggleFavorite(calculator.id);
                        },
                        onTap: () {
                          _openCalculator(context, calculator);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _header() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calculators', style: AppTextStyles.headline),
        SizedBox(height: 5),
        Text(
          'Plan, calculate and make better financial decisions.',
          style: AppTextStyles.body,
        ),
      ],
    );
  }

  // ================================================================
  // POPULAR SECTION
  // ================================================================

  Widget _popularSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.calculate_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Popular Calculators',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'SIP, EMI, Loan Eligibility and more',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const Icon(Icons.arrow_forward_rounded, color: Colors.white),
        ],
      ),
    );
  }

  // ================================================================
  // EMPTY STATE
  // ================================================================

  Widget _emptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: AppColors.textMuted),
          SizedBox(height: AppSpacing.md),
          Text('No calculators found', style: AppTextStyles.sectionTitle),
          SizedBox(height: 5),
          Text(
            'Try a different search or category.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  // ================================================================
  // FAVORITES
  // ================================================================

  void _toggleFavorite(String id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  // ================================================================
  // OPEN CALCULATOR
  // ================================================================

  void _openCalculator(BuildContext context, CalculatorItem calculator) {
    // ==============================================================
    // LOAN ELIGIBILITY
    // ==============================================================

    if (calculator.id == 'loan_eligibility') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoanEligibilityScreen()),
      );

      return;
    }

    // ==============================================================
    // SALARY CALCULATOR
    // ==============================================================

    if (calculator.id == 'salary') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SalaryScreen()),
      );

      return;
    }

    // ==============================================================
    // OTHER CALCULATORS
    // ==============================================================

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${calculator.title} will be available soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
