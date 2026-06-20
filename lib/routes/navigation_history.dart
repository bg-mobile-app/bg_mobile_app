class AppNavigationHistory {
  static final List<String> _history = [];
  static bool _isGoingBack = false;

  static void recordVisit(String path) {
    if (_isGoingBack) {
      _isGoingBack = false;
      return;
    }

    if (_history.isEmpty || _history.last != path) {
      if (_history.contains(path)) {
        final index = _history.lastIndexOf(path);
        _history.removeRange(index + 1, _history.length);
      } else {
        _history.add(path);
      }
    }
  }

  static bool get canPop => _history.length > 1;

  static String? pop() {
    if (_history.length <= 1) return null;
    _history.removeLast(); // remove current
    final previous = _history.last;
    _isGoingBack = true;
    return previous;
  }
}
