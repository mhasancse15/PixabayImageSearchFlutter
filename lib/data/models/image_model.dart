import '../../core/error/exceptions.dart';
import '../../domain/entities/image_entity.dart';

/// Data-layer representation of a single Pixabay image hit.
///
/// Owns all knowledge of Pixabay's raw JSON field names. Extends
/// [ImageEntity] rather than wrapping it so it can be passed anywhere
/// an [ImageEntity] is expected while still exposing [fromJson].
class ImageModel extends ImageEntity {
  const ImageModel({
    required super.id,
    required super.tags,
    required super.previewUrl,
    required super.webformatUrl,
    required super.largeImageUrl,
    required super.imageWidth,
    required super.imageHeight,
    required super.views,
    required super.downloads,
    required super.likes,
    required super.comments,
    required super.user,
    required super.userImageUrl,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    try {
      return ImageModel(
        id: json['id'] as int,
        tags: json['tags'] as String? ?? '',
        previewUrl: json['previewURL'] as String? ?? '',
        webformatUrl: json['webformatURL'] as String? ?? '',
        // Pixabay only returns `largeImageURL` for some plans/endpoints;
        // fall back to the webformat image so the UI never breaks.
        largeImageUrl: json['largeImageURL'] as String? ?? json['webformatURL'] as String? ?? '',
        imageWidth: json['imageWidth'] as int? ?? 0,
        imageHeight: json['imageHeight'] as int? ?? 0,
        views: json['views'] as int? ?? 0,
        downloads: json['downloads'] as int? ?? 0,
        likes: json['likes'] as int? ?? 0,
        comments: json['comments'] as int? ?? 0,
        user: json['user'] as String? ?? 'Unknown',
        userImageUrl: json['userImageURL'] as String? ?? '',
      );
    } catch (e) {
      throw ParsingException('Failed to parse image: $e');
    }
  }
}
