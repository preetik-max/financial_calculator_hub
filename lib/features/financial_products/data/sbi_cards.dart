import 'package:flutter/foundation.dart';

class SbiCardOffer {
  final String name;
  final String image;
  final String applyUrl;
  final String? badge;
  final String description;

  const SbiCardOffer({
    required this.name,
    required this.image,
    required this.applyUrl,
    this.badge,
    required this.description,
  });
}

const List<SbiCardOffer> sbiCards = [
  SbiCardOffer(
    name: 'SBI Cashback Credit Card',
    image: 'assets/cards/sbi/sbi_cashback.png',
    applyUrl: 'https://linkzip.in/bf3aln',
    badge: 'Cashback',
    description:
        'Cashback-focused SBI credit card for eligible online and offline spending.',
  ),

  SbiCardOffer(
    name: 'Flipkart SBI Credit Card',
    image: 'assets/cards/sbi/flipkart_sbi.png',
    applyUrl: 'https://linkzip.in/t2rrmt',
    badge: 'Popular',
    description:
        'Shopping-focused SBI credit card with benefits on eligible Flipkart and partner spends.',
  ),

  SbiCardOffer(
    name: 'BPCL SBI Octane Credit Card',
    image: 'assets/cards/sbi/bpcl_sbi_octane.png',
    applyUrl: 'https://linkzip.in/2ct4en',
    badge: 'Fuel',
    description:
        'Premium fuel-focused SBI credit card designed for eligible BPCL transactions.',
  ),

  SbiCardOffer(
    name: 'BPCL SBI Credit Card',
    image: 'assets/cards/sbi/bpcl_sbi.png',
    applyUrl: 'https://linkzip.in/xr55c5',
    badge: 'Fuel',
    description:
        'Fuel and rewards-focused SBI credit card with benefits on eligible BPCL spends.',
  ),

  SbiCardOffer(
    name: 'SBI SimplyCLICK Credit Card',
    image: 'assets/cards/sbi/sbi_simplyclick.png',
    applyUrl: 'https://linkzip.in/b2g2wh',
    badge: 'Shopping',
    description:
        'Online-shopping focused SBI credit card with reward benefits on eligible spends.',
  ),

  SbiCardOffer(
    name: 'SBI SimplySAVE Credit Card',
    image: 'assets/cards/sbi/sbi_simplysave.png',
    applyUrl: 'https://linkzip.in/fpl5or',
    description:
        'Everyday-spending SBI credit card with rewards on selected categories.',
  ),

  SbiCardOffer(
    name: 'IRCTC SBI RuPay Credit Card',
    image: 'assets/cards/sbi/irctc_sbi_rupay.png',
    applyUrl: 'https://linkzip.in/nitrcr',
    badge: 'Travel',
    description:
        'Railway and travel-focused SBI RuPay credit card for eligible IRCTC transactions.',
  ),

  SbiCardOffer(
    name: 'SBI MILES Credit Card',
    image: 'assets/cards/sbi/sbi_miles.png',
    applyUrl: 'https://linkzip.in/67gtb9',
    badge: 'Travel',
    description:
        'Travel-focused SBI credit card offering travel-related rewards on eligible spends.',
  ),

  SbiCardOffer(
    name: 'SBI ELITE Credit Card',
    image: 'assets/cards/sbi/sbi_elite.png',
    applyUrl: 'https://linkzip.in/scsscf',
    badge: 'Premium',
    description:
        'Premium SBI credit card with lifestyle, reward and travel-related benefits.',
  ),

  SbiCardOffer(
    name: 'SBI Prime Credit Card',
    image: 'assets/cards/sbi/sbi_prime.png',
    applyUrl: 'https://linkzip.in/hpqvhe',
    badge: 'Premium',
    description: 'Premium rewards and lifestyle-focused SBI credit card.',
  ),

  SbiCardOffer(
    name: 'Tata Neu Plus SBI Credit Card',
    image: 'assets/cards/sbi/tata_neu_plus_sbi.png',
    applyUrl: 'https://linkzip.in/94o6pf',
    badge: 'Tata Neu',
    description:
        'Tata Neu co-branded SBI credit card with NeuCoins on eligible spending.',
  ),

  SbiCardOffer(
    name: 'Tata Neu Infinity SBI Credit Card',
    image: 'assets/cards/sbi/tata_neu_infinity_sbi.png',
    applyUrl: 'https://linkzip.in/n11sj4',
    badge: 'Premium',
    description:
        'Premium Tata Neu co-branded SBI credit card with enhanced NeuCoins benefits.',
  ),

  SbiCardOffer(
    name: 'SBI MILES PRIME Credit Card',
    image: 'assets/cards/sbi/sbi_miles_prime.png',
    applyUrl: 'https://linkzip.in/6ked4g',
    badge: 'Travel',
    description:
        'Travel-focused premium SBI credit card with travel rewards on eligible spends.',
  ),

  SbiCardOffer(
    name: 'SBI MILES ELITE Credit Card',
    image: 'assets/cards/sbi/sbi_miles_elite.png',
    applyUrl: 'https://linkzip.in/611nbp',
    badge: 'Premium',
    description:
        'Premium travel-focused SBI credit card with travel rewards and benefits.',
  ),
];
