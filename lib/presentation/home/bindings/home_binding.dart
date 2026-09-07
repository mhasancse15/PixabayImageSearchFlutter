import 'package:get/get.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/network_info.dart';
import '../../../data/datasources/image_remote_data_source.dart';
import '../../../data/repositories/image_repository_impl.dart';
import '../../../domain/repositories/image_repository.dart';
import '../../../domain/usecases/search_images_usecase.dart';
import '../controllers/home_controller.dart';

/// Wires up every layer (data source -> repository -> use case ->
/// controller) needed by the Home screen.
///
/// Declaring the full dependency graph here — rather than in `main.dart`
/// — keeps each feature self-contained and lazily instantiated only
/// when its route is visited.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Core / data layer
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);
    Get.lazyPut<ImageRemoteDataSource>(
      () => ImageRemoteDataSourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ImageRepository>(
      () => ImageRepositoryImpl(
        remoteDataSource: Get.find<ImageRemoteDataSource>(),
        networkInfo: Get.find<NetworkInfo>(),
      ),
      fenix: true,
    );

    // Domain layer
    Get.lazyPut<SearchImagesUseCase>(
      () => SearchImagesUseCase(Get.find<ImageRepository>()),
      fenix: true,
    );

    // Presentation layer
    Get.lazyPut<HomeController>(
      () => HomeController(searchImagesUseCase: Get.find<SearchImagesUseCase>()),
    );
  }
}
