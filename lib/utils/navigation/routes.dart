import 'package:Medschoolcoach/ui/bookmarks/bookmarks_screen.dart';
import 'package:Medschoolcoach/ui/coming_soon/coming_soon_screen.dart';
import 'package:Medschoolcoach/ui/feedback/feedback_screen.dart';
import 'package:Medschoolcoach/ui/flash_card/screen/flash_card_screen.dart';
import 'package:Medschoolcoach/ui/flash_cards_bank/flash_cards_bank_screen.dart';
import 'package:Medschoolcoach/ui/forgot/forgot_password_screen.dart';
import 'package:Medschoolcoach/ui/go_premium/go_premium_screen.dart';
import 'package:Medschoolcoach/ui/home/home_screen.dart';

import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/ui/login/login_screen.dart';
import 'package:Medschoolcoach/ui/more/more_screen.dart';
import 'package:Medschoolcoach/ui/profile/profile_screen.dart';
import 'package:Medschoolcoach/ui/questions/multiple_choice_question_screen.dart';
import 'package:Medschoolcoach/ui/questions/question_bank_screen.dart';
import 'package:Medschoolcoach/ui/questions/questions_summary_screen.dart';
import 'package:Medschoolcoach/ui/refer_friend/refer_friend_screen.dart';
import 'package:Medschoolcoach/ui/register/register_screen.dart';
import 'package:Medschoolcoach/ui/schedule/schedule_screen.dart';
import 'package:Medschoolcoach/ui/search/search_screen.dart';
import 'package:Medschoolcoach/ui/section/section_screen.dart';
import 'package:Medschoolcoach/ui/settings/settings_screen.dart';
import 'package:Medschoolcoach/ui/topic/topic_screen.dart';

import 'package:Medschoolcoach/ui/videos/videos_screen.dart';
import 'package:Medschoolcoach/ui/videos/lecture_notes_screen.dart';
import 'package:Medschoolcoach/ui/videos/whiteboard_notes_screen.dart';
import 'package:Medschoolcoach/ui/welcome_screen/welcome_screen.dart';
import 'package:Medschoolcoach/utils/navigation/fade_route.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class Routes {
  static const String welcome = "welcome";
  static const String login = "login";
  static const String register = "register";
  static const String forgotPassword = "forgot";
  static const String home = "home";
  static const String schedule = "schedule";
  static const String more = "more";
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

  static Route<void> generateRoute(RouteSettings settings) {
    Crashlytics.instance.log("Open ${settings.name}");
    switch (settings.name) {
      case welcome:
        return MaterialPageRoute<void>(
          builder: (_) => WelcomeScreen(),
        );
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => LoginScreen(),
        );
      case register:
        return MaterialPageRoute<void>(
          builder: (_) => RegisterScreen(),
        );
      case forgotPassword:
        return MaterialPageRoute<void>(
          builder: (_) => ForgotPasswordScreen(),
        );
      case home:
        return FadeRoute(
          page: HomeScreen(),
        );
      case schedule:
        return FadeRoute(
          page: ScheduleScreen(),
        );
      case more:
        return FadeRoute(
          page: MoreScreen(),
        );
      case search:
        return FadeRoute(
          page: SearchScreen(
            searchPhrase: settings.arguments,
          ),
        );
      case videos:
        return FadeRoute(
          page: VideosScreen(),
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
          page: QuestionBankScreen(),
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
          page: FlashCardsBankScreen(),
        );
      case bookmarks:
        return FadeRoute(
          page: BookmarksScreen(),
        );
      case referFriend:
        return FadeRoute(
          page: ReferFriendScreen(),
        );
      case contactSupport:
        return FadeRoute(
          page: FeedbackScreen(),
        );
      case goPremium:
        return FadeRoute(
          page: GoPremiumScreen(),
        );
      case profile:
        return FadeRoute(
          page: ProfileScreen(),
        );
      case userSettings:
        return FadeRoute(
          page: SettingsScreen(),
        );

      default:
        throw Exception("No route defined for \"${settings.name}\"");
    }
  }
}
