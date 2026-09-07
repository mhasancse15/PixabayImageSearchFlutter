/// Non-network, app-wide constants: UI text, spacing and timing values.
///
/// Pulling these out of widgets keeps the presentation layer free of
/// hard-coded literals and makes localisation/theming changes trivial.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Pixabay Explorer';

  // Search behaviour
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const int gridCrossAxisCount = 2;
  static const double gridSpacing = 8.0;

  // Storage keys
  static const String storageRecentSearches = 'recent_searches';
  static const int maxRecentSearches = 10;

  // Messages
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String noInternetMessage = 'No internet connection. Please check your network.';
  static const String emptySearchResultMessage = 'No images found. Try a different keyword.';
  static const String initialPromptMessage = 'Search Pixabay for free images, or browse what\'s trending.';
}
