import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_stack_model.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:flutter/material.dart';

class FlashcardsStackArguments {
  final String videoId;
  final String topicId;
  final String subjectId;
  final String subjectName;
  final FlashcardStatus status;
  final String source;

  FlashcardsStackArguments({
    this.videoId,
    this.topicId,
    this.subjectId,
    this.subjectName,
    this.status,
    this.source
  });
}

class FlashcardRepository implements Repository {
  final ApiServices _apiServices;

  FlashcardRepository(this._apiServices);

  final Cache<String, FlashcardsStackModel> _cache = MapCache();

  final RateLimiter _rateLimiter = RateLimiter();

  Future<RepositoryResult<FlashcardsStackModel>> getFlashcardsStack({
    @required FlashcardsStackArguments arguments,
    bool forceApiRequest = false,
  }) async {
    final key = _getStackKey(arguments);

    final shouldFetch = _rateLimiter.shouldFetch(key);

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getFlashcardsStack(arguments);
      if (response is SuccessResponse<FlashcardsStackModel>) {
        _cache.set(key, response.body);
        return RepositorySuccessResult(response.body);
      } else if (response is ErrorResponse<FlashcardsStackModel>) {
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

  String _getStackKey(FlashcardsStackArguments arguments) {
    return arguments.videoId ??
        arguments.topicId ??
        arguments.subjectId ??
        flashcardStatusToString(arguments.status) ??
        "all";
  }

  @override
  void clearCache() {
    _rateLimiter.resetAll();
    _cache.invalidateAll();
  }
}
