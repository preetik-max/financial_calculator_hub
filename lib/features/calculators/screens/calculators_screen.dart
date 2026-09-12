import 'package:flutter/material.dart';
import '../../calculator_modules/lumpsum/lumpsum_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../calculator_modules/cagr/cagr_screen.dart';
import '../../calculator_modules/loan_eligibility/loan_eligibility_screen.dart';
import '../../calculator_modules/salary/salary_screen.dart';
import '../../calculator_modules/sip/sip_screen.dart';
import '../../calculator_modules/emi/emi_screen.dart';
import '../data/calculator_catalog.dart';
import '../widgets/calculator_category_tabs.dart';
import '../widgets/calculator_list_item.dart';
import '../widgets/calculator_search.dart';
import '../../calculator_modules/home_loan/home_loan_screen.dart';
import '../../calculator_modules/fd/fd_screen.dart';
import '../../calculator_modules/rd/rd_screen.dart';
import '../../calculator_modules/ppf/ppf_screen.dart';

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

  // ================================================================
  // LIFECYCLE
  // ================================================================

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
  // POPULAR SECTION
  // ================================================================

  bool get _showingPopular {
    return _searchQuery.isEmpty && _selectedCategory == CalculatorCategory.all;
  }

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
                    _searchQuery = value.trim();
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: () {
          _openPopularCalculator();
        },
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Row(
            children: [
              // --------------------------------------------------------
              // ICON
              // --------------------------------------------------------
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

              // --------------------------------------------------------
              // TEXT
              // --------------------------------------------------------
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
                      'SIP, Salary, Loan Eligibility and more',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------------
              // ARROW
              // --------------------------------------------------------
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
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
    switch (calculator.id) {
      // ============================================================
      // SIP CALCULATOR
      // ============================================================

      case 'sip':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SipScreen()),
        );
        return;

      // ============================================================
      // LUMPSUM CALCULATOR
      // ============================================================

      case 'cagr':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CagrScreen()),
        );
        break;

      case 'lumpsum':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LumpsumScreen()),
        );
        return;

      // ============================================================
      // LOAN ELIGIBILITY
      // ============================================================

      case 'loan_eligibility':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoanEligibilityScreen()),
        );
        return;
      case 'fd':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FdScreen()),
        );
        break;
      case 'home_loan':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeLoanScreen()),
        );
        break;

      case 'emi':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmiScreen()),
        );
        break;
      case 'rd':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RdScreen()),
        );
        break;

      case 'ppf':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PpfScreen()),
        );
        break;

      // ============================================================
      // SALARY CALCULATOR
      // ============================================================

      case 'salary':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SalaryScreen()),
        );
        return;

      // ============================================================
      // FUTURE CALCULATORS
      // ============================================================

      default:
        _showComingSoon(context, calculator.title);
        return;
    }
  }

  // ================================================================
  // POPULAR CALCULATOR ACTION
  // ================================================================

  void _openPopularCalculator() {
    final sipCalculator = CalculatorCatalog.all
        .where((calculator) => calculator.id == 'sip')
        .firstOrNull;

    if (sipCalculator == null || !mounted) {
      return;
    }

    _openCalculator(context, sipCalculator);
  }

  // ================================================================
  // COMING SOON
  // ================================================================

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title will be available soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
