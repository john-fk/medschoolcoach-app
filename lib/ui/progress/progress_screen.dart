import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/empty_state/empty_state.dart';
import 'package:Medschoolcoach/ui/flash_cards_bank/flash_cards_bank_screen.dart';
import 'package:Medschoolcoach/ui/questions/question_bank_screen.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_progress.dart';
import 'package:Medschoolcoach/utils/api/models/question_bank_progress.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_stats.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/cards/course_progress_card.dart';
import 'package:Medschoolcoach/widgets/cards/no_progress_card.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/progress_card/progress_card.dart';
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

  bool showScheduleButton = false;
  List<Section> questionsSections;
  List<Section> flashcardsSection;
  List<Subject> allSubjects = [];

  //loaders
  bool _courseProgressLoading = true;
  bool _flashcardProgressLoading = true;
  bool _questionBankProgressLoading = true;

  void _reload() {
    _fetchSubjects();
    _fetchCourseProgress();
    _fetchFlashcardProgress();
    _fetchQuestionBankProgress();
  }

  Future<void> _fetchSubjects({bool forceApiRequest = false}) async {
    await SuperStateful.of(context).updateFlashcardsSectionsList(
      forceApiRequest: forceApiRequest,
    );
    resetSubjects();
    flashcardsSection = SuperStateful.of(context).flashcardsSections;
    allSubjects = [Subject()..name = "All"];
    flashcardsSection
        .where((section) => section.amountOfFlashcards != 0)
        .forEach(
          (section) => section.subjects
              .where((subject) => subject.amountOfFlashcards != 0)
              .forEach(
            (subject) {
              allSubjects.add(subject);
            },
          ),
        );
    setState(() {});
  }

  void resetSubjects() {
    if (allSubjects == null) return;
    if (allSubjects.length > 1) {
      allSubjects.clear();
    }
    allSubjects.add(Subject()..name = "All");
  }

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(Routes.progressScreen, "navigation_bar");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchSubjects();
      _fetchCourseProgress();
      _fetchFlashcardProgress();
      _fetchQuestionBankProgress();
    });
    apiServices = Injector.appInstance.getDependency<ApiServices>();
  }

  Future<void> _fetchCourseProgress() async {
    if (frontStack()) {
      var existingData = SuperStateful.of(context).courseProgress;
      setState(() {
        _courseProgressLoading = existingData == null ? true : false;
      });

      await SuperStateful.of(context)
          .updateCourseProgress(forceApiRequest: true);
      setState(() {
        _courseProgressLoading = false;
      });
    }
  }

  bool frontStack() {
    return ModalRoute.of(context).isCurrent;
  }

  Future<void> _fetchFlashcardProgress() async {
    var existingData = SuperStateful.of(context).flashcardProgress;
    setState(() {
      _flashcardProgressLoading = existingData == null ? true : false;
    });

    await SuperStateful.of(context)
        .updateFlashcardProgress(forceApiRequest: true);
    setState(() {
      _flashcardProgressLoading = false;
    });
  }

  Future<void> _fetchQuestionBankProgress() async {
    var existingData = SuperStateful.of(context).flashcardProgress;
    setState(() {
      _questionBankProgressLoading = existingData == null ? true : false;
    });

    await SuperStateful.of(context)
        .updateQuestionBankProgress(forceApiRequest: true);
    setState(() {
      _questionBankProgressLoading = false;
    });
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

  Widget _buildBody() {
    if (hasFailedLoading()) {
      return _emptyStateView();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: whenDevice(context, large: 8, medium: 4, small: 4)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              UpsellBanner(),
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
              // _buildQuestionBankCard(),
              _buildQuestionBankProgressCard(),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool hasFailedLoading() {
    ScheduleStats courseProgress = SuperStateful.of(context).courseProgress;
    FlashcardsProgress flashcardsProgress =
        SuperStateful.of(context).flashcardProgress;
    QuestionBankProgress questionBankProgress =
        SuperStateful.of(context).questionBankProgress;

    return (!_courseProgressLoading && courseProgress == null) &&
        (!_flashcardProgressLoading && flashcardsProgress == null) &&
        (!_questionBankProgressLoading && questionBankProgress == null);
  }

  Widget _emptyStateView() {
    return EmptyStateView(
        title: FlutterI18n.translate(context, "empty_state.title"),
        message: FlutterI18n.translate(context, "empty_state.message"),
        ctaText: FlutterI18n.translate(context, "empty_state.button"),
        image: Image.asset(Style.of(context).pngAsset.emptyState),
        onTap: () {
          _courseProgressLoading = true;
          _flashcardProgressLoading = true;
          _questionBankProgressLoading = true;
          _reload();
        });
  }

  Widget _buildCourseProgressCard() {
    ScheduleStats courseProgress = SuperStateful.of(context).courseProgress;
    if (frontStack() && (_courseProgressLoading || courseProgress == null)) {
      return Card(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.1),
          child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: whenDevice(
                context,
                medium: 100,
                large: 100,
                tablet: 150,
              )),
              child: Container(
                child: Center(
                  child: ProgressBar(),
                ),
              )));
    }
    return CourseProgressCard(
      onRefresh: () {
        _fetchCourseProgress();
      },
      scheduleProgress: courseProgress,
    );
  }

  Widget _loadingCard() {
    return Card(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: whenDevice(
              context,
              medium: 100,
              large: 100,
              tablet: 150,
            )),
            child: Container(
              child: Center(
                child: ProgressBar(),
              ),
            )));
  }

  Widget _buildFlashcardsCard() {
    if (_flashcardProgressLoading) return _loadingCard();

    return ProgressCardWrapper(
        selectedSubject: selectedFlashcardSubject,
        allSubjects: allSubjects,
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
    if (_questionBankProgressLoading) return _loadingCard();

    return ProgressCardWrapper(
        selectedSubject: selectedQuestionBankSubject,
        allSubjects: allSubjects,
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
        isQB ? "filter_flashcard_subject" : "filter_question_subject",
        params: {"subject_name": subject.name});

    if (isQB)
      selectedQuestionBankSubject = subject.name;
    else
      selectedFlashcardSubject = subject.name;
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
