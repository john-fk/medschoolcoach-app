import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';

import 'cache/cache.dart';
import 'cache/map_chache.dart';

class SubjectRepository implements Repository {
  final ApiServices _apiServices;

  SubjectRepository(this._apiServices);

  final Cache<String, Subject> _subjectsListCache = MapCache();

  final RateLimiter _rateLimiter = RateLimiter();

  Future<RepositoryResult<Subject>> fetchSubject(
    String subjectId, {
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _rateLimiter.shouldFetch(
      subjectId,
    );

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getSubject(
        subjectId: subjectId,
      );
      if (response is SuccessResponse<Subject>) {
        _subjectsListCache.set(
          response.body.id,
          response.body,
        );
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<Subject>) {
        _rateLimiter.reset(
          subjectId,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _subjectsListCache.get(subjectId),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  @override
  void clearCache() {
    _rateLimiter.resetAll();
    _subjectsListCache.invalidateAll();
  }
}
