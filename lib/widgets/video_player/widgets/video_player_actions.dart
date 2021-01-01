import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/change_video_widget.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/reconnect_widget.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/video_player_connection_indicator.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/video_seek_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

import '../custom_video_controller.dart';

class VideoPlayerActions extends StatelessWidget {
  static double playPauseCircleSize = 80;
  static double changeVideoCircleSize = 50;
  static double descriptionHeight = 40;
  static double descriptionWidth = 65;

  final CustomVideoController customController;
  final VoidCallback showVideoPlayerMenu;
  final VoidCallback minimizeVideo;

  const VideoPlayerActions({
    Key key,
    @required this.customController,
    @required this.showVideoPlayerMenu,
    @required this.minimizeVideo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isPortrait(context)) {
      playPauseCircleSize = whenDevice(context, large: 60, tablet: 100);
      changeVideoCircleSize = whenDevice(context, large: 37.5, tablet: 60);
    } else {
      playPauseCircleSize = whenDevice(context, large: 80, tablet: 128);
      changeVideoCircleSize = whenDevice(context, large: 50, tablet: 80);
    }

    if (!customController.commercial)
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          VideoSeekWidget(
            key: const Key("seek backwards"),
            customController: customController,
            forward: false,
            showVideoPlayerMenu: showVideoPlayerMenu,
          ),
          Row(
            children: <Widget>[
              _buildLeftWidget(context),
              SizedBox(
                width: changeVideoCircleSize / 2,
              ),
              _getCenterWidget(context),
              SizedBox(width: changeVideoCircleSize / 2),
              _buildRightWidget(context),
            ],
          ),
          VideoSeekWidget(
            key: const Key("seek forward"),
            customController: customController,
            forward: true,
            showVideoPlayerMenu: showVideoPlayerMenu,
          ),
        ],
      );

    final middleWidgetsPadding = EdgeInsets.all(
        (VideoSeekWidget.seekCircleSize1 -
                VideoPlayerActions.playPauseCircleSize) /
            2);
    if (customController.isVideoLoading())
      return Center(
        child: Container(
          padding: middleWidgetsPadding ?? EdgeInsets.zero,
          width: VideoSeekWidget.seekCircleSize1,
          height: VideoSeekWidget.seekCircleSize1,
          child: VideoPlayerConnectionIndicator(),
        ),
      );
    if (!customController.videoPlayerController.value.initialized)
      return Container(
        padding: middleWidgetsPadding ?? EdgeInsets.zero,
        child: ReconnectWidget(
          onTap: customController.reconnect,
        ),
      );

    return Container(
      width: VideoSeekWidget.seekCircleSize1,
      height: VideoSeekWidget.seekCircleSize1,
    );
  }

  Widget _getCenterWidget(BuildContext context) {
    if (customController.isVideoLoading())
      return VideoPlayerConnectionIndicator();
    if (!customController.videoPlayerController.value.initialized)
      return ReconnectWidget(
        onTap: () {
          showVideoPlayerMenu();
          customController.reconnect();
        },
      );
    if (customController.isVideoFinished()) return _playAgainWidget(context);
    return _playPauseWidget(context);
  }

  Widget _playPauseWidget(BuildContext context) {
    bool isPlaying = customController.isVideoPlaying();
    String iconAsset = Style.of(context).svgAsset.playVideo;
    if (isPlaying) iconAsset = Style.of(context).svgAsset.pauseVideo;
    return GestureDetector(
      onTap: () {
        showVideoPlayerMenu();
        if (isPlaying)
          customController.pause();
        else
          customController.play();
      },
      child: Container(
        width: playPauseCircleSize,
        height: playPauseCircleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Style.of(context).colors.brightShadow,
        ),
        child: Container(
          margin: EdgeInsets.all(playPauseCircleSize / 5),
          padding: isPlaying
              ? const EdgeInsets.all(0)
              : EdgeInsets.only(left: playPauseCircleSize / 7),
          child: SvgPicture.asset(
            iconAsset,
          ),
        ),
      ),
    );
  }

  Widget _buildRightWidget(BuildContext context) {
    if (!isAnotherVideo(forward: true, context: context))
      return Container(
        width: changeVideoCircleSize,
      );

    if (customController.isVideoFinished()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: descriptionHeight,
          ),
          ChangeVideoWidget(
            forward: true,
            size: changeVideoCircleSize,
            onTap: () {
              showVideoPlayerMenu();
              _goToAnotherVideoScreen(forward: true, context: context);
            },
          ),
          SizedBox(
            height: descriptionHeight,
            child: Text(
              FlutterI18n.translate(context, "video_screen.next"),
              style: normalResponsiveFont(
                context,
                fontColor: FontColor.Content2,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      );
    }

    return Container(
      width: descriptionWidth,
      alignment: Alignment.center,
      child: ChangeVideoWidget(
        forward: true,
        size: changeVideoCircleSize,
        onTap: () {
          showVideoPlayerMenu();
          _goToAnotherVideoScreen(forward: true, context: context);
        },
      ),
    );
  }

  Widget _buildLeftWidget(BuildContext context) {
    if (customController.isVideoFinished() && !isPortrait(context))
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: descriptionHeight,
            ),
            GestureDetector(
              onTap: minimizeVideo,
              child: Container(
                width: changeVideoCircleSize,
                height: changeVideoCircleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Style.of(context).colors.brightShadow,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    Style.of(context).svgAsset.minimizeVideo,
                    width: changeVideoCircleSize * 0.8,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: descriptionHeight,
              child: Text(
                FlutterI18n.translate(context, "video_screen.minimize"),
                style: normalResponsiveFont(
                  context,
                  fontColor: FontColor.Content2,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      );

    if (!isAnotherVideo(forward: false, context: context))
      return Container(
        width: changeVideoCircleSize,
      );
    return Container(
      width: descriptionWidth,
      alignment: Alignment.center,
      child: ChangeVideoWidget(
          forward: false,
          size: changeVideoCircleSize,
          onTap: () {
            showVideoPlayerMenu();
            _goToAnotherVideoScreen(forward: false, context: context);
          }),
    );
  }

  void _goToAnotherVideoScreen({
    @required bool forward,
    @required BuildContext context,
  }) {
    _updateProgress(context);
    final order = forward
        ? customController.lessonScreenArguments.order + 1
        : customController.lessonScreenArguments.order + -1;
    Navigator.pushReplacementNamed(
      context,
      Routes.lesson,
      arguments: LessonVideoScreenArguments(
        videos: customController.lessonScreenArguments.videos,
        order: order,
        topicId: customController.lessonScreenArguments.videos == null
            ? customController.lessonScreenArguments.topicId
            : customController.lessonScreenArguments.videos[order].topicId,
        topicName: customController.lessonScreenArguments.topicName,
        fullScreenVideo: customController.lessonScreenArguments.fullScreenVideo,
        source: AnalyticsConstants.screenVideoPlayer
      ),
    );
  }

  void _updateProgress(BuildContext context) {
    SuperStateful.of(context).updateTopic(
        customController.lessonScreenArguments.topicId,
        forceApiRequest: true);
    SuperStateful.of(context).updateSectionsList(forceApiRequest: true);
    SuperStateful.of(context).updateRecentlyWatchedVideo();
    SuperStateful.of(context).updateRecentSearchResult();
    SuperStateful.of(context).updateSchedule(forceApiRequest: true);
    SuperStateful.of(context).updateTodaySchedule(forceApiRequest: true);
    SuperStateful.of(context).updateScheduleProgress();
    SuperStateful.of(context).updateBookmarks(forceApiRequest: true);
  }

  bool isAnotherVideo({
    @required bool forward,
    @required BuildContext context,
  }) {
    if (isPortrait(context)) return false;
    if (forward)
      return customController.lessonScreenArguments.videos == null
          ? customController.topicVideosCount >
              customController.lessonScreenArguments.order + 1
          : customController.lessonScreenArguments.videos.length >
              customController.lessonScreenArguments.order + 1;
    return customController.lessonScreenArguments.order > 0;
  }

  Widget _playAgainWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showVideoPlayerMenu();
        await customController.videoPlayerController.seekTo(Duration.zero);
        customController.play();
      },
      child: Container(
        width: playPauseCircleSize,
        height: playPauseCircleSize,
        child: SvgPicture.asset(
          Style.of(context).svgAsset.reconnectVideo,
        ),
      ),
    );
  }
}
