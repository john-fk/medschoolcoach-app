import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';

class TopicRepository implements Repository {
  final ApiServices _apiServices;

  TopicRepository(this._apiServices);

  final Cache<String, Topic> _topicCache = MapCache();

  final RateLimiter _rateLimiter = RateLimiter();

  Future<RepositoryResult<Topic>> fetchTopic(
    String topicId, {
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _rateLimiter.shouldFetch(
      topicId,
    );

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getTopic(
        topicId: topicId,
      );
      if (response is SuccessResponse<Topic>) {
        _topicCache.set(
          response.body.id,
          response.body,
        );
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<Topic>) {
        _rateLimiter.reset(
          topicId,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _topicCache.get(topicId),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  void saveProgressToCache(String topicId, int index, int seconds) async {
    final topic = await _topicCache.get(topicId);
    if (topic != null) {
      topic.videos[index].progress.seconds = seconds;
      _topicCache.set(
        topicId,
        topic,
      );
    }
  }

  @override
  void clearCache() {
    _rateLimiter.resetAll();
    _topicCache.invalidateAll();
  }
}
