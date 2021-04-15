import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/answers_summary.dart';
import 'package:Medschoolcoach/utils/api/models/auth0_error_sign_up_response.dart';
import 'package:Medschoolcoach/utils/api/models/auth0_user_data.dart';
import 'package:Medschoolcoach/utils/api/models/bookmark.dart';
import 'package:Medschoolcoach/utils/api/models/buddy.dart';
import 'package:Medschoolcoach/utils/api/models/dashboard_schedule.dart';
import 'package:Medschoolcoach/utils/api/models/estimate_schedule.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_progress.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_stack_model.dart';
import 'package:Medschoolcoach/utils/api/models/last_watched_response.dart';
import 'package:Medschoolcoach/utils/api/models/lecturenote.dart';
import 'package:Medschoolcoach/utils/api/models/login_response.dart';
import 'package:Medschoolcoach/utils/api/models/milestones.dart';
import 'package:Medschoolcoach/utils/api/models/profile_user.dart';
import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/api/models/question_bank_progress.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_date_response.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_progress.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_stats.dart';
import 'package:Medschoolcoach/utils/api/models/search_result.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/api/models/sections_list.dart';
import 'package:Medschoolcoach/utils/api/models/statistics.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:flutter/cupertino.dart';

import 'models/flashcard_model.dart';
import 'network_client.dart';

class SearchArguments {
  final String subjectId;
  final String sectionId;
  final String topicId;
  final String searchingTerm;

  SearchArguments({
    this.subjectId,
    this.sectionId,
    this.topicId,
    @required this.searchingTerm,
  });
}

abstract class ApiServices {
  Future<NetworkResponse<SectionsList>> getSectionsList();

  Future<NetworkResponse<bool>> setTestDate(DateTime date);

  Future<NetworkResponse<bool>> setTimePerDay(int time);

  Future<NetworkResponse<SectionsList>> getFlashcardsSections();

  Future<NetworkResponse<SectionsList>> getQuestionsSections();

  Future<NetworkResponse<Section>> getSection({
    @required String sectionId,
  });

  Future<NetworkResponse<Statistics>> getGlobalStatistics();

  Future<NetworkResponse<FlashcardsStackModel>> getFlashcardsStack(
    FlashcardsStackArguments arguments,
  );

  Future<NetworkResponse<Subject>> getSubject({
    @required String subjectId,
  });

  Future<NetworkResponse<Topic>> getTopic({
    @required String topicId,
  });

  Future<NetworkResponse<LectureNote>> getLectureNote({
    @required String videoId,
  });

  Future<NetworkResponse<LoginResponse>> login({
    @required String userEmail,
    @required String password,
  });

  Future<NetworkResponse<void>> logout();

  Future<NetworkResponse<LoginResponse>> refreshToken();

  Future<NetworkResponse<void>> register({
    @required String userEmail,
    @required String password,
    @required String userFirstName,
    @required String userLastName,
/*    @required String phoneNumber,
    @required String undergraduateSchool,
    @required String graduationYear,
    @required String testDate,*/
  });

  Future<NetworkResponse<void>> resetPassword({
    @required String userEmail,
  });

  Future<NetworkResponse<Auth0UserData>> getAuth0UserData();

  Future<NetworkResponse<SearchResult>> search(SearchArguments arguments);

  Future<NetworkResponse<void>> setVideoProgress({
    @required String seconds,
    @required String videoId,
  });

  Future<NetworkResponse<void>> setFlashcardProgress({
    @required String flashcardId,
    @required FlashcardStatus status,
  });

  Future<NetworkResponse<LastWatchedResponse>> lastWatched();

  Future<NetworkResponse<void>> requestTutoringInfo();

  Future<NetworkResponse<void>> requestForTutoringUpsell();

  Future<NetworkResponse<void>> startSchedule({
    @required int days,
  });

  Future<NetworkResponse<List<Video>>> getSchedule({
    @required int day,
  });

  Future<NetworkResponse<DashboardSchedule>> getTodaySchedule();

  Future<NetworkResponse<ScheduleDateResponse>> getScheduleDate();

  Future<NetworkResponse<Map<String, dynamic>>> getScheduleProgress();

  Future<NetworkResponse<List<Bookmark>>> getBookmarks();

  Future<NetworkResponse<void>> addBookmark({
    @required String videoId,
  });

  Future<NetworkResponse<void>> deleteBookmark({
    @required String videoId,
  });

  Future<NetworkResponse<void>> sendFeedback({
    @required String message,
    @required List<String> bugVsAccount,
    @required String platform,
  });

  Future<NetworkResponse<void>> inviteFriend({
    @required String email,
    @required String firstName,
    @required String lastName,
  });

  Future<NetworkResponse<QuestionList>> getQuestions({
    String subjectId,
    String videoId,
  });

  Future<NetworkResponse<void>> sendQuestionAnswer({
    @required String questionId,
    @required String answer,
  });

  Future<NetworkResponse<QuestionList>> getFavouriteQuestions();

  Future<NetworkResponse<void>> addFavouriteQuestion({
    @required String questionId,
  });

  Future<NetworkResponse<void>> deleteFavouriteQuestion({
    @required String questionId,
  });

  Future<NetworkResponse<AnswersSummary>> getAnswersSummary();

  Future<NetworkResponse<Milestones>> getMilestones();

  Future<NetworkResponse<List<Buddy>>> getBuddies();

  Future<NetworkResponse<ProfileUser>> getProfileUser();

  Future<NetworkResponse<FlashcardsProgress>> getFlashcardsProgress();

  Future<EstimateSchedule> getEstimateCompletion();

  Future<NetworkResponse<ScheduleStats>> getCourseProgress();

  Future<ProfileUser> getAccountData();

  Future<NetworkResponse<List<Question>>> getQuestionOfTheDayQuestions();

  Future<NetworkResponse<QuestionBankProgress>> getQuestionBankProgress();

  Future<NetworkResponse<void>> updateUserProfile({
    @required String userFirstName,
    @required String userLastName,
    @required String userEmail,
    // String phone,
    // String graduationYear,
    // String mcatTestDate,
  });

  Future<NetworkResponse<bool>> setOnboarded();
}

class ApiServicesImpl implements ApiServices {
  final String _baseUrl;
  final String _baseAuth0Url;
  final NetworkClient _networkClient;
  final UserManager _userManager;

  ApiServicesImpl(
    this._networkClient,
    this._userManager,
    this._baseUrl,
    this._baseAuth0Url,
  );

  @override
  Future<NetworkResponse<SectionsList>> getSectionsList() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        _getBaseUrl() + "/sections",
        headers: headers,
      );

      return SuccessResponse<SectionsList>(sectionListFromJson(response));
    } catch (error) {
      return _handleError<SectionsList>(error, SectionsList);
    }
  }

  @override
  Future<NetworkResponse<FlashcardsProgress>> getFlashcardsProgress() async {
    try {
      Map<String, String> headers = await _getHeaders(contentType: true);
      final String response = await _networkClient.get(
        _getBaseUrl() + "/flashcards/stats",
        headers: headers,
      );
      var data = FlashcardsProgress.fromJson(json.decode(response));
      return SuccessResponse(data);
    } catch (error) {
      return _handleError<FlashcardsProgress>(error, FlashcardsProgress);
    }
  }

  @override
  Future<NetworkResponse<QuestionBankProgress>>
      getQuestionBankProgress() async {
    try {
      final Map<String, String> headers = await _getHeaders(contentType: true);
      final String response = await _networkClient.get(
        _getBaseUrl() + "/questions/stats",
        headers: headers,
      );
      var data = QuestionBankProgress.fromJson(json.decode(response));
      return SuccessResponse(data);
    } catch (error) {
      return _handleError<QuestionBankProgress>(error, QuestionBankProgress);
    }
  }

  Future<NetworkResponse<ScheduleStats>> getCourseProgress() async {
    try {
      final Map<String, String> headers = await _getHeaders();
      final String response = await _networkClient
          .get(_getBaseUrl() + "/stats/schedule?isHour=true", headers: headers);
      var data = ScheduleStats.fromJson(jsonDecode(response));
      return SuccessResponse<ScheduleStats>(data);
    } catch (error) {
      log("getCourseProgress Error:- $error");
      return null;
    }
  }

  Future<NetworkResponse<List<Question>>> getQuestionOfTheDayQuestions() async {
    try {
      final Map<String, String> headers = await _getHeaders();
      final String response = await _networkClient
          .get(_getBaseUrl() + "/questions/day?limit=5", headers: headers);
      var data = questionFromJson(response);
      return SuccessResponse<List<Question>>(data);
    } catch (error) {
      log("getQuestionOfTheDayQuestions:- $error");
      return null;
    }
  }

  @override
  Future<NetworkResponse<bool>> setTestDate(DateTime date) async {
    final body = json.encode({"mcatTestDate": date.toString()});
    try {
      final Map<String, String> headers = await _getHeaders(contentType: true);

      await _networkClient.patch(_getBaseUrl() + "/users/onboard",
          headers: headers, body: body);
      return SuccessResponse<bool>(true);
    } catch (error) {
      return _handleError<bool>(error, bool);
    }
  }

  @override
  Future<NetworkResponse<bool>> setOnboarded() async {
    try {
      final Map<String, String> headers = await _getHeaders(contentType: true);
      final body = json.encode({"onboarded": "true"});
      await _networkClient.patch(_getBaseUrl() + "/users/onboard",
          headers: headers, body: body);
      return SuccessResponse<bool>(true);
    } catch (error) {
      return _handleError<bool>(error, bool);
    }
  }

  @override
  Future<NetworkResponse<bool>> setTimePerDay(int time) async {
    final body = {"hours": "$time"};
    try {
      final Map<String, String> headers = await _getHeaders();
      final String response = await _networkClient.post(
          _getBaseUrl() + "/schedule/create",
          headers: headers,
          body: body);
      log("create schedule response:- " + response);
      return SuccessResponse<bool>(true);
    } catch (error) {
      log(error.toString());
      return _handleError<bool>(error, bool);
    }
  }

  @override
  Future<NetworkResponse<SectionsList>> getFlashcardsSections() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        _getBaseUrl() + "/sections/flashcard",
        headers: headers,
      );

      return SuccessResponse<SectionsList>(sectionListFromJsonList(
        response,
      ));
    } catch (error) {
      return _handleError<SectionsList>(error, SectionsList);
    }
  }

  @override
  Future<NetworkResponse<SectionsList>> getQuestionsSections() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        _getBaseUrl() + "/sections/question",
        headers: headers,
      );

      return SuccessResponse<SectionsList>(sectionListFromJsonList(
        response,
      ));
    } catch (error) {
      return _handleError<SectionsList>(error, SectionsList);
    }
  }

  @override
  Future<NetworkResponse<Section>> getSection({
    @required String sectionId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        _getBaseUrl() + "/sections/$sectionId?progress=1&topics=1",
        headers: headers,
      );

      return SuccessResponse<Section>(
        Section.fromJson(
          json.decode(response),
        ),
      );
    } catch (error) {
      return _handleError<Section>(error, Section);
    }
  }

  @override
  Future<NetworkResponse<Statistics>> getGlobalStatistics() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        _getBaseUrl() + "/stats/global",
        headers: headers,
      );
      return SuccessResponse<Statistics>(
        Statistics.fromJson(
          json.decode(response),
        ),
      );
    } catch (error) {
      return _handleError<Statistics>(error, Statistics);
    }
  }

  @override
  Future<NetworkResponse<Subject>> getSubject({
    @required String subjectId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        _getBaseUrl() + "/subjects/$subjectId?progress=1",
        headers: headers,
      );
      return SuccessResponse<Subject>(
        Subject.fromJson(
          json.decode(response),
        ),
      );
    } catch (error) {
      return _handleError<Subject>(error, Subject);
    }
  }

  @override
  Future<NetworkResponse<Topic>> getTopic({
    @required String topicId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        _getBaseUrl() + "/topics/$topicId?progress=1",
        headers: headers,
      );

      return SuccessResponse<Topic>(
        Topic.fromJson(
          json.decode(response),
        ),
      );
    } catch (error) {
      return _handleError<Topic>(error, Topic);
    }
  }

  @override
  Future<NetworkResponse<LectureNote>> getLectureNote({
    @required String videoId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        _getBaseUrl() + "/videos/" + videoId + "/lecture-note",
        headers: headers,
      );

      return SuccessResponse<LectureNote>(
        LectureNote.fromJson(
          json.decode(response),
        ),
      );
    } catch (error) {
      return _handleError<LectureNote>(error, LectureNote);
    }
  }

  Future<NetworkResponse<LoginResponse>> login({
    @required String userEmail,
    @required String password,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        mobileHeader: false,
        authHeader: false,
        contentType: true,
      );

      final String response = await _networkClient.post(
        _baseAuth0Url + "/oauth/token",
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            'username': userEmail,
            'password': password,
            'realm': 'Username-Password-Authentication',
            'audience': 'https://auth.medschoolcoach.com',
            'scope': 'openid profile email offline_access offline_access',
            "client_id": Config.prodAuth0ClientId,
            "grant_type": 'password'
          },
        ),
      );

      return SuccessResponse<LoginResponse>(
        loginResponseFromJson(response),
      );
    } catch (error) {
      return _handleError<LoginResponse>(error, LoginResponse);
    }
  }

  Future<NetworkResponse<void>> logout() async {
    try {
      final Map<String, String> headers = await _getHeaders(
        mobileHeader: false,
        authHeader: true,
        contentType: false,
      );

      final String response = await _networkClient.get(
        _baseAuth0Url + "/v2/logout",
        headers: headers,
      );
      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<void>> register({
    @required String userEmail,
    @required String password,
    @required String userFirstName,
    @required String userLastName,
/*    @required String phoneNumber,
    @required String undergraduateSchool,
    @required String graduationYear,
    @required String testDate,*/
  }) async {
    final Map<String, String> headers = await _getHeaders(
      mobileHeader: false,
      authHeader: false,
      contentType: true,
    );

    try {
      final String response = await _networkClient.post(
        _baseAuth0Url + "/dbconnections/signup",
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "client_id": Config.prodAuth0ClientId,
            "email": userEmail,
            "password": password,
            "connection": "Username-Password-Authentication",
            "name": userFirstName + " " + userLastName,
            "user_metadata": {
              "first_name": userFirstName,
              "last_name": userLastName,
              /*"phone": phoneNumber,
              "school": undergraduateSchool,
              "graduation_year": graduationYear,
              "mcat_date": testDate,*/
              "mcat_lms_app_user": "true"
            }
          },
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<void>> resetPassword({
    @required String userEmail,
  }) async {
    final Map<String, String> headers = await _getHeaders(
      mobileHeader: false,
      authHeader: false,
      contentType: true,
    );

    try {
      final String response = await _networkClient.post(
        _baseAuth0Url + "/dbconnections/change_password",
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "client_id": Config.prodAuth0ClientId,
            "email": userEmail,
            "connection": "Username-Password-Authentication",
          },
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<Auth0UserData>> getAuth0UserData() async {
    final Map<String, String> headers = await _getHeaders(
      mobileHeader: false,
      authHeader: false,
      accessTokenHeader: true,
    );

    try {
      final String response = await _networkClient.get(
        _baseAuth0Url + "/userinfo",
        headers: headers,
      );

      return SuccessResponse<Auth0UserData>(
        auth0UserDataFromJson(response),
      );
    } catch (error) {
      return _handleError<Auth0UserData>(error, Auth0UserData);
    }
  }

  @override
  Future<NetworkResponse<LoginResponse>> refreshToken() async {
    final User user = await _userManager.get();
    final String refreshToken = user.refreshToken;

    try {
      final Map<String, String> headers = await _getHeaders(
        mobileHeader: false,
        authHeader: false,
        contentType: true,
      );

      final String response = await _networkClient.post(
        _baseAuth0Url + "/oauth/token",
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "client_id": Config.prodAuth0ClientId,
            "grant_type": 'refresh_token',
            "refresh_token": refreshToken
          },
        ),
      );

      final loginResponse = loginResponseFromJson(response);

      await _userManager.update(
        User(
          accessToken: loginResponse.accessToken,
          idToken: loginResponse.idToken,
          refreshToken: refreshToken,
          expiresIn: loginResponse.expiresIn,
          lastTokenAccessTimeStamp: DateTime.now().toIso8601String(),
        ),
      );

      return SuccessResponse<LoginResponse>(
        loginResponseFromJson(response),
      );
    } catch (error) {
      return _handleError<LoginResponse>(error, LoginResponse);
    }
  }

  @override
  Future<NetworkResponse<void>> setVideoProgress({
    @required String videoId,
    @required String seconds,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );

      final String response = await _networkClient.put(
        "${_getBaseUrl()}/videos/progress/$videoId",
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "seconds": seconds,
          },
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<void>> setFlashcardProgress({
    @required String flashcardId,
    @required FlashcardStatus status,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );

      final statusString = flashcardStatusToString(status);
      final String response = await _networkClient.put(
        "${_getBaseUrl()}/flashcards/progress/$flashcardId",
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "status": statusString,
          },
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<FlashcardsStackModel>> getFlashcardsStack(
      FlashcardsStackArguments arguments) async {
    try {
      final Map<String, String> headers = await _getHeaders();
      String url = _getBaseUrl() + "/flashcards/?";

      if (arguments.videoId != null)
        url += "video_id=${arguments.videoId}&limit=1000";
      else if (arguments.topicId != null)
        url += "topic_id=${arguments.topicId}&limit=1000";
      else if (arguments.subjectId != null)
        url += "subject_id=${arguments.subjectId}&limit=1000";
      else if (arguments.status != null)
        url += "status=${flashcardStatusToString(arguments.status)}&limit=1000";

      final response = await _networkClient.get(url, headers: headers);

      return SuccessResponse<FlashcardsStackModel>(
        FlashcardsStackModel.fromRawJson(response),
      );
    } catch (error) {
      return _handleError<FlashcardsStackModel>(error, FlashcardsStackModel);
    }
  }

  @override
  Future<NetworkResponse<SearchResult>> search(
    SearchArguments arguments,
  ) async {
    try {
      final Map<String, String> headers = await _getHeaders();

      String url =
          _getBaseUrl() + "/videos/search?term=${arguments.searchingTerm}";
      if (arguments.sectionId != null && arguments.sectionId.isNotEmpty) {
        url = url + "&section_id=${arguments.sectionId}";
      }
      if (arguments.subjectId != null && arguments.subjectId.isNotEmpty) {
        url = url + "&subject_id=${arguments.subjectId}";
      }
      if (arguments.topicId != null && arguments.topicId.isNotEmpty) {
        url = url + "&topic_id=${arguments.topicId}";
      }

      final String response = await _networkClient.get(
        url,
        headers: headers,
      );

      return SuccessResponse<SearchResult>(
        searchResultFromJson(response),
      );
    } catch (error) {
      return _handleError<SearchResult>(error, SearchResult);
    }
  }

  @override
  Future<NetworkResponse<LastWatchedResponse>> lastWatched() async {
    try {
      final Map<String, String> headers = await _getHeaders();
      String url = _getBaseUrl() + "/videos/last-watched";
      final String response = await _networkClient.get(
        url,
        headers: headers,
      );

      return SuccessResponse<LastWatchedResponse>(
        LastWatchedResponse.fromJson(
          jsonDecode(response),
        ),
      );
    } catch (error) {
      return _handleError<LastWatchedResponse>(error, LastWatchedResponse);
    }
  }

  @override
  Future<NetworkResponse<void>> requestTutoringInfo() async {
    try {
      final Map<String, String> headers = await _getHeaders();
      String url = _getBaseUrl() + "/user/workflow/request-info";
      final String response = await _networkClient.post(
        url,
        headers: headers,
      );
      return SuccessResponse<String>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<void>> requestForTutoringUpsell() async {
    try {
      final Map<String, String> headers = await _getHeaders();
      String url = _getBaseUrl() + "/user/workflow/tutoring-upsell";
      final String response = await _networkClient.post(
        url,
        headers: headers,
      );
      return SuccessResponse<String>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  Future<NetworkResponse<void>> startSchedule({
    @required int days,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );

      final String response = await _networkClient.put(
        "${_getBaseUrl()}/schedule/settings",
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "days": days,
          },
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  Future<NetworkResponse<DashboardSchedule>> getTodaySchedule() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/schedule/dashboard?isHour=true",
        headers: headers,
      );

      return SuccessResponse<DashboardSchedule>(
        scheduleDashboardFromJson(response),
      );
    } catch (error) {
      return _handleError<DashboardSchedule>(error, DashboardSchedule);
    }
  }

  Future<NetworkResponse<List<Video>>> getSchedule({
    @required int day,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/schedule/$day?isHour=true",
        headers: headers,
      );

      return SuccessResponse<List<Video>>(
        videoFromJson(response),
      );
    } catch (error) {
      return _handleError<List<Video>>(error, [Video]);
    }
  }

  @override
  Future<NetworkResponse<ScheduleDateResponse>> getScheduleDate() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/users/settings/schedule?isHour=true",
        headers: headers,
      );
      return SuccessResponse<ScheduleDateResponse>(
        scheduleDateResponseFromJson(response),
      );
    } catch (error) {
      return _handleError<ScheduleDateResponse>(error, ScheduleDateResponse);
    }
  }

  @override
  Future<NetworkResponse<Map<String, dynamic>>> getScheduleProgress() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/schedule/progress?isHour=true",
        headers: headers,
      );

      return SuccessResponse<Map<String, dynamic>>(
        scheduleProgressObjectFromJson(response).list,
      );
    } catch (error) {
      return _handleError<Map<String, dynamic>>(error, Map);
    }
  }

  @override
  Future<NetworkResponse<List<Bookmark>>> getBookmarks() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/videos/favorites",
        headers: headers,
      );

      return SuccessResponse<List<Bookmark>>(
        bookmarkFromJson(response),
      );
    } catch (error) {
      return _handleError<List<Bookmark>>(error, [Bookmark]);
    }
  }

  @override
  Future<NetworkResponse<void>> addBookmark({
    String videoId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );

      List<String> ids = [videoId];

      final String response = await _networkClient.post(
        "${_getBaseUrl()}/videos/favorites",
        headers: headers,
        body: json.encode(
          <String, dynamic>{"ids": ids},
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<void>> deleteBookmark({
    String videoId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );

      List<String> ids = [videoId];

      final String response = await _networkClient.delete(
        "${_getBaseUrl()}/videos/favorites",
        headers: headers,
        requestBody: json.encode(
          <String, dynamic>{"ids": ids},
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<void>> sendFeedback({
    @required String message,
    @required List<String> bugVsAccount,
    @required String platform,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );
      String url = _getBaseUrl() + "/feedback";

      final String response = await _networkClient.post(
        url,
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "message": message,
            "platform": platform,
            "bug_vs_account": bugVsAccount,
          },
        ),
      );
      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<void>> inviteFriend({
    @required String email,
    @required String firstName,
    @required String lastName,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );
      String url = _getBaseUrl() + "/referrals";

      final String response = await _networkClient.post(
        url,
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "email": email,
            "first_name": firstName,
            "last_name": lastName
          },
        ),
      );
      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<QuestionList>> getQuestions({
    String subjectId,
    String videoId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders();

      String url = _getBaseUrl() + "/questions?limit=1000";
      if (subjectId != null && subjectId.isNotEmpty) {
        url = url + "&subject_id=${subjectId}";
      }
      if (videoId != null && videoId.isNotEmpty) {
        url = url + "&video_id=${videoId}";
      }

      final String response = await _networkClient.get(
        url,
        headers: headers,
      );

      return SuccessResponse<QuestionList>(
        questionListFromJson(response),
      );
    } catch (error) {
      return _handleError<QuestionList>(error, QuestionList);
    }
  }

  @override
  Future<NetworkResponse<void>> sendQuestionAnswer(
      {@required String questionId, @required String answer}) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );
      String url = _getBaseUrl() + "/questions/answer";
      final String response = await _networkClient.post(
        url,
        headers: headers,
        body: json.encode(
          <String, String>{"question_id": questionId, "answer": answer},
        ),
      );
      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<QuestionList>> getFavouriteQuestions() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/questions/favorites",
        headers: headers,
      );

      return SuccessResponse<QuestionList>(
        QuestionList(
          items: questionFromJson(response),
        ),
      );
    } catch (error) {
      return _handleError<QuestionList>(error, QuestionList);
    }
  }

  @override
  Future<NetworkResponse<void>> addFavouriteQuestion({
    String questionId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );

      List<String> ids = [questionId];

      final String response = await _networkClient.post(
        "${_getBaseUrl()}/questions/favorites",
        headers: headers,
        body: json.encode(
          <String, dynamic>{"ids": ids},
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<void>> deleteFavouriteQuestion({
    String questionId,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );

      List<String> ids = [questionId];

      final String response = await _networkClient.delete(
        "${_getBaseUrl()}/questions/favorites",
        headers: headers,
        requestBody: json.encode(
          <String, dynamic>{"ids": ids},
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      return _handleError<void>(error, null);
    }
  }

  @override
  Future<NetworkResponse<AnswersSummary>> getAnswersSummary() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      String url = _getBaseUrl() + "/questions/answers-summaries";

      final String response = await _networkClient.get(
        url,
        headers: headers,
      );

      return SuccessResponse<AnswersSummary>(
        answersSummariesFromJson(response),
      );
    } catch (error) {
      return _handleError<AnswersSummary>(error, AnswersSummary);
    }
  }

  @override
  Future<NetworkResponse<Milestones>> getMilestones() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      String url = _getBaseUrl() + "/stats/profile";

      final String response = await _networkClient.get(
        url,
        headers: headers,
      );

      return SuccessResponse<Milestones>(
        milestonesFromJson(response),
      );
    } catch (error) {
      return _handleError<Milestones>(error, Milestones);
    }
  }

  @override
  Future<NetworkResponse<List<Buddy>>> getBuddies() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      String url = _getBaseUrl() + "/referrals";

      final String response = await _networkClient.get(
        url,
        headers: headers,
      );

      return SuccessResponse<List<Buddy>>(
        buddyFromJson(response),
      );
    } catch (error) {
      return _handleError<List<Buddy>>(error, [Buddy]);
    }
  }

  @override
  Future<NetworkResponse<ProfileUser>> getProfileUser() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      String url = _getBaseUrl() + "/users/account";

      final String response = await _networkClient.get(
        url,
        headers: headers,
      );

      return SuccessResponse<ProfileUser>(
        profileUserFromJson(response),
      );
    } catch (error) {
      return _handleError<ProfileUser>(error, ProfileUser);
    }
  }

  Future<ProfileUser> getAccountData() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      String url = _getBaseUrl() + "/users/account";

      final String response = await _networkClient.get(
        url,
        headers: headers,
      );
      return profileUserFromJson(response);
    } catch (error) {
      return null;
    }
  }

  @override
  Future<NetworkResponse<void>> updateUserProfile({
    @required String userFirstName,
    @required String userLastName,
    @required String userEmail,
    // String phone,
    // String graduationYear,
    // String mcatTestDate,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders(
        contentType: true,
      );

      Map<String, dynamic> body = <String, dynamic>{
        "first_name": userFirstName,
        "last_name": userLastName,
      };

      if (userEmail != null) {
        body.addAll(<String, dynamic>{"email": userEmail});
      }

      final String response = await _networkClient.put(
        "${_getBaseUrl()}/users/update",
        headers: headers,
        body: json.encode(body),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      if (error is ApiException && error.code == 400)
        return ErrorResponse(UnavailableEmailException());

      return _handleError<void>(error, null);
    }
  }

  @override
  Future<EstimateSchedule> getEstimateCompletion() async {
    try {
      final Map<String, String> headers = await _getHeaders();
      final String response = await _networkClient.get(
        "${_getBaseUrl()}/schedule/estimate-completion?isHour=true",
        headers: headers,
      );
      return EstimateSchedule.fromJSON(json.decode(response));
    } catch (error) {
      return null;
    }
  }

  Future<Map<String, String>> _getHeaders({
    bool mobileHeader = true,
    bool authHeader = true,
    bool contentType = false,
    bool accessTokenHeader = false,
  }) async {
    Map<String, String> headers = Map();

    if (mobileHeader) {
      headers.addAll(
        {"mobile": "true"},
      );
    }

    if (authHeader) {
      var token = await _getToken(
        accessToken: false,
      );
      headers.addAll(
        {"Authorization": "Bearer " + token},
      );
    }

    if (contentType) {
      headers.addAll(
        {"Content-Type": "application/json"},
      );
    }

    if (accessTokenHeader) {
      headers.addAll(
        {
          "Authorization": "Bearer " +
              await _getToken(
                accessToken: true,
              )
        },
      );
    }

    return headers;
  }

  String _getBaseUrl() {
    if (Config.showSwitch) {
      if (Config.switchValue) {
        return Config.prodApiUrl;
      } else {
        return Config.devApiUrl;
      }
    } else {
      return _baseUrl;
    }
  }

  Future<String> _getToken({
    bool accessToken = true,
  }) async {
    User user = await _userManager.get();

    final int timeDifference = DateTime.now()
        .difference(
          DateTime.parse(user.lastTokenAccessTimeStamp),
        )
        .inSeconds;

    if (timeDifference > /*user.expiresIn*/ Config.tokenValidityTime) {
      await refreshToken();
      user = await _userManager.get();
    }

    if (accessToken) {
      return user.accessToken;
    } else {
      return user.idToken;
    }
  }

  NetworkResponse<T> _handleError<T>(dynamic error, dynamic type) {
    log("type is:- ${type} and error is: - " + error.toString());
    if (error is SocketException) {
      return ErrorResponse<T>(error);
    }
    if (error is ApiException) {
      if (error.code == 401) {
        return ErrorResponse<T>(
          SessionExpiredException(),
        );
      }
      try {
        Auth0ErrorSignUpResponse response =
            auth0ErrorSignUpResponseFromJson(error.body);
        if (response.name != null &&
            response.statusCode != null &&
            response.statusCode == 400) {
          return Auth0ErrorNetworkResponse<T>(response);
        }
      } catch (error) {
        return ErrorResponse<T>(error);
      }
    }

    if (error is TypeError) {
      return ErrorResponse<T>(Exception());
    } else {
      return ErrorResponse<T>(error);
    }
  }
}
