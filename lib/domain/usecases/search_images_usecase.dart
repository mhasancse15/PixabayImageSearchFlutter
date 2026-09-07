import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/image_page_entity.dart';
import '../entities/image_search_params.dart';
import '../repositories/image_repository.dart';
import 'usecase.dart';

/// Fetches a page of images matching [ImageSearchParams.query].
///
/// An empty query is valid and simply returns Pixabay's default
/// "trending" style feed, so this single use case powers both the
/// initial home feed and user-driven search.
class SearchImagesUseCase implements UseCase<ImagePageEntity, ImageSearchParams> {
  final ImageRepository repository;

  const SearchImagesUseCase(this.repository);

  @override
  Future<Either<Failure, ImagePageEntity>> call(ImageSearchParams params) {
    return repository.searchImages(params);
  }
}
