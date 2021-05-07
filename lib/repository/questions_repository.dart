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
import 'package:flutter/cupertino.dart';

class QuestionsRepository implements Repository {
  final ApiServices _apiServices;

  QuestionsRepository(this._apiServices);

  final Cache<String, QuestionList> _cache = MapCache();

  final RateLimiter _rateLimiter = RateLimiter();

  Future<RepositoryResult<QuestionList>> fetchQuestions({
    String subjectId,
    String videoId,
    bool forceApiRequest = false,
  }) async {
    final key = "$subjectId$videoId";

    var _result = await _cache.get(key);

    if (forceApiRequest || _result == null) {
      final response = await _apiServices.getQuestions(
        subjectId: subjectId,
        videoId: videoId,
      );
      if (response is SuccessResponse<QuestionList>) {
        _cache.set(key, response.body);
        return RepositorySuccessResult(response.body);
      } else if (response is ErrorResponse<QuestionList>) {
        _rateLimiter.reset(key);
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(_result);
    }

    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<void>> sendQuestionAnswer({
    @required String questionId,
    @required String answer,
  }) async {
    final response = await _apiServices.sendQuestionAnswer(
      questionId: questionId,
      answer: answer,
    );

    if (response is SuccessResponse) {
      return RepositorySuccessResult(response.body);
    } else {
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    }
  }

  Future<RepositoryResult<QuestionList>> fetchFavouriteQuestions() async {
    final response = await _apiServices.getFavouriteQuestions();
    if (response is SuccessResponse<QuestionList>) {
      return RepositorySuccessResult(
        response.body,
      );
    } else if (response is ErrorResponse<QuestionList>) {
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    } else {
      return RepositoryErrorResult(
        ApiError.unknown,
      );
    }
  }

  Future<RepositoryResult<void>> addFavouriteQuestion({
    @required String questionId,
  }) async {
    final response = await _apiServices.addFavouriteQuestion(
      questionId: questionId,
    );

    if (response is SuccessResponse<void>) {
      return RepositorySuccessResult(
        response.body,
      );
    } else {
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    }
  }

  Future<RepositoryResult<void>> deleteFavouriteQuestion({
    @required String questionId,
  }) async {
    final response = await _apiServices.deleteFavouriteQuestion(
      questionId: questionId,
    );

    if (response is SuccessResponse<void>) {
      return RepositorySuccessResult(
        response.body,
      );
    } else {
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    }
  }

  @override
  void clearCache() {
    _cache.invalidateAll();
    _rateLimiter.resetAll();
  }

  void updateQuestions(
      {String subjectId, String videoId, QuestionList questionList}) {
    _cache.set("$subjectId$videoId", questionList);
  }

  void clearCacheKey({String subjectId, String videoId}) {
    _cache.invalidate("$subjectId$videoId");
  }

  void updateAnswer({String subjectId, String videoId, int index}) {}
}
