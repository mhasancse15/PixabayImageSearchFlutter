/// String route names, kept separate from [AppPages] so widgets can
/// reference `AppRoutes.imageDetail` without importing the page/binding
/// wiring.
class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String imageDetail = '/image-detail';
}
