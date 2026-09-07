import 'package:equatable/equatable.dart';

import '../../core/constants/api_constants.dart';

/// Encapsulates every filter Pixabay's `/api/` endpoint accepts that
/// this app exposes to the user.
///
/// Passing a single value object through the repository/usecase/data
/// source chain (instead of a long parameter list) keeps signatures
/// stable as new filters are added.
class ImageSearchParams extends Equatable {
  final String query;
  final int page;
  final int perPage;
  final String imageType;

  const ImageSearchParams({
    this.query = '',
    this.page = ApiConstants.defaultPage,
    this.perPage = ApiConstants.defaultPerPage,
    this.imageType = ApiConstants.defaultImageType,
  });

  ImageSearchParams copyWith({
    String? query,
    int? page,
    int? perPage,
    String? imageType,
  }) {
    return ImageSearchParams(
      query: query ?? this.query,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      imageType: imageType ?? this.imageType,
    );
  }

  @override
  List<Object?> get props => [query, page, perPage, imageType];
}
