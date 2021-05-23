import 'package:Medschoolcoach/repository/bookmarks_repository.dart';
import 'package:Medschoolcoach/repository/lecturenote_repository.dart';
import 'package:Medschoolcoach/repository/progress_repository.dart';
import 'package:Medschoolcoach/repository/questions_day_repository.dart';
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
import 'package:Medschoolcoach/utils/api/models/flashcards_progress.dart';
import 'package:Medschoolcoach/utils/api/models/last_watched_response.dart';
import 'package:Medschoolcoach/utils/api/models/lecturenote.dart';
import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/api/models/question_bank_progress.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_stats.dart';
import 'package:Medschoolcoach/utils/api/models/search_result.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/api/models/statistics.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
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
class PopupData{
    final storage = FlutterSecureStorage();
    int questions;
    int videos;
    int flashcards;
    int popupNumber;
    int popupNumberShown;
    int wrongQuestion;
    int wrongCards;

    PopupData([
      this.questions = 0, this.videos  = 0, this.flashcards  = 0,
      this.popupNumber  = 0, this.popupNumberShown = 0, this.wrongQuestion  = 0,
      this.wrongCards  = 0
    ]);

    bool ignore(){
      return popupNumber == 2;
    }
    factory PopupData.fromJson(Map<String, dynamic> json) {
      return PopupData(
          json["questions"], json['videos'], json['flashcards'],
          json['popupNumber'],
          json['popupNumberShown'], json['wrongQuestion'],json['wrongCards']
      );
    }

    Map<String, int> toJson() => <String, int>{
      "questions" : questions,
      "videos" : videos,
      "flashcards" : flashcards,
      "popupNumber" : popupNumber,
      "popupNumberShown" : popupNumberShown,
      "wrongQuestion" : wrongQuestion,
      "wrongCards" : wrongCards
    };

    //force trigger show if 3x consecutive wrong question / low confidence card
    void triggerShow(){
      if (popupNumber < 2 && popupNumber == popupNumberShown)
          popupNumber = popupNumberShown + 1;
      updateData();
    }

    //decide whether to show or not, if yes, return popup number
    int shouldShow() {
      if (popupNumber != popupNumberShown)
        return popupNumber;
      else if (popupNumber < 2 && popupNumber == popupNumberShown &&
          (questions >= 30 || videos >= 20 || flashcards >= 30 ) ) {
          popupNumber = popupNumberShown+1;
          updateData();
          return popupNumber;
      } else
          return -1;
    }

    //reset count after shown
    void shown(int popupID) {
      questions = 0;
      videos = 0;
      flashcards = 0;
      wrongQuestion = 0;
      wrongCards = 0;
      popupNumberShown = popupID;
      updateData();
    }

    void updateData() {
      storage.write(
          key: "localTutorPopup", value: jsonEncode(this.toJson())
      );
    }
}


class SuperState extends State<SuperStateful> {
  final storage = FlutterSecureStorage();
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
  final ProgressRepository _progressRepository =
      Injector.appInstance.getDependency<ProgressRepository>();
  final QuestionsDayRepository _questionsDayRepository =
      Injector.appInstance.getDependency<QuestionsDayRepository>();
  final _apiServices = Injector.appInstance.getDependency<ApiServices>();

  Map<String, Topic> topics = Map();
  Map<String, Section> sections = Map();
  List<Section> flashcardsSections = List();
  List<Section> questionsSections = List();
  List<Section> sectionsList = List();
  List<Video> videosScheduleList = List();
  DashboardSchedule todaySchedule;

  ScheduleStats courseProgress;
  FlashcardsProgress flashcardProgress;
  QuestionBankProgress questionBankProgress;
  List<Bookmark> bookmarksList = List();
  Map<String, int> scheduleProgress = Map();
  int currentScheduleDay = 1;

  LastWatchedResponse recentlyWatched;
  SearchResult searchResult;
  SearchArguments recentSearchArguments;
  Statistics globalStatistics;
  LectureNote lectureNote;
  List<Buddy> buddiesList = List();
  Auth0UserData userData;
  List<TutoringSlider> tutoringSliders = List();

  //QOTD
  int currentQOTDIndex = 0;
  List<Question> questionsOfTheDay = List();
  int correctAnswers = 0;
  int wrongAnswers = 0;
  List<String> answeredQuestionsIds = [];

  //Popup Tracker
  PopupData localTutorPopup = PopupData();


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
    FlutterSecureStorage().write(key: "name", value: userData.name);
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
      flashcardsSections.sort((a, b) => a.name.compareTo(b.name));
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

  Future<RepositoryResult<LectureNote>> updateLectureNote(
    String videoId, {
    bool forceApiRequest = false,
  }) async {
    final result = await _lectureNoteRepository.fetchLectureNote(
      videoId,
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

  // Progress Screen
  Future<RepositoryResult<ScheduleStats>> updateCourseProgress({
    bool forceApiRequest = false,
  }) async {
    final result = await _progressRepository.fetchCourseProgress(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<ScheduleStats>) {
      courseProgress = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<FlashcardsProgress>> updateFlashcardProgress({
    bool forceApiRequest = false,
  }) async {
    final result = await _progressRepository.fetchFlashcardProgress(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<FlashcardsProgress>) {
      flashcardProgress = result.data;
    }
    setState(() {});
    return result;
  }

  Future<RepositoryResult<QuestionBankProgress>> updateQuestionBankProgress({
    bool forceApiRequest = false,
  }) async {
    final result = await _progressRepository.fetchQuestionBankProgress(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<QuestionBankProgress>) {
      questionBankProgress = result.data;
    }
    setState(() {});
    return result;
  }

  //region Tutoring Popup
  int showTutorPopup() {
    return localTutorPopup.shouldShow();
  }

  void popupAnswer({bool correct}) {
    if(localTutorPopup.ignore()) return;

    if (correct)
      localTutorPopup.wrongQuestion = 0;
    else
      localTutorPopup.wrongQuestion++;

    if (localTutorPopup.wrongQuestion == 3)
      localTutorPopup.triggerShow();
  }

  void popupAddCard(){
    if(localTutorPopup.ignore()) return;
    localTutorPopup.flashcards++;
    localTutorPopup.updateData();
  }


  void popupCountVideos({bool add=true}){
    if(localTutorPopup.ignore()) return;
    if (add)
      localTutorPopup.flashcards++ ;
    else if (localTutorPopup.flashcards > 0)
      localTutorPopup.flashcards--;

    localTutorPopup.updateData();
  }

  void popupAddQuestions(){
    if(localTutorPopup.ignore()) return;
    localTutorPopup.questions++;
    localTutorPopup.updateData();
  }

  void popupFlashcard({bool notConfident}) {
    if(localTutorPopup.ignore()) return;
    if (notConfident)
      localTutorPopup.wrongCards++;
    else
      localTutorPopup.wrongCards=0;

    //trigger popup check
    if (localTutorPopup.wrongCards == 3)
      localTutorPopup.triggerShow();
  }

  void shownTutorPopup(int popupID){
    localTutorPopup.shown(popupID);
    localTutorPopup.updateData();
  }

  void updatePopupData() {
    localTutorPopup.updateData();
  }

  Future<int> loadPopupData() async {
    String popupContent = await storage.read(key:"localTutorPopup");
    if (popupContent != null)
      localTutorPopup = PopupData.fromJson(jsonDecode(popupContent));
    else
      updatePopupData();
    return localTutorPopup.shouldShow();
  }
  //endregion

  Future<RepositoryResult<List<Question>>> updateQuestionsOfTheDay({
    bool forceApiRequest = false,
  }) async {
    final result = await _questionsDayRepository.fetchQuestionOfTheDay(
      forceApiRequest: forceApiRequest,
    );
    if (result is RepositorySuccessResult<List<Question>>) {
      questionsOfTheDay = result.data;
    }
    setState(() {});
    return result;
  }

  void clearData() {
    localTutorPopup = PopupData();
    topics = Map();
    sections = Map();
    flashcardsSections = List();
    questionsSections = List();
    sectionsList = List();
    videosScheduleList = List();
    todaySchedule = null;
    courseProgress = null;
    bookmarksList = List();
    scheduleProgress = Map();
    buddiesList = List();
    currentScheduleDay = null;
    recentlyWatched = null;
    searchResult = null;
    recentSearchArguments = null;
    globalStatistics = null;
    tutoringSliders = null;
    questionsOfTheDay = List();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedSuperState(
      data: this,
      child: widget.child,
    );
  }
}
