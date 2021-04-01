import 'dart:async';

import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/ui/lesson/fullscren_video.dart';
import 'package:Medschoolcoach/utils/api/models/topic.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/video_player/custom_video_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart';
import 'package:wakelock/wakelock.dart';

import 'lesson_screen_widget.dart';

class LessonVideoScreenArguments {
  final String topicId;
  final String topicName;
  final List<Video> videos;
  final int order;
  final String source;
  bool fullScreenVideo;

  LessonVideoScreenArguments({
    @required this.order,
    @required this.topicId,
    @required this.source,
    this.fullScreenVideo = false,
    this.topicName,
    this.videos,
  });
}

class LessonVideoScreen extends StatefulWidget {
  final LessonVideoScreenArguments arguments;

  const LessonVideoScreen(
    this.arguments,
  );

  @override
  _LessonVideoScreenState createState() => _LessonVideoScreenState();
}

class _LessonVideoScreenState extends State<LessonVideoScreen> {
  CustomVideoController _customVideoController;
  bool _loading = true;
  bool _videoPlayerVisible = false;
  Video _video;
  Topic _topic;

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: widget.arguments.fullScreenVideo
            ? FullscreenVideo(
                customVideoController: _customVideoController,
                loading: _loading,
                closeFullscreenVideo: _closeFullscreenVideo,
              )
            : LessonScreenWidget(
                arguments: widget.arguments,
                loading: _loading,
                refresh: () => _fetchData(forceApiRequest: true),
                topic: _topic,
                video: _video,
                updateProgress: _updateProgress,
                customVideoController: _customVideoController,
                openFullscrenVideo: _openFullscreenVideo,
                makeVideoPlayerVisible: _makeVideoPlayerVisible,
                videoPlayerVisible: _videoPlayerVisible,
                analyticsProvider: _analyticsProvider
              ),
        // bottomNavigationBar: widget.arguments.fullScreenVideo
        //     ? null
        //     : NavigationBar(
        //         runOnTap: () => _customVideoController?.pause(),
        //       ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.arguments.fullScreenVideo) {
      _videoPlayerVisible = true;
      Wakelock.enable();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _makeVideoPlayerVisible() {
    setState(() {
      _videoPlayerVisible = true;
    });
    Wakelock.enable();
    _initializeVideo();
  }

  Future<void> _fetchData({bool forceApiRequest = false}) async {
    setState(() {
      _loading = true;
    });

    final result = await SuperStateful.of(context).updateTopic(
      widget.arguments.topicId,
      forceApiRequest: forceApiRequest,
    );

    if (result is RepositorySuccessResult) {
      _topic = (result as RepositorySuccessResult<Topic>).data;
      _video = _getVideoFromTopic(_topic);
    }
    _analyticsProvider.logEvent(AnalyticsConstants.screenLessonVideo,
        params: _analyticsProvider.getVideoParam(_video.id, _video.name,
            additionalParams: {
              AnalyticsConstants.keySource: widget.arguments.source
            }));
    if (widget.arguments.fullScreenVideo) _initializeVideo();

    setState(() {
      _loading = false;
    });
  }

  void _initializeVideo() {
    if (_topic == null || _video == null) return;

    _customVideoController = CustomVideoController(
      topicVideosCount: _topic.videos.length,
      lessonScreenArguments: widget.arguments,
      setState: _runSetState,
      video: _video,
    );
    setState(() {});
  }

  Video _getVideoFromTopic(Topic topic) {
    if (widget.arguments.videos == null)
      return topic?.videos
          ?.firstWhere((video) => video.order == widget.arguments.order);
    else {
      //adding this hack for now to overcome the not refreshing of the
      // topic after video favorite has been saved in schedule screen
      bool fav1 = widget.arguments.videos[widget.arguments.order].favourite;
      Video aVid = topic.videos.firstWhere((video) =>
      video.id == widget.arguments.videos[widget.arguments.order].id);
      aVid.favourite = fav1;
    }

    return topic.videos.firstWhere((video) =>
        video.id == widget.arguments.videos[widget.arguments.order].id);
  }

  void _runSetState() {
    setState(() {});
  }

  void _logAnalyticsFullScreenVideo(bool isFullScreen) {
    _analyticsProvider.logEvent(AnalyticsConstants.tapVideoFullScreen,
        params: _analyticsProvider.getVideoParam(_video.id, _video.name,
            additionalParams: {
              AnalyticsConstants.keyIsOn: isFullScreen.toString()
            }));
  }

  void _openFullscreenVideo() {
    if (widget.arguments.fullScreenVideo) return;
    setState(() {
      widget.arguments.fullScreenVideo = true;
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _logAnalyticsFullScreenVideo(true);
  }

  void _closeFullscreenVideo() {
    if (!widget.arguments.fullScreenVideo) return;
    setState(() {
      widget.arguments.fullScreenVideo = false;
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _logAnalyticsFullScreenVideo(false);
  }

  Future<bool> _onWillPop() async {
    if (widget.arguments.fullScreenVideo) {
      _closeFullscreenVideo();
      return false;
    }

    _updateProgress();
    return true;
  }

  void _updateProgress() {
    SuperStateful.of(context)
        .updateTopic(widget.arguments.topicId, forceApiRequest: true);
    SuperStateful.of(context).updateSectionsList(forceApiRequest: true);
    SuperStateful.of(context).updateRecentlyWatchedVideo();
    SuperStateful.of(context).updateRecentSearchResult();
    SuperStateful.of(context).updateSchedule(forceApiRequest: true);
    SuperStateful.of(context).updateTodaySchedule(forceApiRequest: true);
    SuperStateful.of(context).updateScheduleProgress();
    SuperStateful.of(context).updateBookmarks(forceApiRequest: true);
    if (_topic != null) {
      final sectionId = _topic?.videos[0]?.sectionId;
      if (sectionId != null) {
        SuperStateful.of(context)
            .updateSection(sectionId, forceApiRequest: true);
      }
    }
  }

  @override
  void dispose() {
    if (_customVideoController != null) _customVideoController.dispose();
    if (!widget.arguments.fullScreenVideo) Wakelock.disable();
    super.dispose();
  }
}
