import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/image_page_entity.dart';
import '../../domain/entities/image_search_params.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/image_remote_data_source.dart';

/// Concrete implementation of [ImageRepository].
///
/// Responsibilities:
/// 1. Verify connectivity before hitting the network.
/// 2. Delegate the actual HTTP call to [ImageRemoteDataSource].
/// 3. Catch data-layer exceptions and translate them into typed
///    [Failure]s so the domain/presentation layers stay decoupled
///    from networking/parsing internals.
@LazySingleton(as: ImageRepository)
class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const ImageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ImagePageEntity>> searchImages(
    ImageSearchParams params,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.searchImages(params);
      return Right(
        ImagePageEntity(
          images: response.hits,
          totalHits: response.totalHits,
          currentPage: params.page,
          perPage: params.perPage,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
