import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/metal_price.dart';

class MetalPriceService {
  MetalPriceService._();

  static String get _baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }

    // iOS Simulator / macOS
    return 'http://127.0.0.1:8000';
  }

  static String get _metalsEndpoint =>
      '$_baseUrl/api/metals';

  static Future<MetalPrice> fetchMetalPrices() async {
    final response = await http
        .get(
      Uri.parse(_metalsEndpoint),
      headers: const {
        'Accept': 'application/json',
      },
    )
        .timeout(
      const Duration(seconds: 15),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch metal prices. '
            'HTTP ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        'Invalid metal price response.',
      );
    }

    return MetalPrice.fromJson(decoded);
  }
}