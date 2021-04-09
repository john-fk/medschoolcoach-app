import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';

class QuestionsDayRepository implements Repository {
  final ApiServices _apiServices;

  QuestionsDayRepository(this._apiServices);

  final Cache<String, List<Question>> _cache = MapCache();

  final RateLimiter _rateLimiter = RateLimiter();

  Future<RepositoryResult<List<Question>>> fetchQuestionOfTheDay({
    bool forceApiRequest = false,
  }) async {
    final key = "question_day";

    final shouldFetch = _rateLimiter.shouldFetch(key);

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getQuestionOfTheDayQuestions();
      if (response is SuccessResponse<List<Question>>) {
        _cache.set(key, response.body);
        return RepositorySuccessResult(response.body);
      } else if (response is ErrorResponse<List<Question>>) {
        _rateLimiter.reset(key);
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _cache.get(key),
      );
    }

    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  @override
  void clearCache() {
    _cache.invalidateAll();
    _rateLimiter.resetAll();
  }
}
