import 'package:Medschoolcoach/repository/bookmarks_repository.dart';
import 'package:Medschoolcoach/repository/lecturenote_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/schedule_repository.dart';
import 'package:Medschoolcoach/repository/section_repository.dart';
import 'package:Medschoolcoach/repository/statistics_repository.dart';
import 'package:Medschoolcoach/repository/topic_repository.dart';
import 'package:Medschoolcoach/repository/tutoring_repository.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/repository/video_repository.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/auth0_user_data.dart';
import 'package:Medschoolcoach/utils/api/models/bookmark.dart';
import 'package:Medschoolcoach/utils/api/models/buddy.dart';
import 'package:Medschoolcoach/utils/api/models/dashboard_schedule.dart';
import 'package:Medschoolcoach/utils/api/models/last_watched_response.dart';
import 'package:Medschoolcoach/utils/api/models/lecturenote.dart';
import 'package:Medschoolcoach/utils/api/models/search_result.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/api/models/statistics.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class _InheritedSuperState extends InheritedWidget {
  final SuperState data;

  _InheritedSuperState({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedSuperState old) => true;
}

class SuperStateful extends StatefulWidget {
  final Widget child;

  SuperStateful({
    @required this.child,
  });

  static SuperState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_InheritedSuperState>())
        .data;
  }

  @override
  SuperState createState() => SuperState();
}

class SuperState extends State<SuperStateful> {
  final TopicRepository _topicRepository =
      Injector.appInstance.getDependency<TopicRepository>();
  final LectureNoteRepository _lectureNoteRepository =
      Injector.appInstance.getDependency<LectureNoteRepository>();
  final SectionRepository _sectionRepository =
      Injector.appInstance.getDependency<SectionRepository>();
  final VideoRepository _videoRepository =
      Injector.appInstance.getDependency<VideoRepository>();
  final ScheduleRepository _scheduleRepository =
      Injector.appInstance.getDependency<ScheduleRepository>();
  final BookmarksRepository _bookmarksRepository =
      Injector.appInstance.getDependency<BookmarksRepository>();
  final StatisticsRepository _statisticsRepository =
      Injector.appInstance.getDependency<StatisticsRepository>();
  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();
  final TutoringRepository _tutoringRepository =
      Injector.appInstance.getDependency<TutoringRepository>();

  final _apiServices = Injector.appInstance.getDependency<ApiServices>();

  Map<String, Topic> topics = Map();
  Map<String, Section> sections = Map();
  List<Section> flashcardsSections = List();
  List<Section> questionsSections = List();
  List<Section> sectionsList = List();
  List<Video> videosScheduleList = List();
  DashboardSchedule todaySchedule;
  List<Bookmark> bookmarksList = List();
  Map<String, int> scheduleProgress = Map();
  int currentScheduleDay;
  LastWatchedResponse recentlyWatched;
  SearchResult searchResult;
  SearchArguments recentSearchArguments;
  Statistics globalStatistics;
  LectureNote lectureNote;
  List<Buddy> buddiesList = List();
  Auth0UserData userData;
  List<TutoringSlider> tutoringSliders = List();

  Future<RepositoryResult<List<Section>>> updateSectionsList({
    bool forceApiRequest = false,
  }) async {
    final result = await _sectionRepository.fetchSectionList(
        forceApiRequest: forceApiRequest);
    if (result is RepositorySuccessResult<List<Section>>) {
      sectionsList = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<Auth0UserData>> updateUserData({
    bool forceApiRequest = false,
  }) async {
    final result = await _userRepository.getAuth0UserData(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<Auth0UserData>) {
      userData = result.data;
    }
    setState(() {});
    return result;
  }

  Future<NetworkResponse<List<Buddy>>> updateBuddiesList() async {
    final result = await _apiServices.getBuddies();

    if (result is SuccessResponse<List<Buddy>>) {
      buddiesList = result.body;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<List<Section>>> updateFlashcardsSectionsList({
    bool forceApiRequest = false,
  }) async {
    final result = await _sectionRepository.fetchFlashcardsSectionsList(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<List<Section>>) {
      flashcardsSections = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<List<Section>>> updateQuestionsSectionsList({
    bool forceApiRequest = false,
  }) async {
    final result = await _sectionRepository.fetchQuestionsSectionsList(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<List<Section>>) {
      questionsSections = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<SearchResult>> updateRecentSearchResult() async {
    if (recentSearchArguments == null) return null;
    return updateSearchResult(recentSearchArguments);
  }

  Future<RepositoryResult<Statistics>> updateGlobalStatistics({
    bool forceApiRequest = false,
  }) async {
    final result = await _statisticsRepository.fetchGlobalStatistics(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<Statistics>) {
      globalStatistics = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<SearchResult>> updateSearchResult(
      SearchArguments arguments) async {
    final result = await _videoRepository.search(arguments);
    if (result is RepositorySuccessResult<SearchResult>) {
      searchResult = result.data;
    }
    recentSearchArguments = arguments;
    setState(() {});
    return result;
  }

  Future<RepositoryResult<LastWatchedResponse>>
      updateRecentlyWatchedVideo() async {
    final result = await _videoRepository.lastWatched();
    if (result is RepositorySuccessResult<LastWatchedResponse>) {
      recentlyWatched = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<Topic>> updateTopic(
    String topicId, {
    bool forceApiRequest = false,
  }) async {
    final result = await _topicRepository.fetchTopic(
      topicId,
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<Topic>) {
      topics.update(
        topicId,
        (_) => result.data,
        ifAbsent: () => result.data,
      );
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<LectureNote>> updateLectureNote(String videoId, {
    bool forceApiRequest = false,
  }) async {
    final result = await _lectureNoteRepository.fetchLectureNote(videoId,
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<LectureNote>) {
      lectureNote = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<Section>> updateSection(
    String sectionId, {
    bool forceApiRequest = false,
  }) async {
    final result = await _sectionRepository.fetchSection(
      sectionId,
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<Section>) {
      sections.update(
        sectionId,
        (_) => result.data,
        ifAbsent: () => result.data,
      );
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<List<Video>>> updateSchedule({
    int day,
    bool forceApiRequest = false,
  }) async {
    if (day != null) {
      currentScheduleDay = day;
    }
    final result = await _scheduleRepository.fetchSchedule(
      day: currentScheduleDay,
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<List<Video>>) {
      videosScheduleList = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<DashboardSchedule>> updateTodaySchedule({
    bool forceApiRequest = false,
  }) async {
    final result = await _scheduleRepository.fetchTodaySchedule(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<DashboardSchedule>) {
      todaySchedule = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<List<Bookmark>>> updateBookmarks({
    bool forceApiRequest = false,
  }) async {
    final result = await _bookmarksRepository.fetchBookmarks(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<List<Bookmark>>) {
      bookmarksList = result.data;
    }
    setState(() {});
    return result;
  }

  Future<List<TutoringSlider>> updateTutoringSlider(
      BuildContext context) async {
    final result = await _tutoringRepository.fetchSliders(context);
    tutoringSliders = result;
    setState(() {});
    return result;
  }


  Future<RepositoryResult<Map<String, dynamic>>>
      updateScheduleProgress() async {
    final result = await _scheduleRepository.fetchScheduleProgress();
    if (result is RepositorySuccessResult<Map<String, dynamic>>) {
      result.data.forEach((String key, dynamic element) {
        scheduleProgress.update(key, (a) {
          int value;
          if (element.toString().contains(".")) {
            value = double.parse(element.toString()).round();
          } else {
            value = int.parse(element.toString());
          }
          return value;
        }, ifAbsent: () {
          int value;
          if (element.toString().contains(".")) {
            value = double.parse(element.toString()).round();
          } else {
            value = int.parse(element.toString());
          }
          return value;
        });
      });
    }
    setState(() {});
    return result;
  }

  void clearData() {
    topics = Map();
    sections = Map();
    flashcardsSections = List();
    questionsSections = List();
    sectionsList = List();
    videosScheduleList = List();
    todaySchedule = null;
    bookmarksList = List();
    scheduleProgress = Map();
    buddiesList = List();
    currentScheduleDay = null;
    recentlyWatched = null;
    searchResult = null;
    recentSearchArguments = null;
    globalStatistics = null;
    tutoringSliders = null;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedSuperState(
      data: this,
      child: widget.child,
    );
  }
}
