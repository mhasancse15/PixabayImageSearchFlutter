import 'dart:async';

/// Delays invoking [action] until no new call has been made for
/// [delay], cancelling any pending call in between.
///
/// Used by [HomeController] to avoid firing an API request on every
/// keystroke while the user is typing a search query.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
