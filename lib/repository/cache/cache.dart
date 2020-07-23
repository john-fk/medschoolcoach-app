import 'dart:async';

/// A function that produces a value for [key], for when a [Cache] needs to
/// populate an entry.
///
/// The loader function should either return a value synchronously or a
/// [Future] which completes with the value asynchronously.
typedef FutureOr<V> Loader<K, V>(K key);

/// A semi-persistent mapping of keys to values.
///
/// All access to a Cache is asynchronous because many implementations will
/// store their entries in remote systems, isolates, or otherwise have to do
/// async IO to read and write.
abstract class Cache<K, V> {
  /// Returns the value associated with [key].
  Future<V> get(K key, {Loader<K, V> ifAbsent});

  /// Returns all cached values
  Future<List<V>> getAll();

  /// Sets the value associated with [key]. The Future completes with null when
  /// the operation is complete.
  Future<Null> set(K key, V value);

  /// Removes the value associated with [key]. The Future completes with null
  /// when the operation is complete.
  Future<Null> invalidate(K key);

  Future<Null> invalidateAll();
}
