import 'package:equatable/equatable.dart';

import 'image_entity.dart';

/// A single "page" of results returned by the Pixabay API, plus the
/// metadata needed to know whether more pages can be fetched.
class ImagePageEntity extends Equatable {
  final List<ImageEntity> images;
  final int totalHits;
  final int currentPage;
  final int perPage;

  const ImagePageEntity({
    required this.images,
    required this.totalHits,
    required this.currentPage,
    required this.perPage,
  });

  /// Whether another page can still be requested.
  ///
  /// `totalHits` is capped by Pixabay at 500 regardless of the real
  /// number of matches, so this is only ever used as an upper bound.
  bool get hasMore =>
      images.isNotEmpty && (currentPage * perPage) < totalHits;

  @override
  List<Object?> get props => [images, totalHits, currentPage, perPage];
}
