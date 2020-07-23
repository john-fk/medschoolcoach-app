import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/last_watched_response.dart';
import 'package:Medschoolcoach/utils/api/models/search_result.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:flutter/material.dart';

class VideoRepository implements Repository {
  final ApiServices _apiServices;

  VideoRepository(this._apiServices);

  Future<RepositoryResult<SearchResult>> search(
      SearchArguments arguments) async {
    final response = await _apiServices.search(arguments);

    if (response is SuccessResponse<SearchResult>) {
      return RepositorySuccessResult(
        response.body,
      );
    } else if (response is ErrorResponse<SearchResult>) {
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    } else {
      return RepositoryErrorResult(
        ApiError.unknown,
      );
    }
  }

  Future<RepositoryResult<void>> setVideoProgress({
    @required String videoId,
    @required String seconds,
  }) async {
    final response = await _apiServices.setVideoProgress(
      seconds: seconds,
      videoId: videoId,
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

  Future<RepositoryResult<LastWatchedResponse>> lastWatched() async {
    final response = await _apiServices.lastWatched();

    if (response is SuccessResponse<LastWatchedResponse>) {
      return RepositorySuccessResult(
        response.body,
      );
    } else if (response is ErrorResponse<LastWatchedResponse>) {
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    } else {
      return RepositoryErrorResult(
        ApiError.unknown,
      );
    }
  }

  @override
  void clearCache() {}
}
