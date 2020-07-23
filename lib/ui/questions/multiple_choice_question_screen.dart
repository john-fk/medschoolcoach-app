import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/repository/questions_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/questions/questions_summary_screen.dart';
import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/app_bars/questions_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/question_button.dart';
import 'package:Medschoolcoach/widgets/buttons/white_border_button.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/modals/explanation_modal.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/button_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';
import 'package:native_mixpanel/native_mixpanel.dart';

enum QuestionStatusType {
  newQuestions,
  incorrect,
  correct,
  flagged,
}

class MultipleChoiceQuestionScreenArguments {
  final String screenName;
  final String subjectId;
  final String videoId;
  final QuestionStatusType status;

  MultipleChoiceQuestionScreenArguments({
    this.screenName,
    this.subjectId,
    this.videoId,
    this.status,
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
    extends State<MultipleChoiceQuestionScreen> {
  final _questionsRepository =
      Injector.appInstance.getDependency<QuestionsRepository>();
  final Mixpanel _mixPanel = Injector.appInstance.getDependency<Mixpanel>();

  final _listKey = GlobalKey<AnimatedListState>();
  final _animationDuration = Duration(
    milliseconds: 200,
  );

  int correctAnswers = 0;
  int wrongAnswers = 0;
  final List<String> _answeredQuestionsIds = [];
  int _currentQuestionIndex = 0;
  List<Question> _questionsList = [];
  List<Answer> _answers = [];
  bool _loading = false;
  bool _favourite;
  int _selectedIndex;
  RepositoryResult<QuestionList> _error;

  @override
  void initState() {
    super.initState();
    _fetchQuestions(
      forceApiRequest: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool shouldAdd = _answers.isEmpty;
    return Scaffold(
      backgroundColor: Style.of(context).colors.accent,
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            height: size.height,
            child: SvgPicture.asset(
              Style.of(context).svgAsset.questionsBackground,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: <Widget>[
              QuestionAppBar(
                title: FlutterI18n.translate(
                  context,
                  "question_screen.title",
                ),
                subTitle: widget.arguments.screenName,
                currentQuestion: _currentQuestionIndex + 1,
                questionsSize: _questionsList.length,
                questionId: _questionsList.isNotEmpty
                    ? _questionsList[_currentQuestionIndex].id
                    : "",
                isBookmarked: _favourite != null ? _favourite : _getFavourite(),
                onBookmarkTap: () {
                  _favourite = !_favourite;
                },
              ),
              Expanded(
                child: _loading
                    ? Center(
                        child: ButtonProgressBar(),
                      )
                    : _buildListViewContent(context, shouldAdd),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 1,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        QuestionButton(
                          text:
                              _currentQuestionIndex != _questionsList.length - 1
                                  ? FlutterI18n.translate(
                                      context,
                                      "question_screen.next_question",
                                    )
                                  : FlutterI18n.translate(
                                      context,
                                      "question_screen.summerize",
                                    ),
                          onPressed:
                              _currentQuestionIndex != _questionsList.length - 1
                                  ? _goToNextQuestion
                                  : _goToSummarize,
                          nextQuestion: true,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        WhiteBorderButton(
                          text: FlutterI18n.translate(
                            context,
                            "question_screen.view_explanation",
                          ),
                          onPressed: () {
                            openExplanationModal(
                              context: context,
                              explanationText:
                                  _questionsList[_currentQuestionIndex]
                                      .explanation,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                          ),
                          child: Html(
                            useRichText: false,
                            data: _questionsList[_currentQuestionIndex].stem,
                            defaultTextStyle: biggerResponsiveFont(
                              context,
                              fontColor: FontColor.Content2,
                              fontWeight: FontWeight.bold,
                            ),
                            customTextAlign: (_) => TextAlign.center,
                          ),
                        ),
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
                } else {
                  wrongAnswers = wrongAnswers + 1;
                }
                _showAnswers(index);
              }
            },
            showAnswer: _selectedIndex != null,
            isCorrect: answer.isCorrect,
          ),
        ),
      ),
    );
  }

  void _showAnswers(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _questionsRepository.sendQuestionAnswer(
      questionId: _questionsList[_currentQuestionIndex].id,
      answer: _getAnswer(index),
    );

    _logMixPanelEvent(index);

    _answeredQuestionsIds.add(_questionsList[_currentQuestionIndex].id);
    int answersLength = _answers.length - 1;
    for (int i = answersLength; i >= 0; i--) {
      if (!_answers[i].isCorrect && index != i) {
        Answer removedItem = _answers.removeAt(i);
        builder(
          BuildContext context,
          Animation animation,
        ) {
          return _buildListItem(
            removedItem,
            animation,
            i,
          );
        }

        _listKey.currentState.removeItem(
          i,
          builder,
          duration: _animationDuration,
        );
      }
    }
  }

  void _logMixPanelEvent(int index) {
    _mixPanel.track(Config.mixPanelQuestionAnsweredEvent, {
      "stem": _questionsList[_currentQuestionIndex].stem,
      "id": _questionsList[_currentQuestionIndex].id,
      "user_answer": _getAnswer(index),
      "correct_answer": _questionsList[_currentQuestionIndex].answer
    });
  }

  void _goToNextQuestion() {
    if (_answers.length == 1) {
      for (int i = 1; i < 4; i++) {
        _addListItem(i);
      }
    } else {
      for (int i = 2; i < 4; i++) {
        _addListItem(i);
      }
    }
    setState(() {
      _currentQuestionIndex = _currentQuestionIndex + 1;
      _selectedIndex = null;
      _answers = [];
      _favourite = null;
    });
  }

  void _addListItem(int index) {
    _listKey.currentState.insertItem(
      index,
      duration: _animationDuration,
    );
  }

  void _goToSummarize() {
    Navigator.pushReplacementNamed(
      context,
      Routes.questionsSummary,
      arguments: QuestionSummaryScreenArguments(
        screenName: widget.arguments.screenName,
        subjectId: widget.arguments.subjectId,
        videoId: widget.arguments.videoId,
        answeredQuestionsIds: _answeredQuestionsIds,
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
      ),
    );
  }

  Future<void> _fetchQuestions({
    bool forceApiRequest = false,
  }) async {
    setState(() {
      _loading = true;
    });
    if (widget.arguments.status != null &&
        widget.arguments.status == QuestionStatusType.flagged) {
      await _fetchFavouriteQuestions();
    } else {
      await _fetchNormalQuestions(forceApiRequest);
    }
  }

  Future _fetchFavouriteQuestions() async {
    final result = await _questionsRepository.fetchFavouriteQuestions();

    if (result is RepositorySuccessResult<QuestionList>) {
      setState(() {
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
      forceApiRequest: forceApiRequest,
    );

    if (result is RepositorySuccessResult<QuestionList>) {
      setState(() {
        _questionsList = result.data.items
          ..sort(
            (a, b) => a.order.compareTo(b.order),
          );

        if (widget.arguments.status != null) {
          _filterQuestionsByStatus();
        }
        if (widget.arguments.subjectId != null) {
          _questionsList = _questionsList
              .where((question) => question.isCorrect == null)
              .toList();
        }

        _loading = false;
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
