import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/ui/lesson/widgets/another_lesson_widget.dart';
import 'package:Medschoolcoach/ui/lesson/widgets/lesson_widget.dart';
import 'package:Medschoolcoach/ui/lesson/widgets/premium_user_cards.dart';
import 'package:Medschoolcoach/ui/lesson/widgets/regular_user_cards.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/video_player/custom_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LessonScreenWidget extends StatefulWidget {
  final bool loading;
  final Topic topic;
  final Video video;
  final LessonVideoScreenArguments arguments;
  final VoidCallback updateProgress;
  final VoidCallback refresh;
  final VoidCallback openFullscrenVideo;
  final CustomVideoController customVideoController;
  final bool videoPlayerVisible;
  final VoidCallback makeVideoPlayerVisible;

  const LessonScreenWidget({
    @required this.loading,
    @required this.topic,
    @required this.video,
    @required this.arguments,
    @required this.updateProgress,
    @required this.refresh,
    @required this.customVideoController,
    @required this.openFullscrenVideo,
    @required this.makeVideoPlayerVisible,
    @required this.videoPlayerVisible,
  });

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreenWidget> {
  static const sidePaddingValue = 20.0;
  static const paddingValue = 10.0;
  static const _accentHeightFactor = 0.5;

  final _appBarKey = GlobalKey<State>();
  double _appBarHeight = 100.0;

  final bool _isPremium = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAppBarHeight();
    });
  }

  void _getAppBarHeight() {
    _appBarHeight = _appBarKey.currentContext.size.height;
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth =
        MediaQuery.of(context).size.width - 2 * sidePaddingValue;

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              height: contentWidth * _accentHeightFactor + _appBarHeight,
              color: Style.of(context).colors.accent,
            ),
            Expanded(child: Container()),
          ],
        ),
        Column(
          children: <Widget>[
            CustomAppBar(
              key: _appBarKey,
              title: _getTopicName(),
              padding: EdgeInsets.symmetric(vertical: paddingValue),
              customPop: () {
                widget.updateProgress();
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: _screenContent()),
          ],
        ),
      ],
    );
  }

  String _getTopicName() {
    if (widget.arguments.topicName != null) return widget.arguments.topicName;
    if (widget.topic != null) return widget.topic.name;
    return "";
  }

  Widget _screenContent() {
    if (widget.loading) return _loadingContent();
    if (widget.topic == null || widget.video == null) return _errorContent();
    return _lessonContent();
  }

  Widget _errorContent() {
    return RefreshingEmptyState(
      refreshFunction: widget.refresh,
    );
  }

  Widget _loadingContent() {
    return Center(
      child: ProgressBar(),
    );
  }

  Widget _lessonContent() {
    final contentWidth =
        MediaQuery.of(context).size.width - 2 * sidePaddingValue;

    return SingleChildScrollView(
      key: const Key("lesson scroll"),
      child: Column(
        children: <Widget>[
          LessonWidget(
            video: widget.video,
            contentWidth: contentWidth,
            arguments: widget.arguments,
            customVideoController: widget.customVideoController,
            openFullscrenVideo: widget.openFullscrenVideo,
            makeVideoPlayerVisible: widget.makeVideoPlayerVisible,
            videoPlayerVisible: widget.videoPlayerVisible,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: sidePaddingValue,
              right: sidePaddingValue,
              top: sidePaddingValue,
            ),
            child: Row(
              mainAxisAlignment: _isPreviousLesson()
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: <Widget>[
                _previousLessonWidget(contentWidth),
                _nextLessonWidget(contentWidth, widget.topic),
              ],
            ),
          ),
          SizedBox(height: sidePaddingValue),
          _isPremium
              ? PremiumUserCards(
                  sidePaddingValue: sidePaddingValue,
                  video: widget.video,
                  pausePlayer: () => widget.customVideoController?.pause(),
                )
              : RegularUserCards(),
          SizedBox(
            height: MediaQuery.of(context).viewPadding.bottom + paddingValue,
          )
        ],
      ),
    );
  }

  bool _isNextLesson(Topic topic) {
    if (widget.arguments.videos == null)
      return topic.videos.length > widget.arguments.order + 1;
    return widget.arguments.videos.length > widget.arguments.order + 1;
  }

  bool _isPreviousLesson() {
    return widget.arguments.order > 0;
  }

  Widget _nextLessonWidget(double contentWidth, Topic topic) {
    if (!_isNextLesson(topic)) return Container();
    return AnotherLessonWidget(
      key: const Key("next lesson"),
      children: [
        Text(
          FlutterI18n.translate(
            context,
            "lesson_screen.next_lesson",
          ),
          style: smallResponsiveFont(context, fontColor: FontColor.Content2),
        ),
        SizedBox(
          width: whenDevice(context, small: 5, large: 10, tablet: 20),
        ),
        RotatedBox(
          quarterTurns: 2,
          child: SvgPicture.asset(
            Style.of(context).svgAsset.backArrowDark,
            color: Style.of(context).colors.content2,
            width: whenDevice(context, large: 20, small: 15, tablet: 40),
          ),
        ),
      ],
      contentWidth: contentWidth,
      onTap: () => _goToLessonScreen(forward: true),
    );
  }

  Widget _previousLessonWidget(double contentWidth) {
    if (!_isPreviousLesson()) return Container();
    return AnotherLessonWidget(
      key: const Key("previous lesson"),
      children: [
        SvgPicture.asset(
          Style.of(context).svgAsset.backArrowDark,
          color: Style.of(context).colors.content2,
          width: whenDevice(context, large: 20, small: 15, tablet: 40),
        ),
        SizedBox(
          width: whenDevice(context, small: 5, large: 10, tablet: 20),
        ),
        Text(
          FlutterI18n.translate(
            context,
            "lesson_screen.previous_lesson",
          ),
          style: smallResponsiveFont(context, fontColor: FontColor.Content2),
        ),
      ],
      contentWidth: contentWidth,
      onTap: () => _goToLessonScreen(forward: false),
    );
  }

  void _goToLessonScreen({@required bool forward}) {
    final order =
        forward ? widget.arguments.order + 1 : widget.arguments.order + -1;
    widget.updateProgress();
    if (widget.arguments.videos != null) {}
    Navigator.pushReplacementNamed(
      context,
      Routes.lesson,
      arguments: LessonVideoScreenArguments(
        order: order,
        fullScreenVideo: widget.arguments.fullScreenVideo,
        videos: widget.arguments.videos,
        topicId: widget.arguments.videos == null
            ? widget.arguments.topicId
            : widget.arguments.videos[order].topicId,
        topicName: widget.arguments.topicName,
      ),
    );
  }
}
