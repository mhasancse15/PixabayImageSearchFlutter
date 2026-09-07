import 'package:get/get.dart';

import '../../../domain/entities/image_entity.dart';

/// Holds the [ImageEntity] passed as a route argument from the grid.
///
/// No additional network call is needed here since Pixabay's search
/// response already contains everything the detail screen displays —
/// keeping this controller intentionally thin.
class ImageDetailController extends GetxController {
  late final ImageEntity image;

  ImageDetailController({required this.image});
}
