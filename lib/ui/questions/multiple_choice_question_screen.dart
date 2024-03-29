import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/questions_day_repository.dart';
import 'package:Medschoolcoach/repository/questions_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/questions/questions_summary_screen.dart';
import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:Medschoolcoach/widgets/app_bars/questions_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/question_button.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/modals/explanation_modal.dart';
import 'package:Medschoolcoach/widgets/progress_bar/button_progress_bar.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';

enum QuestionStatusType { newQuestions, incorrect, correct, flagged, qotd, all }

class MultipleChoiceQuestionScreenArguments {
  final String screenName;
  final String subjectId;
  final String videoId;
  final QuestionStatusType status;
  final String source;

  MultipleChoiceQuestionScreenArguments({
    this.screenName,
    this.subjectId,
    this.videoId,
    this.status,
    this.source,
  });
}

class Answer {
  final String text;
  final String optionLetter;
  final bool isCorrect;

  Answer({
    this.text,
    this.optionLetter,
    this.isCorrect = false,
  });
}

class MultipleChoiceQuestionScreen extends StatefulWidget {
  final MultipleChoiceQuestionScreenArguments arguments;

  const MultipleChoiceQuestionScreen({
    Key key,
    this.arguments,
  }) : super(key: key);

  @override
  _MultipleChoiceQuestionScreenState createState() =>
      _MultipleChoiceQuestionScreenState();
}

class _MultipleChoiceQuestionScreenState
    extends State<MultipleChoiceQuestionScreen> with TickerProviderStateMixin {
  final _questionsRepository =
      Injector.appInstance.getDependency<QuestionsRepository>();
  final _questionsDayRepository =
      Injector.appInstance.getDependency<QuestionsDayRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();
  final _listKey = GlobalKey<AnimatedListState>();
  final _animationDuration = Duration(
    milliseconds: 200,
  );

  int correctAnswers = 0;
  int wrongAnswers = 0;
  final List<String> _answeredQuestionsIds = [];
  int _currentQuestionIndex = 0;
  int _previousQuestionIndex;
  List<Question> _questionsList = [];
  List<Answer> _answers = [];
  bool _loading = false;
  bool _favourite;
  int _selectedIndex;
  RepositoryResult<QuestionList> _error;
  RepositoryResult<QuestionList> _repoQuestion;
  bool _firstPressed = true;
  bool isQOTD = false;

  @override
  void initState() {
    super.initState();
    _logScreenViewAnalytics();
    _fetchQuestions(
      forceApiRequest: false,
    );
  }

  void _logScreenViewAnalytics() {
    if (!isQOTD) {
      Map<String, String> param;
      if (widget.arguments.subjectId == null) {
        param = {AnalyticsConstants.keyType: widget.arguments.screenName};
      } else {
        param = {
          AnalyticsConstants.keySubjectId: widget.arguments.subjectId,
          AnalyticsConstants.keySubjectName: widget.arguments.screenName
        };
      }
      _analyticsProvider.logScreenView(
          AnalyticsConstants.screenMultipleChoiceQuestion,
          widget.arguments.source,
          params: param);
    } else {
      _analyticsProvider.logScreenView(
          AnalyticsConstants.screenQuestionsOfTheDay, widget.arguments.source);
    }
  }

  @override
  Widget build(BuildContext context) {
    isQOTD = widget.arguments.status == QuestionStatusType.qotd;
    if ((_questionsList.length > 0) &&
        ((isQOTD && _currentQuestionIndex == 5) ||
            (!isQOTD && _currentQuestionIndex >= _questionsList.length)))
      return Container();
    final size = MediaQuery.of(context).size;
    bool shouldAdd = _answers.isEmpty;
    return Scaffold(
      backgroundColor: medstyles.Style.of(context).colors.accent,
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            child: SvgPicture.asset(
              medstyles.Style.of(context).svgAsset.questionsBackground,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              QuestionAppBar(
                  category: widget.arguments.screenName,
                  currentQuestion: _currentQuestionIndex + 1,
                  questionsSize: _questionsList.length,
                  questionId: _questionsList.isNotEmpty
                      ? _questionsList[_currentQuestionIndex].id
                      : "",
                  stem: _questionsList.isNotEmpty
                      ? _questionsList[_currentQuestionIndex].stem
                      : ""),
              Expanded(
                child: _loading
                    ? Center(
                        child: ButtonProgressBar(),
                      )
                    : _buildListViewContent(context, shouldAdd),
              ),
              Container(
                  color: Color.fromRGBO(12, 83, 199, 1),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      height: _selectedIndex != null
                          ? whenDevice(
                              context,
                              large: 168,
                              tablet: 230,
                            )
                          : 0,
                      child: Container(
                          margin: EdgeInsets.only(
                              top: whenDevice(
                            context,
                            large: 32,
                            tablet: 40,
                          )),
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      width: size.width,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          _drawBookmark(),
                                          SizedBox(
                                            width: 24,
                                          ),
                                          _drawExplanation()
                                        ],
                                      )),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  QuestionButton(
                                    text: _currentQuestionIndex !=
                                            _questionsList.length - 1
                                        ? FlutterI18n.translate(
                                            context,
                                            "question_screen.next_question",
                                          )
                                        : FlutterI18n.translate(
                                            context,
                                            "question_screen.summerize",
                                          ),
                                    onPressed: _currentQuestionIndex !=
                                            _questionsList.length - 1
                                        ? _goToNextQuestion
                                        : _goToSummarize,
                                    nextQuestion: true,
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  InkWell _drawBookmark() {
    final size = whenDevice(context, large: 25.0, tablet: 40.0);
    bool isBookmarked = _favourite != null ? _favourite : _getFavourite();
    return InkWell(
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: AnimatedSizeAndFade(
              vsync: this,
              fadeDuration: const Duration(milliseconds: 1000),
              child: Container(
                key: isBookmarked ? ValueKey("booked") : ValueKey("unbooked"),
                height: size,
                child: Image(
                    image: AssetImage("assets/png/bookmark_" +
                        (isBookmarked ? "1" : "0") +
                        ".png")),
              )),
        ),
        Text("Save",
            style: smallerResponsiveFont(context,
                fontColor: FontColor.White, opacity: 0.5))
      ]),
      onTap: _onTap,
    );
  }

  InkWell _drawExplanation() {
    final size = whenDevice(context, large: 25.0, tablet: 40.0);
    return InkWell(
      child: Column(children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Image(
              image: AssetImage(
                  medstyles.Style.of(context).pngAsset.questionExplanation),
              height: size,
              fit: BoxFit.fitHeight),
        ),
        Text("Explanation",
            style: smallerResponsiveFont(context,
                fontColor: FontColor.White, opacity: 0.5))
      ]),
      onTap: () {
        _logQuestionEvent(AnalyticsConstants.tapViewExplanation);
        openExplanationModal(
          context: context,
          fitHeight: false,
          title: FlutterI18n.translate(context, "question_screen.explanation"),
          content:
              explanation(_questionsList[_currentQuestionIndex].explanation),
        );
      },
    );
  }

  Future<void> _onTap() async {
    bool initialValue = _favourite;

    setState(() {
      _favourite = !_favourite;
    });

    RepositoryResult response;
    if (initialValue) {
      response = await _questionsRepository.deleteFavouriteQuestion(
        questionId: _questionsList[_currentQuestionIndex].id,
      );
    } else {
      response = await _questionsRepository.addFavouriteQuestion(
          questionId: _questionsList[_currentQuestionIndex].id);
    }

    if (response is RepositoryErrorResult) {
      setState(() {
        _favourite = initialValue;
      });
    }

    _analyticsProvider.logEvent(
        initialValue
            ? AnalyticsConstants.tapQuestionBookmarkRemove
            : AnalyticsConstants.tapQuestionBookmarkAdd,
        params: {
          AnalyticsConstants.keyType: widget.arguments.screenName,
          AnalyticsConstants.keyQuestionId:
              _questionsList[_currentQuestionIndex].id,
          AnalyticsConstants.keyStem: _questionsList[_currentQuestionIndex].stem
        });
  }

  Widget explanation(String explanationText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Html(data: explanationText, style: {
                "html": Style.fromTextStyle(
                  normalResponsiveFont(context, fontColor: FontColor.Content2),
                )
              })
            ]))
      ],
    );
  }

  void _logQuestionEvent(String event) {
    if (_questionsList != null &&
        _questionsList[_currentQuestionIndex] != null) {
      _analyticsProvider.logEvent(event, params: {
        "question_id": _questionsList[_currentQuestionIndex].id,
        "stem": _questionsList[_currentQuestionIndex].stem
      });
    }
  }

  bool _getFavourite() {
    if (widget.arguments.status != null &&
        widget.arguments.status == QuestionStatusType.flagged) {
      _favourite = true;
      return true;
    }
    if (_questionsList.isNotEmpty &&
        _questionsList[_currentQuestionIndex].favorite != null) {
      _favourite = _questionsList[_currentQuestionIndex].favorite;
      return _questionsList[_currentQuestionIndex].favorite;
    }

    _favourite = false;
    return false;
  }

  Widget _buildListViewContent(BuildContext context, bool shouldAdd) {
    final width = MediaQuery.of(context).size.width;
    return _error != null
        ? RefreshingEmptyState(
            repositoryResult: _error,
            refreshFunction: () => _fetchQuestions(
              forceApiRequest: true,
            ),
          )
        : _questionsList.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                            child: Html(
                                data:
                                    _questionsList[_currentQuestionIndex].stem,
                                style: {
                                  "html":
                                      Style.fromTextStyle(biggerResponsiveFont(
                                    context,
                                    fontColor: FontColor.Content2,
                                    fontWeight: FontWeight.bold,
                                  ))
                                })),
                        AnimatedList(
                          key: _listKey,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (
                            context,
                            index,
                            animation,
                          ) {
                            Answer answer = Answer(
                              optionLetter: _getOptionLetter(index),
                              text: _getQuestionText(index),
                              isCorrect: _isCorrect(index),
                            );
                            if (index > 3 ||
                                (!shouldAdd && index + 1 > _answers.length))
                              return null;

                            if (shouldAdd) {
                              _answers.add(answer);
                            }

                            return _buildListItem(
                              _answers[index],
                              animation,
                              index,
                            );
                          },
                          initialItemCount: 4,
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 48.0),
                child: Center(
                  child: Text(
                    _getEmptyStateText(),
                    style: normalResponsiveFont(
                      context,
                      fontColor: FontColor.Content2,
                    ),
                  ),
                ),
              );
  }

  String _getEmptyStateText() {
    if (widget.arguments.subjectId != null) {
      return FlutterI18n.translate(
        context,
        "question_screen.no_questions_subject",
      );
    }
    if (widget.arguments.videoId != null) {
      return FlutterI18n.translate(
        context,
        "question_screen.no_questions_lesson",
      );
    }
    if (widget.arguments.status == QuestionStatusType.newQuestions) {
      return FlutterI18n.translate(
        context,
        "question_screen.no_new_questions",
      );
    }
    if (widget.arguments.status == QuestionStatusType.incorrect ||
        widget.arguments.status == QuestionStatusType.correct) {
      return FlutterI18n.translate(
        context,
        "question_screen.no_answers",
      );
    }
    if (widget.arguments.status == QuestionStatusType.flagged) {
      return FlutterI18n.translate(
        context,
        "question_screen.no_flagged_questions",
      );
    }
    return "";
  }

  Widget _buildListItem(
    Answer answer,
    Animation animation,
    int index,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: QuestionButton(
              key: Key("ans$index"),
              text: answer.text,
              optionLetter: answer.optionLetter,
              onPressed: () async {
                if (_selectedIndex == null) {
                  if (answer.isCorrect) {
                    correctAnswers = correctAnswers + 1;
                    SuperStateful.of(context).correctAnswers++;
                  } else {
                    wrongAnswers = wrongAnswers + 1;
                    SuperStateful.of(context).wrongAnswers++;
                  }

                  if (!isQOTD && _repoQuestion != null) {
                    //QB as general
                    (_repoQuestion as RepositorySuccessResult<QuestionList>)
                        .data
                        .correctAnswers = correctAnswers;
                    (_repoQuestion as RepositorySuccessResult<QuestionList>)
                        .data
                        .wrongAnswers = wrongAnswers;
                    //Current question answer
                    (_repoQuestion as RepositorySuccessResult<QuestionList>)
                        .data
                        .items[_currentQuestionIndex]
                        .yourAnswer = _getAnswer(index);
                  }

                  _showAnswers(index);
                }
              },
              showAnswer: _selectedIndex != null,
              isCorrect: answer.isCorrect,
              pressed: _getOptionLetter(_selectedIndex)),
        ),
      ),
    );
  }

  void _updateState(Function updateFunction) {
    if (this.mounted) {
      setState(() {
        updateFunction();
      });
    } else {}
  }

  void _showAnswers(int index) {
    _updateState(() {
      _previousQuestionIndex = _currentQuestionIndex;
      _selectedIndex = index;
      _firstPressed = true;
    });

    _questionsRepository.sendQuestionAnswer(
      questionId: _questionsList[_currentQuestionIndex].id,
      answer: _getAnswer(index),
    );

    _logShowAnswersEvent(index);

    _answeredQuestionsIds.add(_questionsList[_currentQuestionIndex].id);

    if (isQOTD)
      SuperStateful.of(context)
          .answeredQuestionsIds
          .add(_questionsList[_currentQuestionIndex].id);
    else if (_repoQuestion != null) {
      (_repoQuestion as RepositorySuccessResult<QuestionList>)
          .data
          .answeredQuestionsIds = _answeredQuestionsIds;
      (_repoQuestion as RepositorySuccessResult<QuestionList>).data.position =
          _currentQuestionIndex + 1;
    }

    if (widget.arguments.status == QuestionStatusType.qotd) {
      setState(() {
        SuperStateful.of(context).currentQOTDIndex = _currentQuestionIndex + 1;
      });
    }
    _previousQuestionIndex = _currentQuestionIndex;
  }

  void _logShowAnswersEvent(int index) {
    _analyticsProvider.logEvent(AnalyticsConstants.tapQuestionAnswer, params: {
      "stem": _questionsList[_currentQuestionIndex].stem,
      "id": _questionsList[_currentQuestionIndex].id,
      "user_answer": _getAnswer(index),
      "correct_answer": _questionsList[_currentQuestionIndex].answer
    });
  }

  void _goToNextQuestion() {
    if (!_firstPressed) return;
    _firstPressed = false;

    if (_answers.length == 1) {
      for (int i = 1; i < 4; i++) {
        _addListItem(i);
      }
    } else {
      for (int i = 2; i < 4; i++) {
        _addListItem(i);
      }
    }

    _updateState(() {
      _currentQuestionIndex = _currentQuestionIndex + 1;
      _selectedIndex = null;
      _answers = [];
      _favourite = null;
    });

    _logQuestionEvent(AnalyticsConstants.tapNextQuestion);
  }

  void _addListItem(int index) {
    _listKey.currentState.insertItem(
      index,
      duration: _animationDuration,
    );
  }

  void _goToSummarize() {
    if (isQOTD) {
      setState(() {
        _questionsDayRepository.clearCache();
        SuperStateful.of(context).currentQOTDIndex = 0;
      });
    } else {
      _questionsRepository.clearCacheKey(
          subjectId: widget.arguments.subjectId,
          videoId: widget.arguments.videoId,
          status: widget.arguments.status ?? QuestionStatusType.all);
    }
    Navigator.pushReplacementNamed(
      context,
      Routes.questionsSummary,
      arguments: QuestionSummaryScreenArguments(
          screenName: widget.arguments.screenName,
          subjectId: widget.arguments.subjectId,
          videoId: widget.arguments.videoId,
          answeredQuestionsIds: _answeredQuestionsIds,
          correctAnswers: isQOTD
              ? SuperStateful.of(context).correctAnswers
              : correctAnswers,
          wrongAnswers:
              isQOTD ? SuperStateful.of(context).wrongAnswers : wrongAnswers),
    );
    _logQuestionEvent(AnalyticsConstants.tapSummarize);
  }

  Future<void> _fetchQuestions({
    bool forceApiRequest = false,
  }) async {
    _updateState(() {
      _loading = true;
    });
    _previousQuestionIndex = -1;
    switch (widget.arguments.status) {
      case QuestionStatusType.flagged:
        await _fetchFavouriteQuestions();
        break;
      case QuestionStatusType.qotd:
        await _fetchQOTD();
        break;
      default:
        await _fetchNormalQuestions(forceApiRequest);
    }
  }

  Future _fetchQOTD() async {
    final result = await _questionsDayRepository.fetchQuestionOfTheDay();

    if (result is RepositorySuccessResult<List<Question>>) {
      SuperStateful.of(context).questionsOfTheDay = result.data;
    }

    _questionsList = SuperStateful.of(context).questionsOfTheDay;
    _currentQuestionIndex = SuperStateful.of(context).currentQOTDIndex;
    _answeredQuestionsIds.clear();
    if (_currentQuestionIndex == 0) {
      SuperStateful.of(context).answeredQuestionsIds.clear();
      SuperStateful.of(context).correctAnswers = 0;
      SuperStateful.of(context).wrongAnswers = 0;
    }
    _answeredQuestionsIds
        .addAll(SuperStateful.of(context).answeredQuestionsIds);
    _loading = false;
    if (SuperStateful.of(context).currentQOTDIndex == 5)
      return _goToSummarize();
    else
      _updateState(() {});
  }

  Future _fetchFavouriteQuestions() async {
    final result = await _questionsRepository.fetchFavouriteQuestions();

    if (result is RepositorySuccessResult<QuestionList>) {
      _updateState(() {
        _questionsList = result.data.items
          ..sort(
            (a, b) => a.order.compareTo(b.order),
          );

        _loading = false;
      });
    } else {
      _loading = false;
      _error = result;
    }
  }

  Future _fetchNormalQuestions(bool forceApiRequest) async {
    final result = await _questionsRepository.fetchQuestions(
        subjectId: widget.arguments.subjectId,
        videoId: widget.arguments.videoId,
        forceApiRequest:
            widget.arguments.status == null ? forceApiRequest : true,
        status: widget.arguments.status ?? QuestionStatusType.all);

    if (result is RepositorySuccessResult<QuestionList>) {
      _repoQuestion = result;

      _updateState(() {
        if (result.data.position == 0) {
          _questionsList = result.data.items
            ..sort(
              (a, b) => a.order.compareTo(b.order),
            );

          if (widget.arguments.status != null) {
            _filterQuestionsByStatus();
          }
          if (widget.arguments.subjectId != null) {
            if (!_questionsList.any((question) => question.isCorrect == null)) {
              //if there's a question but all answered, then shuffle
              _questionsList.shuffle();
            } else {
              _questionsList = _questionsList
                  .where((question) => question.isCorrect == null)
                  .toList();
            }
          }
          result.data.items = _questionsList;
        } else {
          //if proceeding, we need to grab current progress
          correctAnswers = result.data.correctAnswers;
          wrongAnswers = result.data.wrongAnswers;
          _answeredQuestionsIds.addAll(result.data.answeredQuestionsIds);
          _currentQuestionIndex = result.data.position;
          _questionsList = result.data.items;
        }

        _loading = false;
        if (_questionsList.length > 0 &&
            _currentQuestionIndex >= _questionsList.length) _goToSummarize();
      });
    } else {
      _error = result;
      _loading = false;
    }
  }

  void _filterQuestionsByStatus() {
    switch (widget.arguments.status) {
      case QuestionStatusType.newQuestions:
        _questionsList = _questionsList
            .where((question) => question.isCorrect == null)
            .toList();
        break;
      case QuestionStatusType.incorrect:
        _questionsList = _questionsList
            .where((question) => question.isCorrect == 0)
            .toList();
        break;
      case QuestionStatusType.correct:
        _questionsList = _questionsList
            .where((question) => question.isCorrect == 1)
            .toList();
        break;
      case QuestionStatusType.flagged:
      case QuestionStatusType.qotd:
      case QuestionStatusType.all:
        break;
    }
  }

  bool _isCorrect(int index) {
    return index == 0 && _questionsList[_currentQuestionIndex].answer == "A" ||
        index == 1 && _questionsList[_currentQuestionIndex].answer == "B" ||
        index == 2 && _questionsList[_currentQuestionIndex].answer == "C" ||
        index == 3 && _questionsList[_currentQuestionIndex].answer == "D";
  }

  String _getOptionLetter(int index) {
    switch (index) {
      case 0:
        return "A.";
      case 1:
        return "B.";
      case 2:
        return "C.";
      case 3:
        return "D.";
      default:
        return "";
    }
  }

  String _getQuestionText(int index) {
    switch (index) {
      case 0:
        return _questionsList[_currentQuestionIndex].choiceA;
      case 1:
        return _questionsList[_currentQuestionIndex].choiceB;
      case 2:
        return _questionsList[_currentQuestionIndex].choiceC;
      case 3:
        return _questionsList[_currentQuestionIndex].choiceD;
      default:
        return "";
    }
  }

  String _getAnswer(int index) {
    switch (index) {
      case 0:
        return "A";
      case 1:
        return "B";
      case 2:
        return "C";
      case 3:
        return "D";
      default:
        return "";
    }
  }
}
