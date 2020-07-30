import 'dart:convert';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/repository/bookmarks_repository.dart';
import 'package:Medschoolcoach/repository/cache/cache.dart';
import 'package:Medschoolcoach/repository/cache/map_chache.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/repository/questions_repository.dart';
import 'package:Medschoolcoach/repository/rate_limiter/rate_limiter.dart';
import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/repository/schedule_repository.dart';
import 'package:Medschoolcoach/repository/section_repository.dart';
import 'package:Medschoolcoach/repository/statistics_repository.dart';
import 'package:Medschoolcoach/repository/subject_repository.dart';
import 'package:Medschoolcoach/repository/topic_repository.dart';
import 'package:Medschoolcoach/repository/video_repository.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/auth0_user_data.dart';
import 'package:Medschoolcoach/utils/api/models/login_response.dart';
import 'package:Medschoolcoach/utils/api/models/profile_user.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:native_mixpanel/native_mixpanel.dart';

const _rateLimiterKey = "userKey";
const _profileUserLimiterKey = "profileUserKey";
const _userCacheKey = "userCacheKey";

class UserRepository implements Repository {
  final ApiServices _apiServices;
  final UserManager _userManager;
  final SectionRepository _sectionRepository;
  final SubjectRepository _subjectRepository;
  final TopicRepository _topicRepository;
  final VideoRepository _videoRepository;
  final FlashcardRepository _flashcardRepository;
  final ScheduleRepository _scheduleRepository;
  final BookmarksRepository _bookmarksRepository;
  final QuestionsRepository _questionsRepository;
  final StatisticsRepository _statisticsRepository;
  final Mixpanel _mixpanel;
  final FirebaseAnalytics _firebaseAnalytics;

  UserRepository(
      this._apiServices,
      this._userManager,
      this._sectionRepository,
      this._subjectRepository,
      this._topicRepository,
      this._videoRepository,
      this._flashcardRepository,
      this._scheduleRepository,
      this._bookmarksRepository,
      this._questionsRepository,
      this._statisticsRepository,
      this._mixpanel,
      this._firebaseAnalytics,
      );

  final Cache<String, Auth0UserData> _userCache = MapCache();
  final Cache<String, ProfileUser> _profileUserCache = MapCache();

  String userLoggingEmail;

  final RateLimiter _rateLimiter = RateLimiter(
    timeout: Duration(
      minutes: 30,
    ),
  );

  Future<RepositoryResult<LoginResponse>> login({
    @required String userEmail,
    @required String password,
  }) async {
    final response = await _apiServices.login(
      userEmail: userEmail,
      password: password,
    );

    if (response is SuccessResponse<LoginResponse>) {
      _logLoginEvent(userEmail);
      _setFirebaseUserEmailProperty(userEmail);
      userLoggingEmail = userEmail;


      await _updateUser(
        accessToken: response.body.accessToken,
        idToken: response.body.idToken,
        refreshToken: response.body.refreshToken,
        expiresIn: response.body.expiresIn,
        lastTokenAccessTimeStamp: DateTime.now().toIso8601String(),
      );
      return RepositorySuccessResult(
        response.body,
      );
    } else if (response is ErrorResponse<LoginResponse>) {
      if (response.error is ApiException &&
          jsonDecode(
                  (response.error as ApiException).body)["error_description"] ==
              "Wrong email or password.") {
        return RepositoryErrorResult(
          ApiError.wrongCredentials,
        );
      }
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    }
    return RepositoryErrorResult(
      ApiError.unknown,
    );
  }

  Future<RepositoryResult<void>> register({
    @required String userEmail,
    @required String password,
    @required String userFirstName,
    @required String userLastName,
/*    @required String phoneNumber,
    @required String undergraduateSchool,
    @required String graduationYear,
    @required String testDate,*/
  }) async {
    final registerResponse = await _apiServices.register(
      userEmail: userEmail,
      password: password,
      userFirstName: userFirstName,
      userLastName: userLastName,
/*      phoneNumber: phoneNumber,
      undergraduateSchool: undergraduateSchool,
      graduationYear: graduationYear,
      testDate: testDate,*/
    );
    if (registerResponse is SuccessResponse<void>) {
      _logRegisterEvent(userEmail);
      final loginResponse = await login(
        userEmail: userEmail,
        password: password,
      );

      return loginResponse;
    } else {
      if (registerResponse is Auth0ErrorNetworkResponse) {
        return RepositoryErrorResultAuth0(
          registerResponse.errorResponse,
        );
      } else {
        return RepositoryUtils.handleRepositoryError(
          registerResponse,
        );
      }
    }
  }

  void _logRegisterEvent(String userEmail) {

    _mixpanel.track(Config.mixPanelUserRegisterEvent, {
      "\$email": userEmail,
    });
  }

  void _logLoginEvent(String userEmail) {
    _mixpanel.track(Config.mixPanelUserLoginEvent, {
      "\$email": userEmail,
    });
  }

  void _setFirebaseUserEmailProperty(String userEmail) {
    _firebaseAnalytics.setUserProperty(name: "email", value: userEmail);
  }

  Future<RepositoryResult<void>> resetPassword({
    @required String userEmail,
  }) async {
    final response = await _apiServices.resetPassword(
      userEmail: userEmail,
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

  Future<RepositoryResult<Auth0UserData>> getAuth0UserData({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _rateLimiter.shouldFetch(
      _rateLimiterKey,
    );

    if (shouldFetch || forceApiRequest) {
      final userResponse = await _apiServices.getAuth0UserData();

      if (userResponse is SuccessResponse<Auth0UserData>) {
        if (userLoggingEmail != null && userLoggingEmail.isNotEmpty) {
          await _identifyUser(userResponse);
          Crashlytics.instance.setUserIdentifier(userResponse.body.sub);
          Crashlytics.instance.setUserEmail(userResponse.body.email);
          Crashlytics.instance.setUserName(userResponse.body.name);
        }

        _userCache.set(_userCacheKey, userResponse.body);
        return RepositorySuccessResult(
          userResponse.body,
        );
      } else {
        _rateLimiter.reset(_rateLimiterKey);
        return RepositoryErrorResult(
          ApiError.unknown,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _userCache.get(
          _userCacheKey,
        ),
      );
    }
  }

  Future _identifyUser(SuccessResponse<Auth0UserData> userResponse) async {
    await _mixpanel.identify(userResponse.body.sub);
    await _mixpanel.identifyPeople(userResponse.body.sub);
    await _setEmail(userResponse);
    // result = _mixpanel.identy...
    // print(result + result1 + result2);
  }

  Future _setEmail(SuccessResponse<Auth0UserData> userResponse) async {
    return await _mixpanel.setPeopleProperties(<String, String>{
      "\$email": userLoggingEmail,
    });
  }

  Future<RepositoryResult<ProfileUser>> getProfileUser({
    bool forceApiRequest = false,
  }) async {
    final shouldFetch = _rateLimiter.shouldFetch(
      _profileUserLimiterKey,
    );

    if (shouldFetch || forceApiRequest) {
      final userResponse = await _apiServices.getProfileUser();

      if (userResponse is SuccessResponse<ProfileUser>) {
        _profileUserCache.set(_userCacheKey, userResponse.body);
        return RepositorySuccessResult(
          userResponse.body,
        );
      } else {
        _rateLimiter.reset(_profileUserLimiterKey);
        return RepositoryErrorResult(
          ApiError.unknown,
        );
      }
    } else {
      return RepositorySuccessResult(
        await _profileUserCache.get(
          _userCacheKey,
        ),
      );
    }
  }

  Future _updateUser({
    @required String accessToken,
    @required String idToken,
    @required String refreshToken,
    @required int expiresIn,
    @required String lastTokenAccessTimeStamp,
  }) async {
    _userManager.update(
      User(
        accessToken: accessToken,
        idToken: idToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
        lastTokenAccessTimeStamp: lastTokenAccessTimeStamp,
      ),
    );
  }

  Future<RepositoryResult<void>> updateUserProfile({
    @required String userFirstName,
    @required String userLastName,
    @required String userEmail,
    // String phone,
    // String graduationYear,
    // String mcatTestDate,
  }) async {
    final response = await _apiServices.updateUserProfile(
      userEmail: userEmail,
      userFirstName: userFirstName,
      userLastName: userLastName,
      // phone: phone,
      // graduationYear: graduationYear,
      // mcatTestDate: mcatTestDate,
    );
    if (response is SuccessResponse<void>) {
      return RepositorySuccessResult(
        response.body,
      );
    } else {
      if (response is ErrorResponse &&
          response.error is UnavailableEmailException)
        return RepositoryErrorResult(
          ApiError.unavailableEmail,
        );
      return RepositoryUtils.handleRepositoryError(
        response,
      );
    }
  }

  void logout() {
    _apiServices.logout();
    _subjectRepository.clearCache();
    _sectionRepository.clearCache();
    _topicRepository.clearCache();
    _videoRepository.clearCache();
    _flashcardRepository.clearCache();
    _scheduleRepository.clearCache();
    _bookmarksRepository.clearCache();
    _questionsRepository.clearCache();
    _statisticsRepository.clearCache();
    clearCache();
    _userManager.logout();
  }

  @override
  void clearCache() {
    _rateLimiter.resetAll();
    _userCache.invalidateAll();
  }
}
