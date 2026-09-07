import 'package:flutter/material.dart';

/// Single source of truth for the app's visual theme.
///
/// Keeping `ThemeData` construction out of `main.dart`/widgets means
/// design tweaks (colors, typography) never require touching business
/// logic files.
class AppTheme {
  const AppTheme._();

  static const Color _seedColor = Color(0xFF20AC5C); // Pixabay-esque green

  static ThemeData get light => _base(Brightness.light);
  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
