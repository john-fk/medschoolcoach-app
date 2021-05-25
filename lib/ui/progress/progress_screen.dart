import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/empty_state/empty_state.dart';
import 'package:Medschoolcoach/ui/flash_cards_bank/flash_cards_bank_screen.dart';
import 'package:Medschoolcoach/ui/questions/question_bank_screen.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/question_bank_progress.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/cards/course_progress_card.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progress_card_wrapper/progress_card_wrapper.dart';
import 'package:Medschoolcoach/widgets/upsell_banner/upsell_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  ApiServices apiServices;
  Future<QuestionBankProgress> getQuestionBankProgress;
  String selectedQuestionBankSubject = 'All';
  String selectedFlashcardSubject = 'All';
  GlobalKey<CourseProgressCardState> _courseProgressKey =
      GlobalKey<CourseProgressCardState>();
  GlobalKey<ProgressCardWrapperState> _flashcardKey =
      GlobalKey<ProgressCardWrapperState>();
  GlobalKey<ProgressCardWrapperState> _questionbankKey =
      GlobalKey<ProgressCardWrapperState>();

  bool showScheduleButton = false;

  void _reload() {
    _fetchCourseProgress();
    _fetchFlashcardProgress();
    _fetchQuestionBankProgress();
  }

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(Routes.progressScreen, "navigation_bar");
    apiServices = Injector.appInstance.getDependency<ApiServices>();
  }

  Future<void> _fetchCourseProgress() async {
    if (frontStack()) {
      await _courseProgressKey.currentState.update();
    }
  }

  bool frontStack() {
    return ModalRoute.of(context).isCurrent;
  }

  Future<void> _fetchFlashcardProgress() async {
    await _flashcardKey.currentState.update(flashcard: true);
  }

  Future<void> _fetchQuestionBankProgress() async {
    await _questionbankKey.currentState.update(flashcard: false);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(child: _buildBody()),
      backgroundColor: Style.of(context).colors.background2,
      bottomNavigationBar: NavigationBar(
        page: NavigationPage.Progress,
      ),
      appBar: AppBar(
        title: Text(
          "Progress",
          style: greatResponsiveFont(context, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        titleSpacing: 12,
        automaticallyImplyLeading: false,
      ),
    );
  }

  bool hasFailedLoading() {
    return (_courseProgressKey.currentState != null &&
            !_courseProgressKey.currentState.showLoading &&
            _courseProgressKey.currentState.scheduleProgress == null) &&
        (_flashcardKey.currentState != null &&
            !_flashcardKey.currentState.showLoading &&
            _flashcardKey.currentState.flashCardProgress == null) &&
        (_questionbankKey.currentState != null &&
            !_questionbankKey.currentState.showLoading &&
            _questionbankKey.currentState.questionBankProgress == null);
  }

  Widget _buildBody() {
    if (hasFailedLoading()) {
      return _emptyStateView();
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: whenDevice(context, large: 8, medium: 4, small: 4)),
      child:
      Column(
        children:[
          UpsellBanner(),
          Expanded(
          child:
          SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                _label("progress_screen.course_progress"),
                SizedBox(
                  height: 20,
                ),
                _buildCourseProgressCard(),
                SizedBox(
                  height: 20,
                ),
                if (showScheduleButton)
                  PrimaryButton(
                    text: FlutterI18n.translate(
                        context, "progress_screen.view_schedule"),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.schedule,
                          arguments: Routes.progressScreen);
                    },
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  ),
                SizedBox(
                  height: 20,
                ),
                _label("progress_screen.practice"),
                SizedBox(
                  height: 20,
                ),
                _buildFlashcardsCard(),
                SizedBox(
                  height: 15,
                ),
                _buildQuestionBankProgressCard(),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        )),
      ])
    );
  }

  Widget _emptyStateView() {
    return EmptyStateView(
        title: FlutterI18n.translate(context, "empty_state.title"),
        message: FlutterI18n.translate(context, "empty_state.message"),
        ctaText: FlutterI18n.translate(context, "empty_state.button"),
        image: Image.asset(Style.of(context).pngAsset.emptyState),
        onTap: () {
          _reload();
        });
  }

  Widget _buildCourseProgressCard() {
    return CourseProgressCard(
        key: _courseProgressKey,
        onRefresh: () {
          _fetchCourseProgress();
        });
  }

  Widget _buildFlashcardsCard() {
    return ProgressCardWrapper(
        key: _flashcardKey,
        title: "progress_screen.flashcards",
        footerLinkText: "progress_screen.goto_flashcards",
        onTapAction: routeToFlashcards,
        isFlashCard: true,
        onTapFooter: () async {
          routeToFlashcards();
        },
        onSubjectChange: (subject) {
          updateSubject(subject, false);
        });
  }

  Widget _buildQuestionBankProgressCard() {
      return ProgressCardWrapper(
        key: _questionbankKey,
        selectedSubject: selectedQuestionBankSubject,
        title: "progress_screen.question_bank",
        isFlashCard: false,
        footerLinkText: "progress_screen.goto_question_bank",
        onTapAction: routeToQuestionBank,
        onTapFooter: () async {
          routeToQuestionBank();
        },
        onSubjectChange: (subject) {
          updateSubject(subject, true);
        });
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: Text(
        FlutterI18n.translate(context, text),
        style: bigResponsiveFont(context, fontWeight: FontWeight.w700),
      ),
    );
  }

  void updateSubject(Subject subject, bool isQB) {
    _analyticsProvider.logEvent(
        isQB ? "filter_question_subject" : "filter_flashcard_subject",
        params: {"subject_name": subject.name});

    if (isQB)
      _questionbankKey.currentState.selectedSubject = subject.name;
    else
      _flashcardKey.currentState.selectedSubject = subject.name;
  }

  void routeToFlashcards() {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
              builder: (_) => FlashCardsBankScreen(Routes.progressScreen)),
        )
        .then((_) => _reload());
  }

  void routeToQuestionBank() {
    Navigator.of(context)
        .push(
          MaterialPageRoute<void>(
              builder: (_) => QuestionBankScreen(Routes.progressScreen)),
        )
        .then((_) => _reload());
  }
}
