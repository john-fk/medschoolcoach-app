import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/statistics.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';

class StatisticsRepository implements Repository {
  final ApiServices _apiServices;

  StatisticsRepository(this._apiServices);

  static const _globalStatsKey = "globalStatsKey";
  final Cache<String, Statistics> _cache = MapCache();
  final RateLimiter _rateLimiter = RateLimiter();

  Future<RepositoryResult<Statistics>> fetchGlobalStatistics({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _rateLimiter.shouldFetch(_globalStatsKey);

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getGlobalStatistics();

      if (response is SuccessResponse<Statistics>) {
        _cache.set(
          _globalStatsKey,
          response.body,
        );
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<Statistics>) {
        _rateLimiter.reset(_globalStatsKey);
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _cache.get(_globalStatsKey),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  @override
  void clearCache() {
    _rateLimiter.resetAll();
    _cache.invalidateAll();
  }
}
