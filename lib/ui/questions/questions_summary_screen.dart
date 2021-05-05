import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/answers_summary.dart';
import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/app_bars/questions_app_bar.dart';
import 'package:Medschoolcoach/widgets/list_cells/answer_list_cell.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:injector/injector.dart';
import 'package:pie_chart/pie_chart.dart';

class QuestionSummaryScreenArguments {
  final String screenName;
  final String subjectId;
  final String videoId;
  final List<String> answeredQuestionsIds;
  final int correctAnswers;
  final int wrongAnswers;

  QuestionSummaryScreenArguments({
    this.screenName,
    this.subjectId,
    this.videoId,
    this.answeredQuestionsIds,
    this.correctAnswers,
    this.wrongAnswers,
  });
}

class QuestionSummaryScreen extends StatefulWidget {
  final QuestionSummaryScreenArguments arguments;

  const QuestionSummaryScreen({
    Key key,
    this.arguments,
  }) : super(key: key);

  @override
  _QuestionSummaryScreenState createState() => _QuestionSummaryScreenState();
}

class _QuestionSummaryScreenState extends State<QuestionSummaryScreen> {
  final _apiServices = Injector.appInstance.getDependency<ApiServices>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  bool _loading = true;
  List<Question> _questions;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(AnalyticsConstants.screenQuestionSummary,
        AnalyticsConstants.screenMultipleChoiceQuestion,
        params: {
          AnalyticsConstants.keyCorrectAnswers:
              widget.arguments.correctAnswers.toString(),
          AnalyticsConstants.keyWrongAnswers:
              widget.arguments.wrongAnswers.toString()
        });
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                summary: true,
                questionsSize: widget.arguments.correctAnswers +
                    widget.arguments.wrongAnswers,
                currentQuestion: widget.arguments.correctAnswers,
                category: widget.arguments.screenName,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _buildChart(context),
                      _loading ? ProgressBar() : Container(),
                      _questions != null && _questions.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10.0,
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _questions.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        AnswerListCell(
                                  question: _questions[index],
                                  index: index,
                                ),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    color: Colors.white.withOpacity(0.2),
                                  );
                                },
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Center _buildChart(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 60.0,
          vertical: 16.0,
        ),
        child: PieChart(
          dataMap: Map<String, double>.unmodifiable(
            <String, double>{
              "Correct answers: " + widget.arguments.correctAnswers.toString():
                  widget.arguments.correctAnswers.toDouble(),
              "Incorrect answers: " + widget.arguments.wrongAnswers.toString():
                  widget.arguments.wrongAnswers.toDouble()
            },
          ),
          chartValueStyle: normalResponsiveFont(
            context,
            fontColor: FontColor.Content2,
            fontWeight: FontWeight.w500,
          ),
          legendStyle: biggerResponsiveFont(
            context,
            fontColor: FontColor.Content2,
            fontWeight: FontWeight.w500,
          ).copyWith(height: 1.5),
          legendPosition: LegendPosition.top,
          chartLegendSpacing: 24,
          colorList: [
            Style.of(context).colors.accent2,
            Style.of(context).colors.questions
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    var response = await _apiServices.getAnswersSummary();

    if (response is SuccessResponse<AnswersSummary>) {
      /*if (widget.arguments.subjectId != null) {
        _questions = response.body.questions
            .where(
                (question) => question.subjectId == widget.arguments.subjectId)
            .toList();
      }
      if (widget.arguments.videoId != null) {
        _questions = response.body.questions
            .where((question) => question.videoId == widget.arguments.videoId)
            .toList();
      }*/

      _questions = response.body.questions
          .where(
            (question) =>
                widget.arguments.answeredQuestionsIds.contains(question.id),
          )
          .toList();

      _questions
        ..sort(
          (a, b) => a.order.compareTo(b.order),
        );
    }

    setState(() {
      _loading = false;
    });
  }
}
