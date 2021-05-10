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
import 'package:Medschoolcoach/ui/flash_card/card/flash.dart';

class FlashcardsStackArguments {
  final String videoId;
  final String topicId;
  final String subjectId;
  final String subjectName;
  final FlashcardStatus status;
  final String source;
  final int position;

  FlashcardsStackArguments(
      {this.videoId,
      this.topicId,
      this.subjectId,
      this.subjectName,
      this.status,
      this.source,
      this.position = 0});
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

    //get result if exists so we can continue instead of refetching
    var _result = await _cache.get(key);

    if (forceApiRequest || _result == null) {
      final response = await _apiServices.getFlashcardsStack(arguments);
      if (response is SuccessResponse<FlashcardsStackModel>) {
        _cache.set(key, response.body);
        return RepositorySuccessResult(response.body);
      } else if (response is ErrorResponse<FlashcardsStackModel>) {
        _rateLimiter.reset(key);
        return RepositoryUtils.handleRepositoryError(response);
      }
    } else {
      return RepositorySuccessResult(_result);
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
    _cache.invalidateAll();
  }

  void updateCard(
      FlashcardsStackArguments arguments, FlashcardsStackModel stacks) {
    _cache.set(_getStackKey(arguments), stacks);
  }

  void clearCacheKey(FlashcardsStackArguments arguments) {
    _cache.invalidate(_getStackKey(arguments));
  }
}
