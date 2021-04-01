import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/questions_repository.dart';
import 'package:Medschoolcoach/ui/questions/multiple_choice_question_screen.dart';
import 'package:Medschoolcoach/ui/questions/questions_summary_screen.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:Medschoolcoach/widgets/app_bars/questions_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/question_button.dart';
import 'package:Medschoolcoach/widgets/buttons/white_border_button.dart';
import 'package:Medschoolcoach/widgets/modals/explanation_modal.dart';
import 'package:Medschoolcoach/widgets/progress_bar/button_progress_bar.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';

class QuestionOfTheDay extends StatefulWidget {
  final String source;

  const QuestionOfTheDay({Key key, this.source}) : super(key: key);

  @override
  _QuestionOfTheDayState createState() =>
      _QuestionOfTheDayState();
}

class _QuestionOfTheDayState
    extends State<QuestionOfTheDay> {
  final _questionsRepository =
      Injector.appInstance.getDependency<QuestionsRepository>();
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
  List<Question> _questionsList = [];
  List<Answer> _answers = [];
  bool _loading = false;
  int _selectedIndex;
  ApiServices apiServices;

  @override
  void initState() {
    super.initState();
    _loading = true;
    apiServices = Injector.appInstance.getDependency<ApiServices>();
    apiServices
        .getQuestionOfTheDayQuestions(limit: 5, offset: 0)
        .then((value){
              _questionsList = value.items;
              setState(() {
              _loading =false;
              });
    });
  }

  @override
  Widget build(BuildContext context) {
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
          if(_questionsList.isNotEmpty)
          Column(
            children: <Widget>[
              QuestionAppBar(
                title: FlutterI18n.translate(
                  context,
                  "question_screen.title",
                ),
                subTitle: _questionsList[_currentQuestionIndex].section.name,
                currentQuestion: _currentQuestionIndex + 1,
                questionsSize: _questionsList.length,
                questionId: _questionsList.isNotEmpty
                    ? _questionsList[_currentQuestionIndex].id
                    : "",
                stem: _questionsList.isNotEmpty
                    ? _questionsList[_currentQuestionIndex].stem
                    : "",
                isBookmarked: false,
                showBookmark: false,
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
                            _logQuestionEvent(
                                AnalyticsConstants.tapViewExplanation);
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
          else
            Center(child: ProgressBar(isDark: true,),)
        ],
      ),
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


  Widget _buildListViewContent(BuildContext context, bool shouldAdd) {
    final width = MediaQuery.of(context).size.width;
    return  ListView(
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
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                              child: Html(
                                  data: _questionsList[_currentQuestionIndex]
                                      .stem,
                                  style: {
                                    "html": Style.fromTextStyle(
                                        biggerResponsiveFont(
                                      context,
                                      fontColor: FontColor.Content2,
                                      fontWeight: FontWeight.bold,
                                    ))
                                  })),
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
              );
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

    _logShowAnswersEvent(index);

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

  void _logShowAnswersEvent(int index) {
    _analyticsProvider.logEvent(AnalyticsConstants.tapQuestionAnswer, params: {
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
    Navigator.pushReplacementNamed(
      context,
      Routes.questionsSummary,
      arguments: QuestionSummaryScreenArguments(
        screenName: _questionsList[_currentQuestionIndex].section.name,
        subjectId: _questionsList[_currentQuestionIndex].subjectId,
        videoId: _questionsList[_currentQuestionIndex].videoId,
        answeredQuestionsIds: _answeredQuestionsIds,
        correctAnswers: correctAnswers,
        wrongAnswers: wrongAnswers,
      ),
    );
    _logQuestionEvent(AnalyticsConstants.tapSummarize);
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

