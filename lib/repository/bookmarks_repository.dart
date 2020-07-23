import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/bookmark.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:flutter/cupertino.dart';

import 'cache/cache.dart';
import 'cache/map_chache.dart';

const _rateLimiterKey = "bookmarksKey";

class BookmarksRepository implements Repository {
  final ApiServices _apiServices;

  final Cache<String, Bookmark> _bookmarksCache = MapCache();

  final RateLimiter _rateLimiter = RateLimiter();

  BookmarksRepository(
    this._apiServices,
  );

  Future<RepositoryResult<List<Bookmark>>> fetchBookmarks({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _rateLimiter.shouldFetch(_rateLimiterKey);

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getBookmarks();
      if (response is SuccessResponse<List<Bookmark>>) {
        response.body.forEach(
          (element) => _bookmarksCache.set(
            element.id,
            element,
          ),
        );
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<List<Bookmark>>) {
        _rateLimiter.reset(
          _rateLimiterKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _bookmarksCache.getAll(),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<void>> addBookmark({
    @required String videoId,
  }) async {
    final response = await _apiServices.addBookmark(videoId: videoId);

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

  Future<RepositoryResult<void>> deleteBookmark({
    @required String videoId,
  }) async {
    final response = await _apiServices.deleteBookmark(videoId: videoId);

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
    _rateLimiter.resetAll();
    _bookmarksCache.invalidateAll();
  }
}
