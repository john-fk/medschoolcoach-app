import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/flash_cards_bank/wigets/flash_cards_subjects.dart';
import 'package:Medschoolcoach/ui/home/home_section.dart';
import 'package:Medschoolcoach/ui/questions/multiple_choice_question_screen.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/subject_cell.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class QuestionBankScreen extends StatefulWidget {
  final String source;

  const QuestionBankScreen(this.source);

  @override
  _QuestionBankScreenState createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  RepositoryResult _result;
  bool _loading = false;

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenQuestionBank, widget.source);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: NavigationBar(),
      body: Column(
        children: <Widget>[
          CustomAppBar(
            title: FlutterI18n.translate(
              context,
              "more_screen.questions",
            ),
          ),
          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_loading)
      return Center(
        child: ProgressBar(),
      );
    if (_result is RepositoryErrorResult)
      return RefreshingEmptyState(
        refreshFunction: () => _fetchData(
          forceApiRequest: true,
        ),
        repositoryResult: _result,
      );
    return RefreshIndicator(
      onRefresh: () => _fetchData(
        forceApiRequest: true,
      ),
      child: ListView(
        key: const Key("questions_scroll"),
        shrinkWrap: true,
        children: <Widget>[
          _buildReviewByStatus(context),
          _buildSubjects(context),
        ],
      ),
    );
  }

  Future<void> _fetchData({
    bool forceApiRequest = false,
  }) async {
    setState(() {
      _loading = true;
    });

    final result = await SuperStateful.of(context).updateQuestionsSectionsList(
      forceApiRequest: forceApiRequest,
    );

    setState(() {
      _loading = false;
      _result = result;
    });
  }

  Widget _buildSubjects(BuildContext context) {
    final sections = SuperStateful.of(context).questionsSections;
    final subjectsWithSettings = List<SubjectAndSetting>();
    sections.where((section) => section.amountOfNewQuestions != 0).forEach(
          (section) => section.subjects
              .where((subject) => subject.amountOfNewQuestions != 0)
              .forEach(
                (subject) => subjectsWithSettings.add(
                  SubjectAndSetting(
                    subject,
                    section.setting,
                  ),
                ),
              ),
        );
    subjectsWithSettings
      ..sort(
        (a, b) => a.subject.order.compareTo(b.subject.order),
      );

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: HomeSection(
        sectionTitle: FlutterI18n.translate(
          context,
          "question_screen.pick_subject",
        ),
        sectionWidget: GridView.count(
          padding: EdgeInsets.only(bottom: 20),
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: subjectsWithSettings
              .map(
                (subjectWithSettings) => SubjectCell(
                  subjectName: subjectWithSettings.subject.name,
                  setting: subjectWithSettings.setting,
                  itemsWithNumber: FlutterI18n.translate(
                    context,
                    "question_screen.questions_count",
                    {
                      "number": subjectWithSettings.subject.amountOfNewQuestions
                          .toString(),
                    },
                  ),
                  onTap: () => _goToMultipleQuestions(
                      context: context,
                      subjectId: subjectWithSettings.subject.id,
                      screenName: subjectWithSettings.subject.name),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Future<Object> _goToMultipleQuestions(
      {BuildContext context,
      String subjectId,
      String screenName,
      QuestionStatusType status}) {
    _logAnalytics(subjectId, screenName);
    return Navigator.of(context).pushNamed(
      Routes.multipleChoiceQuestion,
      arguments: MultipleChoiceQuestionScreenArguments(
          screenName: screenName,
          subjectId: subjectId,
          status: status,
          source: AnalyticsConstants.screenQuestionBank),
    );
  }

  void _logAnalytics(String subjectId, String screenName) {
    if (subjectId == null) {
      _analyticsProvider.logEvent(
          AnalyticsConstants.tapQuestionBankReviewByStatus,
          params: {AnalyticsConstants.keyType: screenName});
    } else {
      _analyticsProvider
          .logEvent(AnalyticsConstants.tapQuestionBankSubject, params: {
        AnalyticsConstants.keySubjectId: subjectId,
        AnalyticsConstants.keySubjectName: screenName
      });
    }
  }

  Padding _buildReviewByStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: HomeSection(
        sectionTitle: FlutterI18n.translate(
          context,
          "question_screen.review_by_status",
        ),
        sectionWidget: Column(
          children: <Widget>[
            PrimaryButton(
              onPressed: () => _goToMultipleQuestions(
                context: context,
                screenName: FlutterI18n.translate(
                  context,
                  "question_screen.new",
                ),
                status: QuestionStatusType.newQuestions,
              ),
              text: FlutterI18n.translate(
                context,
                "question_screen.new",
              ),
            ),
            const SizedBox(height: 15),
            PrimaryButton(
              onPressed: () => _goToMultipleQuestions(
                context: context,
                screenName: FlutterI18n.translate(
                  context,
                  "question_screen.correct",
                ),
                status: QuestionStatusType.correct,
              ),
              text: FlutterI18n.translate(
                context,
                "question_screen.correct",
              ),
            ),
            const SizedBox(height: 15),
            PrimaryButton(
              onPressed: () => _goToMultipleQuestions(
                context: context,
                screenName: FlutterI18n.translate(
                  context,
                  "question_screen.wrong",
                ),
                status: QuestionStatusType.incorrect,
              ),
              text: FlutterI18n.translate(
                context,
                "question_screen.wrong",
              ),
            ),
            const SizedBox(height: 15),
            PrimaryButton(
              onPressed: () => _goToMultipleQuestions(
                context: context,
                screenName: FlutterI18n.translate(
                  context,
                  "question_screen.flagged",
                ),
                status: QuestionStatusType.flagged,
              ),
              text: FlutterI18n.translate(
                context,
                "question_screen.flagged",
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
