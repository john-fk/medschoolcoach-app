import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/ui/questions/multiple_choice_question_screen.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injector/injector.dart';

class PracticeScreen extends StatefulWidget {
  final String source;

  const PracticeScreen({Key key, this.source}) : super(key: key);

  @override
  _PracticeScreenState createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<Subject> allSubjects = [];
  int selectedIndex = 0;
  bool _loading = false;
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(Routes.practiceScreen, widget.source);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchFlashcardsAndQuestionsSections(),
    );
  }

  Future<void> _fetchFlashcardsAndQuestionsSections(
      {bool forceApiRequest = false}) async {
    var hasData = SuperStateful.of(context).questionsSections.length > 0 &&
        SuperStateful.of(context).flashcardsSections.length > 0;
    setState(() {
      _loading = hasData ? false : true;
    });

    await SuperStateful.of(context).updateFlashcardsSectionsList(
      forceApiRequest: forceApiRequest,
    );

    await SuperStateful.of(context).updateQuestionsSectionsList(
      forceApiRequest: forceApiRequest,
    );

    setState(() {
      _loading = false;
    });
    var flashcardsSection = SuperStateful.of(context).flashcardsSections;
    var questionsSection = SuperStateful.of(context).questionsSections;
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

    questionsSection.where((section) => section.amountOfQuestions != 0).forEach(
          (section) => section.subjects
              .where((subject) => subject.amountOfQuestions != 0)
              .forEach(
            (subject) {
              allSubjects
                  .where((element) => element.name == subject.name)
                  .first
                  .amountOfQuestions = subject.amountOfQuestions;
            },
          ),
        );
  }

  Widget _buildContent() {
    final flashcardSections = SuperStateful.of(context).flashcardsSections;
    final questionSection = SuperStateful.of(context).questionsSections;
    if (_loading)
      return Center(
        child: ProgressBar(),
      );
    if (flashcardSections.isEmpty)
      return RefreshingEmptyState(
        refreshFunction: () =>
            _fetchFlashcardsAndQuestionsSections(forceApiRequest: true),
      );
    if (questionSection.isEmpty)
      return RefreshingEmptyState(
          refreshFunction: () =>
              _fetchFlashcardsAndQuestionsSections(forceApiRequest: true));
    return RefreshIndicator(
      onRefresh: () =>
          _fetchFlashcardsAndQuestionsSections(forceApiRequest: true),
      child: Column(
        children: [
          _buildSubjectsList(),
          SizedBox(
            height: 30,
          ),
          _buildCardButton(
              color: Style.of(context).colors.accent,
              label:
                  "${allSubjects.isNotEmpty ?
                  allSubjects[selectedIndex]?.amountOfFlashcards ?? 0 : 0}"
                  " Flashcards",
              onPressed: () {
                _analyticsProvider.logEvent("tap_practice_flashcards",
                    params: {"subject_name": allSubjects[selectedIndex].name});
                Navigator.pushNamed(context, Routes.flashCard,
                    arguments: FlashcardsStackArguments(
                        subjectId: allSubjects[selectedIndex].id,
                        subjectName: allSubjects[selectedIndex].name,
                        source: AnalyticsConstants.practiceScreen));
              }),
          SizedBox(
            height: 20,
          ),
          _buildCardButton(
              color: Style.of(context).colors.questions,
              label:
                  "${allSubjects.isNotEmpty ?
                  allSubjects[selectedIndex]?.amountOfQuestions ?? 0 : 0}"
                  " Questions",
              onPressed: () {
                _analyticsProvider.logEvent("tap_practice_questions",
                    params: {"subject_name": allSubjects[selectedIndex].name});
                Navigator.of(context).pushNamed(
                  Routes.multipleChoiceQuestion,
                  arguments: MultipleChoiceQuestionScreenArguments(
                      screenName: allSubjects[selectedIndex].name,
                      subjectId: allSubjects[selectedIndex].id,
                      source: AnalyticsConstants.practiceScreen),
                );
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var horizontalInset =
        whenDevice(context, large: 4.0, medium: 0.0, small: 0.0);
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          page: NavigationPage.Practice,
        ),
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: horizontalInset),
            child: Text(
              "Practice",
              style: greatResponsiveFont(context, fontWeight: FontWeight.w700),
            ),
          ),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          titleSpacing: 12,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalInset * 2),
          child: _buildContent(),
        ));
  }

  Widget _buildSubjectsList() {
    final int count = allSubjects?.length ?? 0;
    final capsuleListHeight = isTablet(context) ? 265.0 : 225.0;
    final double capsuleHeight = isTablet(context) ? 252 : 180;
    final double capsuleWidth = isTablet(context) ? 130 : 90;
    final double innerCircleHeight =
        isTablet(context) ? capsuleHeight / 2.25 : capsuleHeight / 2.35;

    return Padding(
      padding: isTablet(context)
          ? const EdgeInsets.only(top: 10)
          : const EdgeInsets.all(0),
      child: SizedBox(
        height: capsuleListHeight,
        child: count == 0
            ? Container()
            : ListView.separated(
                padding: isTablet(context)
                    ? EdgeInsets.only(top: 20, bottom: 10, left: 12, right: 12)
                    : EdgeInsets.only(top: 20, bottom: 35, left: 12, right: 12),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (ctx, index) => _buildCapsule(
                    capsuleHeight, capsuleWidth, innerCircleHeight, index),
                separatorBuilder: (ctx, index) => SizedBox(
                      width: isTablet(context) ? 15 : 10,
                    ),
                itemCount: allSubjects?.length ?? 0),
      ),
    );
  }

  Widget _buildCapsule(double capsuleHeight, double capsuleWidth,
      double innerCircleHeight, int index) {
    return SizedBox(
      height: capsuleHeight,
      width: capsuleWidth,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          decoration: BoxDecoration(
              color: index == selectedIndex ? Color(0xff009D7A) : Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(capsuleWidth),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 50,
                    offset: Offset(0, 4))
              ]),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: Container(
                    height: innerCircleHeight,
                    width: innerCircleHeight,
                    margin: isTablet(context)
                        ? EdgeInsets.only(top: 7)
                        : EdgeInsets.only(top: 0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(innerCircleHeight)),
                      child: Center(
                        child: SvgPicture.asset(
                            "assets/svg/${allSubjects[index].name}.svg",
                            height: 40),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        allSubjects[index].name,
                        textAlign: TextAlign.center,
                        style: smallResponsiveFont(context,
                            fontWeight: FontWeight.w600,
                            fontColor: index == selectedIndex
                                ? FontColor.Content2
                                : FontColor.Content),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardButton({Color color, String label, VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Theme(
        data: ThemeData.dark(),
        child: RaisedButton(
          onPressed: onPressed,
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: smallResponsiveFont(context,
                        fontColor: FontColor.Content2,
                        fontWeight: FontWeight.w600)),
                Icon(Icons.arrow_forward_rounded)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
