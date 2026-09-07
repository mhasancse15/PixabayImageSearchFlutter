import 'package:injectable/injectable.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/image_search_params.dart';
import '../models/pixabay_response_model.dart';

/// Talks directly to the Pixabay `/api/` endpoint.
///
/// Knows nothing about [Failure]s or [Either] — it either returns a
/// parsed [PixabayResponseModel] or lets an exception from [ApiClient]
/// bubble up. Translating those exceptions into [Failure]s is the
/// repository's job.
abstract class ImageRemoteDataSource {
  Future<PixabayResponseModel> searchImages(ImageSearchParams params);
}

@LazySingleton(as: ImageRemoteDataSource)
class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final ApiClient apiClient;

  const ImageRemoteDataSourceImpl(this.apiClient);

  @override
  Future<PixabayResponseModel> searchImages(ImageSearchParams params) async {
    final response = await apiClient.get(
      '', // Pixabay's base URL *is* the search endpoint.
      queryParameters: {
        ApiConstants.qKey: ApiConstants.apiKey,
        if (params.query.trim().isNotEmpty) ApiConstants.qQuery: params.query.trim(),
        ApiConstants.qImageType: params.imageType,
        ApiConstants.qPage: params.page,
        ApiConstants.qPerPage: params.perPage,
        ApiConstants.qSafeSearch: true,
      },
    );

    return PixabayResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
