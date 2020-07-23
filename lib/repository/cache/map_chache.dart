import 'dart:async';
import 'dart:collection';

import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:quiver/collection.dart';

/// A [Cache] that's backed by a [Map].
class MapCache<K, V> implements Cache<K, V> {
  final Map<K, V> _map;

  final _outstanding = <K, FutureOr<V>>{};

  /// Creates a new [MapCache], optionally using [map] as the backing [Map].
  MapCache({Map<K, V> map}) : _map = map != null ? map : HashMap<K, V>();

  /// Creates a new [MapCache], using [LruMap] as the backing [Map].
  /// Optionally specify [maximumSize].
  factory MapCache.lru({int maximumSize}) {
    return MapCache<K, V>(map: LruMap(maximumSize: maximumSize));
  }

  @override
  Future<V> get(K key, {Loader<K, V> ifAbsent}) async {
    if (_map.containsKey(key)) {
      return _map[key];
    }
    // If this key is already loading then return the existing future.
    if (_outstanding.containsKey(key)) {
      return _outstanding[key];
    }
    if (ifAbsent != null) {
      dynamic futureOr = ifAbsent(key);
      _outstanding[key] = futureOr;
      dynamic v = await futureOr;
      _map[key] = v;
      _outstanding.remove(key);
      return v;
    }
    return null;
  }

  @override
  Future<List<V>> getAll() async {
    return _map.entries.map((entry) => entry.value).toList();
  }

  @override
  Future<Null> set(K key, V value) async {
    _map[key] = value;
  }

  @override
  Future<Null> invalidate(K key) async {
    _map.remove(key);
  }

  @override
  Future<Null> invalidateAll() {
    _map.removeWhere((_, __) => true);
    return null;
  }
}
