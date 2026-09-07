import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralised location for every Pixabay API related constant.
///
/// Keeping endpoint paths, query keys and defaults in one place avoids
/// "magic strings" scattered across the data layer and makes future
/// API changes a one-file edit.
class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://pixabay.com/api/';

  /// Read lazily so `.env` is guaranteed to be loaded before first use.
  static String get apiKey => dotenv.env['PIXABAY_API_KEY'] ?? '';

  // Query parameter keys
  static const String qKey = 'key';
  static const String qQuery = 'q';
  static const String qImageType = 'image_type';
  static const String qOrientation = 'orientation';
  static const String qCategory = 'category';
  static const String qPage = 'page';
  static const String qPerPage = 'per_page';
  static const String qSafeSearch = 'safesearch';

  // Sensible defaults
  static const String defaultImageType = 'photo';
  static const int defaultPage = 1;
  static const int defaultPerPage = 20;
  static const int minPerPage = 3;
  static const int maxPerPage = 200;

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
