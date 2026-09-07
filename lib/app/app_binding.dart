import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../core/network/network_info.dart';

/// Dependencies shared by more than one feature (currently just
/// connectivity checking) are registered once here, eagerly, before
/// [GetMaterialApp] builds its first route.
///
/// Feature-local dependencies (use cases, repositories, controllers)
/// stay in their own `*_binding.dart` files under `presentation/`.
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<Connectivity>(Connectivity(), permanent: true);
    Get.put<NetworkInfo>(NetworkInfoImpl(Get.find<Connectivity>()), permanent: true);
  }
}
