import 'package:Medschoolcoach/ui/bookmarks/bookmarks_screen.dart';
import 'package:Medschoolcoach/ui/coming_soon/coming_soon_screen.dart';
import 'package:Medschoolcoach/ui/feedback/feedback_screen.dart';
import 'package:Medschoolcoach/ui/flash_card/screen/flash_card_screen.dart';
import 'package:Medschoolcoach/ui/flash_cards_bank/flash_cards_bank_screen.dart';
import 'package:Medschoolcoach/ui/go_premium/go_premium_screen.dart';
import 'package:Medschoolcoach/ui/home/home_screen.dart';
import 'package:Medschoolcoach/ui/learn/learn_screen.dart';
import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/ui/onboarding/new_user_onboarding.dart';
import 'package:Medschoolcoach/ui/onboarding/old_user_onboarding.dart';
import 'package:Medschoolcoach/ui/onboarding/schedule_question_of_the_day_screen.dart';
import 'package:Medschoolcoach/ui/onboarding/schedule_test_date_screen.dart';
import 'package:Medschoolcoach/ui/onboarding/time_per_day_screen.dart';
import 'package:Medschoolcoach/ui/practice/practice_screen.dart';
import 'package:Medschoolcoach/ui/profile/profile_screen.dart';
import 'package:Medschoolcoach/ui/profile_tab/profile_screen.dart';
import 'package:Medschoolcoach/ui/progress/progress_screen.dart';
import 'package:Medschoolcoach/ui/questions/multiple_choice_question_screen.dart';
import 'package:Medschoolcoach/ui/questions/question_bank_screen.dart';
import 'package:Medschoolcoach/ui/questions/questions_summary_screen.dart';
import 'package:Medschoolcoach/ui/refer_friend/refer_friend_screen.dart';
import 'package:Medschoolcoach/ui/search/search_screen.dart';
import 'package:Medschoolcoach/ui/section/section_screen.dart';
import 'package:Medschoolcoach/ui/settings/settings_screen.dart';
import 'package:Medschoolcoach/ui/topic/topic_screen.dart';
import 'package:Medschoolcoach/ui/tutoring/tutoring_screen.dart';
import 'package:Medschoolcoach/ui/videos/lecture_notes_screen.dart';
import 'package:Medschoolcoach/ui/videos/videos_screen.dart';
import 'package:Medschoolcoach/ui/videos/whiteboard_notes_screen.dart';
import 'package:Medschoolcoach/ui/welcome_screen/welcome_screen.dart';
import 'package:Medschoolcoach/utils/navigation/fade_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Routes {
  static const String onboarding = "onboarding";
  static const String welcome = "screen_welcome";
  static const String login = "login";
  static const String register = "register";
  static const String forgotPassword = "forgot";
  static const String home = "home";
  static const String schedule = "schedule";
  static const String profile_screen = "profile_screen";
  static const String search = "search";
  static const String videos = "videos";
  static const String lectureNotes = "lectureNotes";
  static const String whiteboardNotes = "whiteboardNotes";
  static const String section = "section";
  static const String lesson = "lesson";
  static const String topic = "topic";
  static const String comingSoon = "comingSoon";
  static const String questionBank = "questionBank";
  static const String multipleChoiceQuestion = "multipleChoiceQuestion";
  static const String questionsSummary = "questionsSummary";
  static const String flashCard = "flashCard";
  static const String flashCardsMenu = "flashCardsMenu";
  static const String bookmarks = "bookmarks";
  static const String referFriend = "referFriend";
  static const String contactSupport = "contactSupport";
  static const String goPremium = "goPremium";
  static const String profile = "profile";
  static const String userSettings = "settings";
  static const String tutoring = "tutoring";
  static const String scheduleQuestionOfTheDay =
      "screen_schedule_question_of_the_day";
  static const String scheduleTestDate = "screen_schedule_test_date";
  static const String timePerDay = "screen_study_time_per_day";
  static const String progressScreen = "screen_progress";
  static const String newUserOnboardingScreen = "screen_new_user_onboarding";
  static const String practiceScreen = "screen_practice";
  static const String oldUserOnboarding = "screen_old_user_onboarding";
  static const String questionOfTheDayScreen = "screen_question_of_the_day";

  static Route<void> generateRoute(RouteSettings settings) {
    FirebaseCrashlytics.instance.log("Open ${settings.name}");
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute<void>(
          builder: (_) => WelcomeScreen(),
        );
      case home:
        return FadeRoute(
          page: HomeScreen(source: settings.arguments),
        );
      case schedule:
        return FadeRoute(
          page: LearnScreen(settings.arguments),
        );
      case profile_screen:
        return FadeRoute(
          page: ProfileTabScreen(),
        );
      case search:
        return FadeRoute(
          page: SearchScreen(
            searchPhrase: settings.arguments,
          ),
        );
      case videos:
        return FadeRoute(
          page: VideosScreen(settings.arguments),
        );
      case lectureNotes:
        return FadeRoute(
          page: LectureNotesScreen(settings.arguments),
        );
      case whiteboardNotes:
        return FadeRoute(
          page: WhiteboardNotesScreen(settings.arguments),
        );
      case section:
        return FadeRoute(
          page: SectionScreen(settings.arguments),
        );
      case lesson:
        return FadeRoute(
          page: LessonVideoScreen(settings.arguments),
        );
      case topic:
        return FadeRoute(
          page: TopicScreen(settings.arguments),
        );
      case comingSoon:
        return FadeRoute(
          page: ComingSoonScreen(screenName: settings.arguments),
        );
      case questionBank:
        return FadeRoute(
          page: QuestionBankScreen(settings.arguments),
        );
      case flashCard:
        return FadeRoute(
          page: FlashCardScreen(settings.arguments),
        );
      case multipleChoiceQuestion:
        return FadeRoute(
          page: MultipleChoiceQuestionScreen(
            arguments: settings.arguments,
          ),
        );
      case questionsSummary:
        return FadeRoute(
          page: QuestionSummaryScreen(
            arguments: settings.arguments,
          ),
        );
      case flashCardsMenu:
        return FadeRoute(
          page: FlashCardsBankScreen(settings.arguments),
        );
      case bookmarks:
        return FadeRoute(
          page: BookmarksScreen(),
        );
      case referFriend:
        return FadeRoute(
          page: ReferFriendScreen(settings.arguments),
        );
      case contactSupport:
        return FadeRoute(
          page: FeedbackScreen(),
        );
      case goPremium:
        return FadeRoute(
          page: GoPremiumScreen(settings.arguments),
        );
      case profile:
        return FadeRoute(
          page: ProfileScreen(settings.arguments),
        );
      case userSettings:
        return FadeRoute(
          page: SettingsScreen(),
        );
      case tutoring:
        return FadeRoute(
          page: TutoringScreen(settings.arguments),
        );
      case scheduleQuestionOfTheDay:
        return FadeRoute(
            page: ScheduleQuestionOfTheDay(
          source: settings.arguments,
        ));
      case scheduleTestDate:
        return FadeRoute(
            page: SchedulingTestDateScreen(source: settings.arguments));
      case timePerDay:
        return FadeRoute(
            page: TimePerDay(
          source: (settings.arguments is String) ? settings.arguments : null,
        ));
      case progressScreen:
        return FadeRoute(page: ProgressScreen());
      case newUserOnboardingScreen:
        return FadeRoute(page: NewUserOnboarding());
      case practiceScreen:
        return FadeRoute(page: PracticeScreen(source: settings.arguments));
      case oldUserOnboarding:
        return FadeRoute(page: OldUserOnboarding());
      case questionOfTheDayScreen:
        return FadeRoute(
            page: MultipleChoiceQuestionScreen(
                arguments: MultipleChoiceQuestionScreenArguments(
                    status: QuestionStatusType.qotd)));
      default:
        throw Exception("No route defined for \"${settings.name}\"");
    }
  }

  static void navigateToTutoringScreen(BuildContext context, String source,
      {bool isNavBar = false}) {
    Navigator.of(context).pushNamed(Routes.tutoring,
        arguments:
            TutoringScreenData(source: source, showNavigationBar: isNavBar));
  }
}
