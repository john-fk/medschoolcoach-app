import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/section/subject_title_widget.dart';
import 'package:Medschoolcoach/ui/topic/topic_screen.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/search_screen_template/search_screen_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class SectionScreenData {
  final String sectionId;
  final String sectionName;
  final int numberOfCourses;
  final String source;

  SectionScreenData({
    @required this.sectionId,
    @required this.sectionName,
    @required this.numberOfCourses,
    @required this.source,
  });
}

class SectionScreen extends StatefulWidget {
  final SectionScreenData sectionScreenData;

  const SectionScreen(this.sectionScreenData);

  @override
  _SectionScreenState createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  bool _loading = true;
  bool _fetchError = false;
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenLessonCategoriesSections,
        widget.sectionScreenData.source,
        params: {
          AnalyticsConstants.keySection: widget.sectionScreenData.sectionName
        });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchData(
        forceApiRequest: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchScreenTemplate(
      templateData: SearchScreenTemplateData(
        appBarTitle: widget.sectionScreenData.sectionName,
        appBarSubTitle: _appBarSubtitle(),
        content: _getContent(context),
        loading: _loading,
      ),
    );
  }

  String _appBarSubtitle() {
    if (widget.sectionScreenData.numberOfCourses == null ||
        widget.sectionScreenData.numberOfCourses < 1) return "";
    return FlutterI18n.translate(
      context,
      "app_bar.section_subtitle",
      {
        "number": widget.sectionScreenData.numberOfCourses.toString(),
      },
    );
  }

  Widget _getContent(BuildContext context) {
    final section =
        SuperStateful.of(context).sections[widget.sectionScreenData.sectionId];

    if (_loading) return Container();
    if (_fetchError || section?.subjects == null)
      return RefreshingEmptyState(
        refreshFunction: () => _fetchData(
          forceApiRequest: true,
        ),
      );
    return _buildSubjectsList();
  }

  Widget _buildSubjectsList() {
    final section =
        SuperStateful.of(context).sections[widget.sectionScreenData.sectionId];
    return RefreshIndicator(
      onRefresh: () => _fetchData(
        forceApiRequest: true,
      ),
      child: ListView.builder(
        key: const Key("section_scroll"),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: whenDevice(context, large: 45, tablet: 60),
        ),
        itemCount: section.subjects.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final subject = section.subjects[index];
          return SubjectTitleWidget(
            subject: subject,
            goToTopic: _goToTopic,
            initiallyExpanded: section.subjects.length == 1,
          );
        },
      ),
    );
  }

  void _goToTopic(BuildContext context, Topic topic) {
    Navigator.of(context).pushNamed(
      Routes.topic,
      arguments: TopicScreenData(
        topicId: topic.id,
        topicName: topic.name,
      ),
    );
  }

  Future<void> _fetchData({
    bool forceApiRequest = false,
  }) async {
    setState(() {
      _loading = true;
      _fetchError = false;
    });

    final result = await SuperStateful.of(context).updateSection(
      widget.sectionScreenData.sectionId,
      forceApiRequest: forceApiRequest,
    );

    if (result is RepositoryErrorResult) _fetchError = true;

    setState(() {
      _loading = false;
    });
  }
}
