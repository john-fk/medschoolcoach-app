import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Cache<String, Section> _sectionsListCache = MapCache();
  final String _testKey = "testCacheTest";
  final String _testKey2 = "testCacheTest2";

  group(
    'Cache tests',
    () {
      test(
        'Cache getAll test',
        () async {
          _addExampleSections(
            _sectionsListCache,
            _testKey,
            _testKey2,
          );
          var resultList = await _sectionsListCache.getAll();

          expect(resultList.isNotEmpty, true);
          expect(resultList.length == 2, true);
        },
      );

      test(
        'Cache getbyKey test',
        () async {
          _addExampleSections(
            _sectionsListCache,
            _testKey,
            _testKey2,
          );
          var result = await _sectionsListCache.get(_testKey);

          expect(result != null, true);
          expect(result.name == "Section1", true);
        },
      );

      test(
        'Cache invalidateAll test',
        () async {
          _addExampleSections(
            _sectionsListCache,
            _testKey,
            _testKey2,
          );
          await _sectionsListCache.invalidateAll();
          var resultList = await _sectionsListCache.getAll();

          expect(resultList.isEmpty, true);
        },
      );

      test(
        'Cache invalidateByKey test',
        () async {
          _addExampleSections(
            _sectionsListCache,
            _testKey,
            _testKey2,
          );
          await _sectionsListCache.invalidate(_testKey2);

          var resultList = await _sectionsListCache.getAll();

          expect(resultList.length == 1, true);
          expect(resultList[0].name == "Section1", true);
        },
      );
    },
  );
}

void _addExampleSections(Cache<String, Section> _sectionsListCache,
    String _testKey, String _testKey2) {
  _sectionsListCache.set(
    _testKey,
    Section(
      name: "Section1",
    ),
  );
  _sectionsListCache.set(
    _testKey2,
    Section(
      name: "Section2",
    ),
  );
}
