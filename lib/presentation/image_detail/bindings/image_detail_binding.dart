import 'package:get/get.dart';

import '../../../domain/entities/image_entity.dart';
import '../controllers/image_detail_controller.dart';

/// Reads the [ImageEntity] passed via `Get.toNamed(..., arguments:)`
/// and injects it into a fresh [ImageDetailController].
class ImageDetailBinding extends Bindings {
  @override
  void dependencies() {
    final image = Get.arguments as ImageEntity;
    Get.lazyPut<ImageDetailController>(() => ImageDetailController(image: image));
  }
}
