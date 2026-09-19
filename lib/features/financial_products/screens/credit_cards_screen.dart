import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../data/hdfc_cards.dart';
import '../data/sbi_cards.dart';

class CreditCardsScreen extends StatelessWidget {
  const CreditCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Credit Cards'),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: false,
            tabs: [
              Tab(text: 'AXIS'),
              Tab(text: 'SBI'),
              Tab(text: 'HDFC'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_AxisCardsTab(), _SbiCardsTab(), _HdfcCardsTab()],
        ),
      ),
    );
  }
}

// ============================================================
// AXIS BANK
// ============================================================

class _AxisCardsTab extends StatelessWidget {
  const _AxisCardsTab();

  static const List<_CreditCardItem> cards = [
    _CreditCardItem(
      name: 'Flipkart Axis Bank Credit Card',
      image: 'assets/cards/axis/flipkart_axis.png',
      applyUrl: 'https://linkzip.in/ubdp5n',
      badge: 'Shopping',
      description:
          'Shopping-focused Axis Bank credit card with benefits on eligible Flipkart and partner spends.',
    ),
    _CreditCardItem(
      name: 'IndiGo Axis Bank RuPay Credit Card',
      image: 'assets/cards/axis/indigo_axis_rupay.png',
      applyUrl: 'https://linkzip.in/xick9r',
      badge: 'Travel',
      description: 'Travel-focused co-branded Axis Bank RuPay credit card.',
    ),
    _CreditCardItem(
      name: 'IndiGo Axis Bank Premium Credit Card',
      image: 'assets/cards/axis/indigo_axis_premium.png',
      applyUrl: 'https://linkzip.in/hw2spt',
      badge: 'Premium',
      description: 'Premium travel-focused Axis Bank credit card.',
    ),
    _CreditCardItem(
      name: 'Axis Bank Privilege Credit Card',
      image: 'assets/cards/axis/axis_privilege.png',
      applyUrl: 'https://linkzip.in/j6y1vn',
      badge: 'Rewards',
      description: 'Rewards and lifestyle-focused Axis Bank credit card.',
    ),
    _CreditCardItem(
      name: 'Airtel Axis Bank Credit Card',
      image: 'assets/cards/axis/airtel_axis.png',
      applyUrl: 'https://linkzip.in/01bg6x',
      badge: 'Popular',
      description:
          'Co-branded Axis Bank credit card for eligible Airtel and everyday spends.',
    ),
    _CreditCardItem(
      name: 'Axis Bank Neo Credit Card',
      image: 'assets/cards/axis/axis_neo.png',
      applyUrl: 'https://linkzip.in/twzw32',
      badge: 'Popular',
      description:
          'Everyday lifestyle and shopping-focused Axis Bank credit card.',
    ),
    _CreditCardItem(
      name: 'Axis My Zone Credit Card',
      image: 'assets/cards/axis/axis_my_zone.png',
      applyUrl: 'https://linkzip.in/r45zuj',
      badge: 'Lifestyle',
      description:
          'Lifestyle-focused Axis Bank credit card with selected offers and benefits.',
    ),
    _CreditCardItem(
      name: 'Axis Bank Cashback Credit Card',
      image: 'assets/cards/axis/axis_cashback.png',
      applyUrl: 'https://linkzip.in/85umf3',
      badge: 'Cashback',
      description:
          'Cashback-focused Axis Bank credit card for eligible spending.',
    ),
    _CreditCardItem(
      name: 'Axis Bank Horizon Credit Card',
      image: 'assets/cards/axis/axis_horizon.png',
      applyUrl: 'https://linkzip.in/381uk6',
      badge: 'Travel',
      description:
          'Travel-focused Axis Bank credit card with travel-related benefits.',
    ),
    _CreditCardItem(
      name: 'IndianOil Axis Bank RuPay Credit Card',
      image: 'assets/cards/axis/indianoil_axis_rupay.png',
      applyUrl: 'https://linkzip.in/bwmy9z',
      badge: 'Fuel',
      description:
          'Co-branded Axis Bank RuPay credit card for eligible IndianOil spends.',
    ),
    _CreditCardItem(
      name: 'Axis Bank Rewards Credit Card',
      image: 'assets/cards/axis/axis_rewards.png',
      applyUrl: 'https://linkzip.in/36vh1q',
      badge: 'Rewards',
      description:
          'Rewards-focused Axis Bank credit card for eligible spending.',
    ),
    _CreditCardItem(
      name: 'Axis Bank SELECT Credit Card',
      image: 'assets/cards/axis/axis_select.png',
      applyUrl: 'https://linkzip.in/5sf41x',
      badge: 'Premium',
      description:
          'Premium lifestyle and rewards-focused Axis Bank credit card.',
    ),
    _CreditCardItem(
      name: 'Axis Bank ACE Credit Card',
      image: 'assets/cards/axis/axis_ace.png',
      applyUrl: 'https://linkzip.in/wzoiqh',
      badge: 'Popular',
      description:
          'Cashback and everyday-spending focused Axis Bank credit card.',
    ),
    _CreditCardItem(
      name: 'LIC Axis Bank Signature Credit Card',
      image: 'assets/cards/axis/lic_axis_signature.png',
      applyUrl: 'https://linkzip.in/qo4q8h',
      badge: 'Premium',
      description:
          'Co-branded LIC and Axis Bank credit card with rewards and lifestyle benefits.',
    ),
    _CreditCardItem(
      name: 'LIC Axis Bank Platinum Credit Card',
      image: 'assets/cards/axis/lic_axis_platinum.png',
      applyUrl: 'https://linkzip.in/4b46q0',
      badge: 'Rewards',
      description:
          'Co-branded LIC and Axis Bank credit card for eligible spending.',
    ),
    _CreditCardItem(
      name: 'Axis Bank Shoppers Stop Credit Card',
      image: 'assets/cards/axis/axis_shoppers_stop.png',
      applyUrl: 'https://linkzip.in/c0kli1',
      badge: 'Shopping',
      description: 'Shopping-focused co-branded Axis Bank credit card.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _CreditCardList(bankName: 'Axis Bank Credit Cards', cards: cards);
  }
}

// ============================================================
// SBI
// ============================================================

class _SbiCardsTab extends StatelessWidget {
  const _SbiCardsTab();

  @override
  Widget build(BuildContext context) {
    final cards = sbiCards
        .map(
          (card) => _CreditCardItem(
            name: card.name,
            image: card.image,
            applyUrl: card.applyUrl,
            badge: card.badge,
            description: card.description,
          ),
        )
        .toList(growable: false);

    return _CreditCardList(bankName: 'SBI Credit Cards', cards: cards);
  }
}

// ============================================================
// HDFC
// ============================================================

class _HdfcCardsTab extends StatelessWidget {
  const _HdfcCardsTab();

  @override
  Widget build(BuildContext context) {
    final cards = hdfcCards
        .map(
          (card) => _CreditCardItem(
            name: card.name,
            image: card.image,
            applyUrl: card.applyUrl,
            badge: card.badge,
            description: card.description,
          ),
        )
        .toList(growable: false);

    return _CreditCardList(bankName: 'HDFC Bank Credit Cards', cards: cards);
  }
}

// ============================================================
// CREDIT CARD LIST
// ============================================================

class _CreditCardList extends StatelessWidget {
  final String bankName;
  final List<_CreditCardItem> cards;

  const _CreditCardList({required this.bankName, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _InfoHeader(
            title: bankName,
            subtitle: 'Compare available cards and open the application page.',
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              itemCount: cards.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                return _CreditCardTile(card: cards[index]);
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}

// ============================================================
// CREDIT CARD TILE
// ============================================================

class _CreditCardTile extends StatelessWidget {
  final _CreditCardItem card;

  const _CreditCardTile({required this.card});

  Future<void> _openApplyUrl(BuildContext context) async {
    final uri = Uri.parse(card.applyUrl);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open application link.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to open application link.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(card.name, style: textTheme.titleMedium)),
                if (card.badge != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      card.badge!,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(card.description, style: textTheme.bodySmall),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              height: 175,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                card.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.credit_card, size: 56));
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openApplyUrl(context),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Apply Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INFO HEADER
// ============================================================

class _InfoHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(subtitle, style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

// ============================================================
// MODEL
// ============================================================

class _CreditCardItem {
  final String name;
  final String image;
  final String applyUrl;
  final String? badge;
  final String description;

  const _CreditCardItem({
    required this.name,
    required this.image,
    required this.applyUrl,
    this.badge,
    required this.description,
  });
}
