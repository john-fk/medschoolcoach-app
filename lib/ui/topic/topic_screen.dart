import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/ui/slidable_cell/slidable_cell.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/utils/toasts.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/schedule_list_cell.dart';
import 'package:Medschoolcoach/widgets/search_screen_template/search_screen_template.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class TopicScreenData {
  final String topicId;
  final String topicName;

  TopicScreenData({
    @required this.topicId,
    @required this.topicName,
  });
}

class TopicScreen extends StatefulWidget {
  final TopicScreenData _topicScreenData;

  const TopicScreen(this._topicScreenData);

  @override
  _TopicScreenState createState() => _TopicScreenState();
}

class _TopicScreenState extends State<TopicScreen> {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  RepositoryResult<Topic> _topicResult;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loginScreenViewAnalytics();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchTopic(
        forceApiRequest: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchScreenTemplate(
      templateData: SearchScreenTemplateData(
        appBarTitle: widget._topicScreenData.topicName,
        appBarSubTitle: _getProgress(),
        topicId: widget._topicScreenData.topicId,
        content: _getContent(context),
        loading: _loading,
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    if (_loading) return Container();
    if (_topicResult is RepositorySuccessResult<Topic>) {
      return RefreshIndicator(
        onRefresh: () => _fetchTopic(
          forceApiRequest: true,
        ),
        child: _buildListView(),
      );
    } else {
      return RefreshingEmptyState(
        repositoryResult: _topicResult,
        refreshFunction: () => _fetchTopic(
          forceApiRequest: true,
        ),
      );
    }
  }

  String _getProgress() {
    final topic =
        SuperStateful.of(context).topics[widget._topicScreenData.topicId];
    if (topic == null || topic.percentage == null) return "";
    return FlutterI18n.translate(
      context,
      "app_bar.topic_subtitle",
      {
        "number": topic.percentage.toString(),
      },
    );
  }

  void _loginScreenViewAnalytics() {
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenTopics, AnalyticsConstants.screenSection,
        params: {
          AnalyticsConstants.keyTopicId: widget._topicScreenData.topicId,
          AnalyticsConstants.keyTopicName: widget._topicScreenData.topicName
        });
  }

  Padding _buildListView() {
    final topic =
        SuperStateful.of(context).topics[widget._topicScreenData.topicId];

    List<Video> videos = topic.videos
      ..sort(
        (a, b) => a.order.compareTo(b.order),
      );
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: whenDevice(
          context,
          large: 15,
          tablet: 30,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: videos.length,
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Style.of(context).colors.separator,
        ),
        itemBuilder: (context, index) => SlidableCell(
          video: videos[index],
          successCallback: ({bool watched}) async {
            SuperStateful.of(context).updateTopic(
              widget._topicScreenData.topicId,
              forceApiRequest: true,
            );
            SuperStateful.of(context)
                .updateSection(videos[index].sectionId, forceApiRequest: true);
            SuperStateful.of(context)
                .updateTodaySchedule(forceApiRequest: true);
            SuperStateful.of(context).updateSectionsList(forceApiRequest: true);
            if (watched)
              showWatchedToast(context);
            else
              showUnwatchedToast(context);
          },
          child: ScheduleListCell(
            index: index + 1,
            cellData: ScheduleListCellData(
              imagePath: videos[index].image,
              videoId: videos[index].id,
              lessonName: videos[index].name,
              percentages: videos[index].progress != null
                  ? videos[index].progress.percentage ?? 0
                  : 0,
              totalLength: videos[index].length,
              bookmarked: videos[index].favourite ?? false,
              topicId: videos[index].topicId,
            ),
            onTap: () => _goToLessonScreen(index),
              onBookmarkTap: () {
                //TODO: Do we need to update the screen here? ScheduleListCell invoke this when bookmark changed.
              }),
        ),
      ),
    );
  }

  void _goToLessonScreen(int index) {
    _analyticsProvider.logEvent(AnalyticsConstants.tapLesson, params: {
      AnalyticsConstants.keySource:
          AnalyticsConstants.screenTopics,
      AnalyticsConstants.keyTopicId: widget._topicScreenData.topicId,
      AnalyticsConstants.keyTopicName: widget._topicScreenData.topicName
    });
    Navigator.pushNamed(
      context,
      Routes.lesson,
      arguments: LessonVideoScreenArguments(
        order: index,
        topicId: widget._topicScreenData.topicId,
        topicName: widget._topicScreenData.topicName,
        source: AnalyticsConstants.screenTopics
      ),
    );
  }

  Future<void> _fetchTopic({
    bool forceApiRequest = false,
  }) async {
    setState(() {
      _loading = true;
    });
    final result = await SuperStateful.of(context).updateTopic(
      widget._topicScreenData.topicId,
      forceApiRequest: forceApiRequest,
    );

    setState(() {
      _loading = false;
      _topicResult = result;
    });
  }
}
