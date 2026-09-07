import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/image_page_entity.dart';
import '../entities/image_search_params.dart';

/// Contract the data layer must fulfil.
///
/// The domain layer (use cases) only ever talks to this abstraction,
/// never to `ImageRepositoryImpl` directly — that's what makes the
/// use cases trivially testable with a mock repository.
abstract class ImageRepository {
  Future<Either<Failure, ImagePageEntity>> searchImages(
    ImageSearchParams params,
  );
}
