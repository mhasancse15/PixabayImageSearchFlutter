import 'package:get/get.dart';

import '../../presentation/home/pages/home_page.dart';
import '../../presentation/image_detail/pages/image_detail_page.dart';
import 'app_routes.dart';

/// Central route table. Each [GetPage] pairs a screen with the
/// [Bindings] responsible for injecting its dependencies, so
/// controllers/use cases/repositories are only ever constructed when
/// their route is actually visited.
class AppPages {
  const AppPages._();

  static const String initial = AppRoutes.home;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoutes.imageDetail,
      page: () => const ImageDetailPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
