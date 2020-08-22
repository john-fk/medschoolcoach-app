import 'dart:convert';
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
import 'package:Medschoolcoach/utils/api/models/flashcards_stack_model.dart';
import 'package:Medschoolcoach/utils/api/models/last_watched_response.dart';
import 'package:Medschoolcoach/utils/api/models/login_response.dart';
import 'package:Medschoolcoach/utils/api/models/milestones.dart';
import 'package:Medschoolcoach/utils/api/models/profile_user.dart';
import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_date_response.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_progress.dart';
import 'package:Medschoolcoach/utils/api/models/search_result.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/api/models/sections_list.dart';
import 'package:Medschoolcoach/utils/api/models/statistics.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/api/models/lecturenote.dart';
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

  Future<NetworkResponse<void>> updateUserProfile({
    @required String userFirstName,
    @required String userLastName,
    @required String userEmail,
    // String phone,
    // String graduationYear,
    // String mcatTestDate,
  });
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
      return _handleError<SectionsList>(error);
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
      return _handleError<SectionsList>(error);
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
      return _handleError<SectionsList>(error);
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
      return _handleError<Section>(error);
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
      return _handleError<Statistics>(error);
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
      return _handleError<Subject>(error);
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
      return _handleError<Topic>(error);
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
      return _handleError<LectureNote>(error);
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
      return _handleError<LoginResponse>(error);
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
      return _handleError<void>(error);
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
      return _handleError<void>(error);
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
      return _handleError<void>(error);
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
      return _handleError<Auth0UserData>(error);
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
      return _handleError<LoginResponse>(error);
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
      return _handleError<void>(error);
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
      return _handleError<void>(error);
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
      return _handleError<FlashcardsStackModel>(error);
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
      return _handleError<SearchResult>(error);
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
      return _handleError<LastWatchedResponse>(error);
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
      return _handleError<void>(error);
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
      return _handleError<void>(error);
    }
  }

  Future<NetworkResponse<DashboardSchedule>> getTodaySchedule() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/schedule/dashboard",
        headers: headers,
      );

      return SuccessResponse<DashboardSchedule>(
        scheduleDashboardFromJson(response),
      );
    } catch (error) {
      return _handleError<DashboardSchedule>(error);
    }
  }

  Future<NetworkResponse<List<Video>>> getSchedule({
    @required int day,
  }) async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/schedule/$day",
        headers: headers,
      );

      return SuccessResponse<List<Video>>(
        videoFromJson(response),
      );
    } catch (error) {
      return _handleError<List<Video>>(error);
    }
  }

  @override
  Future<NetworkResponse<ScheduleDateResponse>> getScheduleDate() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/users/settings/schedule",
        headers: headers,
      );

      return SuccessResponse<ScheduleDateResponse>(
        scheduleDateResponseFromJson(response),
      );
    } catch (error) {
      return _handleError<ScheduleDateResponse>(error);
    }
  }

  @override
  Future<NetworkResponse<Map<String, dynamic>>> getScheduleProgress() async {
    try {
      final Map<String, String> headers = await _getHeaders();

      final String response = await _networkClient.get(
        "${_getBaseUrl()}/schedule/progress",
        headers: headers,
      );

      return SuccessResponse<Map<String, dynamic>>(
        scheduleProgressObjectFromJson(response).list,
      );
    } catch (error) {
      return _handleError<Map<String, dynamic>>(error);
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
      return _handleError<List<Bookmark>>(error);
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
      return _handleError<void>(error);
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
      return _handleError<void>(error);
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
      return _handleError<void>(error);
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
      return _handleError<void>(error);
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
      return _handleError<QuestionList>(error);
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
      return _handleError<void>(error);
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
      return _handleError<QuestionList>(error);
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
      return _handleError<void>(error);
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
      return _handleError<void>(error);
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
      return _handleError<AnswersSummary>(error);
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
      return _handleError<Milestones>(error);
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
      return _handleError<List<Buddy>>(error);
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
      return _handleError<ProfileUser>(error);
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
      final String response = await _networkClient.put(
        "${_getBaseUrl()}/users/update",
        headers: headers,
        body: json.encode(
          <String, dynamic>{
            "first_name": userFirstName,
            "last_name": userLastName,
            "email": userEmail,
            // "phone": phone,
            // "graduation_year": graduationYear,
            // "mcat_test_date": mcatTestDate
          },
        ),
      );

      return SuccessResponse<void>(response);
    } catch (error) {
      if (error is ApiException && error.code == 400)
        return ErrorResponse(UnavailableEmailException());

      return _handleError<void>(error);
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
      headers.addAll(
        {
          "Authorization": "Bearer " +
              await _getToken(
                accessToken: false,
              )
        },
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

  NetworkResponse<T> _handleError<T>(dynamic error) {
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
