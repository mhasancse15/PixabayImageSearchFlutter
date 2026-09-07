import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/di/injection.dart';
import '../controllers/home_controller.dart';
import '../widgets/image_grid_item.dart';
import '../widgets/search_bar_widget.dart';

/// Root screen: search field + a paginated grid of Pixabay images.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(getIt<HomeController>());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBarWidget(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              onClear: () {
                // Additional logic if needed when cleared
              },
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingView(message: 'Fetching images...');
          }

          if (controller.errorMessage.value.isNotEmpty && controller.images.isEmpty) {
            return ErrorView(
              message: controller.errorMessage.value,
              onRetry: controller.refresh,
            );
          }

          if (controller.images.isEmpty) {
            return const EmptyView(message: AppConstants.emptySearchResultMessage);
          }

          return GridView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(AppConstants.gridSpacing),
            physics: const AlwaysScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppConstants.gridCrossAxisCount,
              mainAxisSpacing: AppConstants.gridSpacing,
              crossAxisSpacing: AppConstants.gridSpacing,
              childAspectRatio: 0.85,
            ),
            itemCount: controller.images.length + (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= controller.images.length) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LoadingView(),
                );
              }

              final image = controller.images[index];
              return ImageGridItem(
                image: image,
                onTap: () => Get.toNamed(AppRoutes.imageDetail, arguments: image),
              );
            },
          );
        }),
      ),
    );
  }
}
