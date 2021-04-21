import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_progress.dart';
import 'package:Medschoolcoach/utils/api/models/question_bank_progress.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_stats.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';

const _courseRateLimiterKey = "courseProgress";
const _flashcardRateLimiterKey = "flashcardProgress";
const _questionBankRateLimiterKey = "questionBankProgress";

class ProgressRepository implements Repository {
  final ApiServices _apiServices;

  ProgressRepository(this._apiServices);

  final Cache<String, ScheduleStats> _courseProgressCache = MapCache();
  final Cache<String, FlashcardsProgress> _flashcardProgress = MapCache();
  final Cache<String, QuestionBankProgress> _questionBankProgress = MapCache();
  final RateLimiter _rateLimiter = RateLimiter();

  Future<RepositoryResult<QuestionBankProgress>> fetchQuestionBankProgress({
    bool forceApiRequest = false,
  }) async {
    final key = 'questionBank';
    final shouldFetch = _rateLimiter.shouldFetch(_questionBankRateLimiterKey);
    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getQuestionBankProgress();
      if (response is SuccessResponse<QuestionBankProgress>) {
        _questionBankProgress.set(key, response.body);
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<QuestionBankProgress>) {
        _rateLimiter.reset(
          _flashcardRateLimiterKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(await _questionBankProgress.get(key));
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<FlashcardsProgress>> fetchFlashcardProgress({
    bool forceApiRequest = false,
  }) async {
    final key = 'flashcard';
    final shouldFetch = _rateLimiter.shouldFetch(_flashcardRateLimiterKey);
    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getFlashcardsProgress();
      if (response is SuccessResponse<FlashcardsProgress>) {
        _flashcardProgress.set(key, response.body);
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<FlashcardsProgress>) {
        _rateLimiter.reset(
          _flashcardRateLimiterKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(await _flashcardProgress.get(key));
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<ScheduleStats>> fetchCourseProgress({
    bool forceApiRequest = false,
  }) async {
    final key = 'course';
    final shouldFetch = _rateLimiter.shouldFetch(_courseRateLimiterKey);
    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getCourseProgress();
      if (response is SuccessResponse<ScheduleStats>) {
        _courseProgressCache.set(key, response.body);
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<ScheduleStats>) {
        _rateLimiter.reset(
          _courseRateLimiterKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(await _courseProgressCache.get(key));
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  @override
  void clearCache() {
    _courseProgressCache.invalidateAll();
    _flashcardProgress.invalidateAll();
    _rateLimiter.resetAll();
  }
}
