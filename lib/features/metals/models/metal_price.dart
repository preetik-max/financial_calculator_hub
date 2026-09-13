class MetalPrice {
  final String source;
  final String priceSource;
  final String currency;
  final String? updatedAt;
  final String? priceAsOf;
  final bool indicative;
  final String note;

  final MetalRate gold;
  final MetalRate silver;

  const MetalPrice({
    required this.source,
    required this.priceSource,
    required this.currency,
    required this.updatedAt,
    required this.priceAsOf,
    required this.indicative,
    required this.note,
    required this.gold,
    required this.silver,
  });

  factory MetalPrice.fromJson(Map<String, dynamic> json) {
    return MetalPrice(
      source: json['source']?.toString() ?? '',
      priceSource: json['price_source']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'INR',
      updatedAt: json['updated_at']?.toString(),
      priceAsOf: json['price_as_of']?.toString(),
      indicative: json['indicative'] == true,
      note: json['note']?.toString() ?? '',

      gold: MetalRate.fromJson(
        Map<String, dynamic>.from(
          json['gold'] ?? {},
        ),
      ),

      silver: MetalRate.fromJson(
        Map<String, dynamic>.from(
          json['silver'] ?? {},
        ),
      ),
    );
  }
}


// ============================================================
// METAL RATE
// ============================================================

class MetalRate {
  final double spotPerGram;
  final double spotPer10g;
  final double? spotPerKg;
  final double spotPerTroyOz;

  final GoldPurityRates? goldPurity;
  final SilverPurityRate? silverPurity;

  const MetalRate({
    required this.spotPerGram,
    required this.spotPer10g,
    required this.spotPerKg,
    required this.spotPerTroyOz,
    this.goldPurity,
    this.silverPurity,
  });

  factory MetalRate.fromJson(
      Map<String, dynamic> json,
      ) {
    final purity = json['purity'];

    GoldPurityRates? goldPurity;
    SilverPurityRate? silverPurity;

    if (purity is Map) {
      final purityMap =
      Map<String, dynamic>.from(purity);

      // Gold
      if (purityMap.containsKey('24k') ||
          purityMap.containsKey('22k') ||
          purityMap.containsKey('18k')) {
        goldPurity = GoldPurityRates.fromJson(
          purityMap,
        );
      }

      // Silver
      if (purityMap.containsKey('999')) {
        silverPurity = SilverPurityRate.fromJson(
          Map<String, dynamic>.from(
            purityMap['999'] ?? {},
          ),
        );
      }
    }

    return MetalRate(
      spotPerGram: _toDouble(
        json['spot_per_gram'],
      ),

      spotPer10g: _toDouble(
        json['spot_per_10g'],
      ),

      spotPerKg: json['spot_per_kg'] == null
          ? null
          : _toDouble(
        json['spot_per_kg'],
      ),

      spotPerTroyOz: _toDouble(
        json['spot_per_troy_oz'],
      ),

      goldPurity: goldPurity,
      silverPurity: silverPurity,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }
}


// ============================================================
// GOLD PURITY RATES
// ============================================================

class GoldPurityRates {
  final GoldPurityRate? k24;
  final GoldPurityRate? k22;
  final GoldPurityRate? k18;

  const GoldPurityRates({
    this.k24,
    this.k22,
    this.k18,
  });

  factory GoldPurityRates.fromJson(
      Map<String, dynamic> json,
      ) {
    return GoldPurityRates(
      k24: _parseGoldRate(
        json['24k'],
      ),

      k22: _parseGoldRate(
        json['22k'],
      ),

      k18: _parseGoldRate(
        json['18k'],
      ),
    );
  }

  static GoldPurityRate? _parseGoldRate(
      dynamic value,
      ) {
    if (value is! Map) {
      return null;
    }

    return GoldPurityRate.fromJson(
      Map<String, dynamic>.from(value),
    );
  }
}


// ============================================================
// GOLD PURITY RATE
// ============================================================

class GoldPurityRate {
  final int karat;
  final int fineness;

  final double perGram;
  final double per10g;

  const GoldPurityRate({
    required this.karat,
    required this.fineness,
    required this.perGram,
    required this.per10g,
  });

  factory GoldPurityRate.fromJson(
      Map<String, dynamic> json,
      ) {
    return GoldPurityRate(
      karat: _toInt(
        json['karat'],
      ),

      fineness: _toInt(
        json['fineness'],
      ),

      perGram: _toDouble(
        json['per_gram'],
      ),

      per10g: _toDouble(
        json['per_10g'],
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }
}


// ============================================================
// SILVER 999
// ============================================================

class SilverPurityRate {
  final int fineness;

  final double perGram;
  final double per10g;
  final double perKg;

  const SilverPurityRate({
    required this.fineness,
    required this.perGram,
    required this.per10g,
    required this.perKg,
  });

  factory SilverPurityRate.fromJson(
      Map<String, dynamic> json,
      ) {
    return SilverPurityRate(
      fineness: _toInt(
        json['fineness'],
      ),

      perGram: _toDouble(
        json['per_gram'],
      ),

      per10g: _toDouble(
        json['per_10g'],
      ),

      perKg: _toDouble(
        json['per_kg'],
      ),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? '',
    ) ??
        0.0;
  }
}