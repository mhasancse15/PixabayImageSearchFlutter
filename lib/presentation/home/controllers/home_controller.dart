import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/failures.dart';
import '../../../core/utils/debouncer.dart';
import '../../../domain/entities/image_entity.dart';
import '../../../domain/entities/image_search_params.dart';
import '../../../domain/usecases/search_images_usecase.dart';

/// Drives the Home screen: search input, the resulting image grid,
/// and infinite-scroll pagination.
///
/// All mutable UI state lives in `.obs` fields so [HomePage] can stay
/// a stateless, purely reactive widget with `Obx`/`GetX` builders.
@injectable
class HomeController extends GetxController {
  final SearchImagesUseCase searchImagesUseCase;

  HomeController({required this.searchImagesUseCase});

  final Debouncer _debouncer = Debouncer(delay: AppConstants.searchDebounce);

  // --- Controllers ----------------------------------------------------
  late final TextEditingController searchController;
  late final ScrollController scrollController;

  // --- Reactive state -------------------------------------------------
  final RxString query = ''.obs;
  final RxList<ImageEntity> images = <ImageEntity>[].obs;
  final RxBool isLoading = false.obs; // first page / full-screen loading
  final RxBool isLoadingMore = false.obs; // subsequent pages
  final RxString errorMessage = ''.obs;
  final RxBool hasMore = true.obs;

  int _currentPage = ApiConstants.defaultPage;
  static const int _perPage = ApiConstants.defaultPerPage;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    scrollController = ScrollController();

    scrollController.addListener(() {
      final nearBottom = scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 300;
      if (nearBottom) loadMore();
    });

    // Show a default/trending feed as soon as the screen opens.
    fetchImages(reset: true);
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    _debouncer.dispose();
    super.onClose();
  }

  /// Called from the search field's `onChanged`. Debounced so we don't
  /// spam the API on every keystroke.
  void onSearchChanged(String value) {
    query.value = value;
    _debouncer.call(() => fetchImages(reset: true));
  }

  /// Fetches images for the current [query].
  ///
  /// [reset] is true for a brand-new search (clears the list and goes
  /// back to page 1); false when loading the next page for infinite
  /// scroll.
  Future<void> fetchImages({required bool reset}) async {
    if (reset) {
      _currentPage = 1;
      hasMore.value = true;
      errorMessage.value = '';
      isLoading.value = true;
    } else {
      if (!hasMore.value || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    final params = ImageSearchParams(
      query: query.value,
      page: _currentPage,
      perPage: _perPage,
    );

    final result = await searchImagesUseCase(params);

    result.fold(
      (failure) {
        errorMessage.value = _mapFailureToMessage(failure);
      },
      (page) {
        if (reset) {
          images.assignAll(page.images);
        } else {
          images.addAll(page.images);
        }
        hasMore.value = page.hasMore;
        _currentPage++;
      },
    );

    isLoading.value = false;
    isLoadingMore.value = false;
  }

  /// Triggered by the grid's scroll controller when the user nears
  /// the bottom of the list.
  void loadMore() => fetchImages(reset: false);

  /// Pull-to-refresh handler.
  Future<void> refresh() => fetchImages(reset: true);

  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) return AppConstants.noInternetMessage;
    return failure.message.isNotEmpty
        ? failure.message
        : AppConstants.genericErrorMessage;
  }
}
