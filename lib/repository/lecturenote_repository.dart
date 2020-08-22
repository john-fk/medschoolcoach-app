import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/lecturenote.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';

class LectureNoteRepository implements Repository {
  final ApiServices _apiServices;

  LectureNoteRepository(this._apiServices);

  final Cache<String, LectureNote> _lectureNoteCache = MapCache();

  final RateLimiter _rateLimiter = RateLimiter();

  Future<RepositoryResult<LectureNote>> fetchLectureNote(
      String videoId, {
        bool forceApiRequest = false,
      }) async {
    final shouldFetch = _rateLimiter.shouldFetch(
      videoId,
    );

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getLectureNote(
        videoId: videoId,
      );
      if (response is SuccessResponse<LectureNote>) {
        _lectureNoteCache.set(
          response.body.id,
          response.body,
        );
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<LectureNote>) {
        _rateLimiter.reset(
          videoId,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _lectureNoteCache.get(videoId),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  @override
  void clearCache() {
    _rateLimiter.resetAll();
    _lectureNoteCache.invalidateAll();
  }
}
