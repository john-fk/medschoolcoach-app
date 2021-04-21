import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/dashboard_schedule.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_date_response.dart';
import 'package:Medschoolcoach/utils/api/models/start_schedule_error_response.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:flutter/cupertino.dart';

const String _scheduleDataKey = "dateKey";
const String _todayScheduleKey = "todaySchedule";

class ScheduleRepository implements Repository {
  final ApiServices _apiServices;
  final UserManager userManager;

  ScheduleRepository(
    this._apiServices,
    this.userManager,
  );

  final Cache<int, List<Video>> _scheduleCache = MapCache();
  final Cache<String, DashboardSchedule> _todayScheduleCache = MapCache();
  final Cache<String, ScheduleDateResponse> _scheduleDataCache = MapCache();

  final RateLimiter _rateLimiter = RateLimiter();
  final RateLimiter _dateRateLimiter = RateLimiter();

  Future<List<Video>> getCacheVideos({@required int day}) {
    return _scheduleCache.get(day);
  }

  Future<RepositoryResult<void>> startSchedule({
    @required int days,
  }) async {
    final response = await _apiServices.startSchedule(days: days);

    if (response is SuccessResponse<void>) {
      clearCache();
      await userManager.updateScheduleDays(days);
      return RepositorySuccessResult(
        response.body,
      );
    } else {
      if ((response as ErrorResponse).error is ApiException) {
        StartScheduleErrorResponse errorResponse =
            startScheduleErrorResponseFromJson(
                ((response as ErrorResponse).error as ApiException).body);

        if (errorResponse.message ==
            "The user has already started the schedule.") {
          await userManager.updateScheduleDays(days);
          return RepositorySuccessResult(
            errorResponse,
          );
        }
      }
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    }
  }

  Future<RepositoryResult<List<Video>>> fetchSchedule({
    @required int day,
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _rateLimiter.shouldFetch(day.toString());

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getSchedule(day: day);

      if (response is SuccessResponse<List<Video>>) {
        _scheduleCache.set(
          day,
          response.body,
        );
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<List<Video>>) {
        _rateLimiter.reset(
          day.toString(),
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _scheduleCache.get(day),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<DashboardSchedule>> fetchTodaySchedule({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _rateLimiter.shouldFetch(_todayScheduleKey);

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getTodaySchedule();

      if (response is SuccessResponse<DashboardSchedule>) {
        _todayScheduleCache.set(
          _todayScheduleKey,
          response.body,
        );
        return RepositorySuccessResult(
          response.body,
        );
      } else if (response is ErrorResponse<DashboardSchedule>) {
        _rateLimiter.reset(_todayScheduleKey);
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _todayScheduleCache.get(
          _todayScheduleKey,
        ),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<Map<String, dynamic>>> fetchScheduleProgress() async {
    final response = await _apiServices.getScheduleProgress();

    if (response is SuccessResponse<Map<String, dynamic>>) {
      return RepositorySuccessResult(
        response.body,
      );
    } else if (response is ErrorResponse<Map<String, dynamic>>) {
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<ScheduleDateResponse>> fetchScheduleDate({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _dateRateLimiter.shouldFetch(_scheduleDataKey);

    if (shouldFetch || forceApiRequest) {
      final response = await _apiServices.getScheduleDate();

      if (response is SuccessResponse<ScheduleDateResponse>) {
        if (response.body.length != null) {
          _scheduleDataCache.set(
            _scheduleDataKey,
            response.body,
          );
          return RepositorySuccessResult(
            response.body,
          );
        } else {
          _dateRateLimiter.reset(
            _scheduleDataKey,
          );
          return RepositoryErrorResult(
            ApiError.scheduleNotSelected,
          );
        }
      } else if (response is ErrorResponse<ScheduleDateResponse>) {
        _dateRateLimiter.reset(
          _scheduleDataKey,
        );
        return RepositoryUtils.handleRepositoryError(
          response,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _scheduleDataCache.get(_scheduleDataKey),
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  @override
  void clearCache() {
    _rateLimiter.resetAll();
    _dateRateLimiter.resetAll();
    _scheduleCache.invalidateAll();
    _scheduleDataCache.invalidateAll();
  }
}
