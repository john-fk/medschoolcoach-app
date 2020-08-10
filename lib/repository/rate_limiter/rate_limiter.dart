class RateLimiter {
  final Duration timeout;
  final Map<String, DateTime> _timestamps = {};

  RateLimiter({
    this.timeout = const Duration(
      minutes: 1,
    ),
  });

  bool shouldFetchWithVariableLimit(String key, Duration aDuration) {
    var lastFetched = _timestamps[key];
    var now = DateTime.now();

    if (lastFetched == null) {
      _timestamps[key] = now;
      return true;
    }

    var x = now.difference(lastFetched).inMilliseconds;
    var i2 = aDuration.inMilliseconds;
    if (x > i2) {
      _timestamps[key] = now;
      return true;
    }

    return false;
  }

  bool shouldFetch(String key) {
   return shouldFetchWithVariableLimit(key, timeout);
  }

  void reset(String key) {
    _timestamps.remove(key);
  }

  void resetAll() {
    _timestamps.clear();
  }
}
