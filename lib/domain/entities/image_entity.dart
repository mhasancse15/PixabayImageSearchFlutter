import 'package:equatable/equatable.dart';

/// Pure business object describing a single image.
///
/// This is what the UI and use cases work with. It has zero knowledge
/// of JSON, Pixabay's field names, or networking — that mapping lives
/// entirely in [ImageModel] inside the data layer.
class ImageEntity extends Equatable {
  final int id;
  final String tags;
  final String previewUrl;
  final String webformatUrl;
  final String largeImageUrl;
  final int imageWidth;
  final int imageHeight;
  final int views;
  final int downloads;
  final int likes;
  final int comments;
  final String user;
  final String userImageUrl;

  const ImageEntity({
    required this.id,
    required this.tags,
    required this.previewUrl,
    required this.webformatUrl,
    required this.largeImageUrl,
    required this.imageWidth,
    required this.imageHeight,
    required this.views,
    required this.downloads,
    required this.likes,
    required this.comments,
    required this.user,
    required this.userImageUrl,
  });

  /// Comma separated `tags` split into a clean, display-ready list.
  List<String> get tagList => tags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();

  @override
  List<Object?> get props => [id, tags, previewUrl, webformatUrl, largeImageUrl];
}
