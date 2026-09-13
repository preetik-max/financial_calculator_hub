import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/metal_price.dart';
import '../services/metal_price_service.dart';

class GoldPriceScreen extends StatefulWidget {
  const GoldPriceScreen({super.key});

  @override
  State<GoldPriceScreen> createState() => _GoldPriceScreenState();
}

class _GoldPriceScreenState extends State<GoldPriceScreen> {
  late Future<MetalPrice> _metalPriceFuture;

  @override
  void initState() {
    super.initState();
    _metalPriceFuture = MetalPriceService.fetchMetalPrices();
  }

  Future<void> _refresh() async {
    setState(() {
      _metalPriceFuture = MetalPriceService.fetchMetalPrices();
    });

    await _metalPriceFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gold Price')),
      body: FutureBuilder<MetalPrice>(
        future: _metalPriceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErrorView(
              message: snapshot.error.toString(),
              onRetry: _refresh,
            );
          }

          final data = snapshot.data;

          if (data == null) {
            return _ErrorView(
              message: 'No gold price data available.',
              onRetry: _refresh,
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _GoldPriceCard(rate: data.gold, updatedAt: data.updatedAt),
                const SizedBox(height: AppSpacing.xxl),
                const Text('Quantity', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _quantity('1 g'),
                    _quantity('10 g'),
                    _quantity('100 g'),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                const Text('Price Trend', style: AppTextStyles.sectionTitle),
                const SizedBox(height: AppSpacing.md),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Text(
                      'Live price chart',
                      style: AppTextStyles.body.copyWith(color: AppColors.gold),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'Indicative/reference spot price only. '
                  'Jewellery prices may include purity differences, '
                  'making charges, wastage, GST, retailer margins '
                  'and local market differences.',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _quantity(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.sm),
        child: OutlinedButton(onPressed: () {}, child: Text(text)),
      ),
    );
  }
}

class _GoldPriceCard extends StatelessWidget {
  final MetalRate rate;
  final String? updatedAt;

  const _GoldPriceCard({required this.rate, required this.updatedAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.goldLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.gold,
            size: 34,
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Gold', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppSpacing.sm),
          Text(_formatCurrency(rate.spotPer10g), style: AppTextStyles.price),
          const SizedBox(height: 4),
          const Text('per 10 grams', style: AppTextStyles.body),
          const SizedBox(height: AppSpacing.md),
          Text('Indicative spot price', style: AppTextStyles.positive),
          if (updatedAt != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Updated: ${_formatDateTime(updatedAt!)}',
              style: AppTextStyles.body.copyWith(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    final rounded = value.round().toString();
    final chars = rounded.split('').reversed.toList();

    final groups = <String>[];
    for (var i = 0; i < chars.length; i += 2) {
      final end = (i + 2 < chars.length) ? i + 2 : chars.length;
      groups.add(chars.sublist(i, end).reversed.join());
    }

    return '₹${groups.reversed.join(',')}';
  }

  String _formatDateTime(String value) {
    final dateTime = DateTime.tryParse(value);

    if (dateTime == null) {
      return value;
    }

    final local = dateTime.toLocal();

    String twoDigits(int number) {
      return number.toString().padLeft(2, '0');
    }

    return '${local.day}/${local.month}/${local.year} '
        '${twoDigits(local.hour)}:${twoDigits(local.minute)}';
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 48),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Unable to load gold price',
              style: AppTextStyles.sectionTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
