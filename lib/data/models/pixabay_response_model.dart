import '../../core/error/exceptions.dart';
import 'image_model.dart';

/// Maps the top-level Pixabay API response:
/// ```json
/// { "total": 4692, "totalHits": 500, "hits": [ {...}, {...} ] }
/// ```
class PixabayResponseModel {
  final int total;
  final int totalHits;
  final List<ImageModel> hits;

  const PixabayResponseModel({
    required this.total,
    required this.totalHits,
    required this.hits,
  });

  factory PixabayResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      final hitsJson = json['hits'] as List<dynamic>? ?? [];
      return PixabayResponseModel(
        total: json['total'] as int? ?? 0,
        totalHits: json['totalHits'] as int? ?? 0,
        hits: hitsJson
            .map((hit) => ImageModel.fromJson(hit as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      throw ParsingException('Failed to parse Pixabay response: $e');
    }
  }
}
