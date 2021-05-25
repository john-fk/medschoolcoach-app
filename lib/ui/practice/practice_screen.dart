import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/ui/empty_state/empty_state.dart';
import 'package:Medschoolcoach/ui/questions/multiple_choice_question_screen.dart';
import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
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

  //region subject button
  final double sbjMargin = 12;
  double sbjSeperator;
  double sbjContainer;
  int totalContainer;
  int count;
  double capsuleListHeight;
  double capsuleHeight;
  double capsuleWidth;
  double innerCircleHeight;
  //endregion

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();
  ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(Routes.practiceScreen, widget.source);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchFlashcardsAndQuestionsSections(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool didFailLoading() {
    var hasData = SuperStateful.of(context).questionsSections.length > 0 &&
        SuperStateful.of(context).flashcardsSections.length > 0;

    return !_loading && !hasData;
  }

  Future<void> _fetchFlashcardsAndQuestionsSections(
      {bool forceApiRequest = false}) async {
    var hasData = SuperStateful.of(context).questionsSections.length > 0 &&
        SuperStateful.of(context).flashcardsSections.length > 0;
    setState(() {
      _loading = hasData ? false : true;
    });

    if (hasData) {
      _createSection();
    }

    await SuperStateful.of(context).updateFlashcardsSectionsList(
      forceApiRequest: forceApiRequest,
    );

    await SuperStateful.of(context).updateQuestionsSectionsList(
      forceApiRequest: forceApiRequest,
    );

    setState(() {
      _loading = false;
    });

    _createSection();
  }

  void _createSection() {
    var flashcardsSection = SuperStateful.of(context).flashcardsSections;
    var questionsSection = SuperStateful.of(context).questionsSections;
    allSubjects.clear();
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
    if (_loading)
      return Center(
        child: ProgressBar(),
      );

    if (didFailLoading()) {
      return EmptyStateView(
          title: FlutterI18n.translate(context, "empty_state.title"),
          message: FlutterI18n.translate(context, "empty_state.message"),
          ctaText: FlutterI18n.translate(context, "empty_state.button"),
          image: Image.asset(Style.of(context).pngAsset.emptyState),
          onTap: () {
            _loading = true;
            _fetchFlashcardsAndQuestionsSections(forceApiRequest: true);
          });
    }

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
                  "${allSubjects.isNotEmpty ? allSubjects[selectedIndex]?.amountOfFlashcards ?? 0 : 0}"
                  " Flashcards",
              onPressed: () {
                _analyticsProvider.logEvent(AnalyticsConstants.tapPracticeFlashcards,
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
                  "${allSubjects.isNotEmpty ? allSubjects[selectedIndex]?.amountOfQuestions ?? 0 : 0}"
                  " Questions",
              onPressed: () {
                _analyticsProvider.logEvent(AnalyticsConstants.tapPracticeQuestions,
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
    sbjSeperator = isTablet(context) ? 15 : 10;
    count = allSubjects?.length ?? 0;
    capsuleListHeight = isTablet(context) ? 320.0 : 225.0;
    capsuleHeight = isTablet(context) ? 300 : 200;
    capsuleWidth = isTablet(context) ? 155 : 100;
    innerCircleHeight = isTablet(context) ?
                        capsuleHeight / 2.25 : capsuleHeight / 2.5;
    sbjContainer = capsuleWidth + sbjSeperator;
    totalContainer =( (MediaQuery.of(context).size.width - sbjMargin * 2)
                    / sbjContainer).floor();

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
    return Padding(
      padding: isTablet(context)
          ? const EdgeInsets.only(top: 10)
          : const EdgeInsets.all(0),
      child: SizedBox(
        height: capsuleListHeight,
        child: count == 0
            ? Container()
            : ListView.separated(
                padding:  EdgeInsets.only(top: 20,
                    bottom: isTablet(context) ? 10 : 20,
                    left: sbjMargin, right: sbjMargin),
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                shrinkWrap: true,
                itemBuilder: (ctx, index) => _buildCapsule(
                    capsuleHeight, capsuleWidth, innerCircleHeight, index),
                separatorBuilder: (ctx, index) => SizedBox(
                      width: sbjSeperator,
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
          //decide to scroll or not
          double position = _scrollController.position.pixels;
          int mostLeft = (position / sbjContainer).floor()+1;
          int mostRight = (mostLeft + totalContainer.floor()) - 1;
          bool scrollLeft =
            index+1 == mostLeft && sbjContainer * index.toDouble() < position;
          bool scrollRight = index+1 > mostRight;
          if ( scrollLeft || scrollRight && index!=allSubjects.length-1)
            _scrollController.animateTo(sbjSeperator + sbjContainer * index.toDouble(),
                duration: const Duration(seconds:1),curve: Curves.ease);
          else if (scrollRight && mostRight + totalContainer >= allSubjects.length)
            _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                duration: const Duration(seconds:1),curve: Curves.ease);

          setState(() {
            selectedIndex = index;
          });
          _analyticsProvider.logEvent(AnalyticsConstants.tapPracticeSubject,
              params: {"subject_name": allSubjects[selectedIndex].name});
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          decoration: BoxDecoration(
              color: index == selectedIndex ? Color(0xff009D7A) : Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(capsuleWidth),
              border: Border.all(
                  color: index == selectedIndex
                      ? Color(0xff009D7A)
                      : Colors.black.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: Offset(0, 1))
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
                Image(
                    color: Color(0xFFFFFFFF),
                    image: AssetImage(
                        Style.of(context).pngAsset.questionArrowNext),
                    height: smallResponsiveFont(context).fontSize * 0.8)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
