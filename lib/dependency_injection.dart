import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/bookmarks_repository.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/repository/lecturenote_repository.dart';
import 'package:Medschoolcoach/repository/questions_repository.dart';
import 'package:Medschoolcoach/repository/schedule_repository.dart';
import 'package:Medschoolcoach/repository/section_repository.dart';
import 'package:Medschoolcoach/repository/statistics_repository.dart';
import 'package:Medschoolcoach/repository/subject_repository.dart';
import 'package:Medschoolcoach/repository/topic_repository.dart';
import 'package:Medschoolcoach/repository/tutoring_repository.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/repository/video_repository.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/network_client.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';

void initializeDependencyInjection({
  @required String apiUrl,
  @required String auth0Url,
  @required AnalyticsProvider analyticsProvider,
}) {
  var injector = Injector.appInstance;

  injector.registerSingleton<NetworkClient>(
    (injector) {
      return NetworkClientImpl();
    },
  );

  injector.registerSingleton<UserManager>(
    (injector) {
      return UserManagerImpl();
    },
  );

  injector.registerSingleton<AnalyticsProvider>(
        (injector) {
      return analyticsProvider;
    },
  );

  injector.registerSingleton<FirebaseAnalytics>(
        (injector) {
      return FirebaseAnalytics();
    },
  );

  injector.registerSingleton<ApiServices>(
    (injector) {
      final NetworkClient networkClient =
          injector.getDependency<NetworkClient>();
      final userManager = injector.getDependency<UserManager>();
      return ApiServicesImpl(
        networkClient,
        userManager,
        apiUrl,
        auth0Url,
      );
    },
  );

  injector.registerSingleton<SectionRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return SectionRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<SubjectRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return SubjectRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<TopicRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return TopicRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<LectureNoteRepository>(
        (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return LectureNoteRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<FlashcardRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return FlashcardRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<VideoRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return VideoRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<ScheduleRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      final userManager = injector.getDependency<UserManager>();
      return ScheduleRepository(
        apiServices,
        userManager,
      );
    },
  );

  injector.registerSingleton<BookmarksRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return BookmarksRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<QuestionsRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return QuestionsRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<StatisticsRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      return StatisticsRepository(
        apiServices,
      );
    },
  );

  injector.registerSingleton<TutoringRepository>(
    (injector) {
      return TutoringRepository();
    },
  );

  injector.registerSingleton<UserRepository>(
    (injector) {
      final apiServices = injector.getDependency<ApiServices>();
      final userManager = injector.getDependency<UserManager>();
      final sectionRepository = injector.getDependency<SectionRepository>();
      final subjectRepository = injector.getDependency<SubjectRepository>();
      final topicRepository = injector.getDependency<TopicRepository>();
      final lectureNoteRepository = injector.getDependency<LectureNoteRepository>();
      final videoRepository = injector.getDependency<VideoRepository>();
      final flashcardRepository = injector.getDependency<FlashcardRepository>();
      final scheduleRepository = injector.getDependency<ScheduleRepository>();
      final bookmarksRepository = injector.getDependency<BookmarksRepository>();
      final questionsRepository = injector.getDependency<QuestionsRepository>();
      final statisticsRepository =
          injector.getDependency<StatisticsRepository>();
      final analyticsProvider = injector.getDependency<AnalyticsProvider>();
      final firebaseAnalytics = injector.getDependency<FirebaseAnalytics>();


      return UserRepository(
        apiServices,
        userManager,
        sectionRepository,
        subjectRepository,
        topicRepository,
        lectureNoteRepository,
        videoRepository,
        flashcardRepository,
        scheduleRepository,
        bookmarksRepository,
        questionsRepository,
        statisticsRepository,
        analyticsProvider,
        firebaseAnalytics
      );
    },
  );
}
