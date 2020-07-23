import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

import '../custom_video_controller.dart';

class VideoSeekWidget extends StatefulWidget {
  static double seekCircleSize1 = 125;
  static double seekCircleSize2 = 100;
  static double seekTimePaddingValue = 15;

  final bool forward;
  final CustomVideoController customController;
  final VoidCallback showVideoPlayerMenu;

  const VideoSeekWidget({
    Key key,
    @required this.forward,
    @required this.customController,
    @required this.showVideoPlayerMenu,
  }) : super(key: key);

  @override
  _VideoSeekWidgetState createState() => _VideoSeekWidgetState();
}

class _VideoSeekWidgetState extends State<VideoSeekWidget>
    with SingleTickerProviderStateMixin {
  static const int animationDuration = 200;

  Animation<double> _animation;
  AnimationController _animationController;

  double _fontSize = 15;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: animationDuration));

    _animation = Tween<double>(begin: 1, end: 0.1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addListener(() {
        if (_animationController.status == AnimationStatus.completed)
          _animationController.reverse();
      });
  }

  @override
  Widget build(BuildContext context) {
    if (isPortrait(context)) {
      VideoSeekWidget.seekCircleSize1 =
          whenDevice(context, large: 94, small: 70, tablet: 150);
      VideoSeekWidget.seekCircleSize2 =
          whenDevice(context, large: 75, small: 56, tablet: 120);
      VideoSeekWidget.seekTimePaddingValue =
          whenDevice(context, large: 4, small: 2, tablet: 6);
      _fontSize = whenDevice(context, large: 12, tablet: 19);
    } else {
      VideoSeekWidget.seekCircleSize1 =
          whenDevice(context, large: 125, tablet: 200);
      VideoSeekWidget.seekCircleSize2 =
          whenDevice(context, large: 100, tablet: 160);
      VideoSeekWidget.seekTimePaddingValue = 15;
      _fontSize = whenDevice(context, large: 15, tablet: 24);
    }

    if (widget.forward) return _seekForwardWidget(context);
    return _seekBackwardsWidget(context);
  }

  Widget _seekBackwardsWidget(BuildContext context) {
    return GestureDetector(
      onTap: _seekVideo(forward: false),
      child: Stack(
        children: <Widget>[
          Container(
            width: VideoSeekWidget.seekCircleSize1 / 2,
            height: VideoSeekWidget.seekCircleSize1,
          ),
          Positioned(
            left: -VideoSeekWidget.seekCircleSize1 / 2,
            child: Container(
              width: VideoSeekWidget.seekCircleSize1,
              height: VideoSeekWidget.seekCircleSize1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Style.of(context).colors.brightShadow,
              ),
            ),
          ),
          Positioned(
            top: (VideoSeekWidget.seekCircleSize1 -
                    VideoSeekWidget.seekCircleSize2) /
                2,
            left: -VideoSeekWidget.seekCircleSize2 / 2,
            child: Container(
              width: VideoSeekWidget.seekCircleSize2,
              height: VideoSeekWidget.seekCircleSize2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Style.of(context).colors.brightShadow,
              ),
            ),
          ),
          Positioned(
            left: VideoSeekWidget.seekTimePaddingValue,
            top: VideoSeekWidget.seekCircleSize1 / 2 - 8,
            child: Opacity(
              opacity: _animation.value,
              child: Text(
                "-${CustomVideoController.seekTimeValue}",
                style: Style.of(context)
                    .font
                    .medium2
                    .copyWith(fontSize: _fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _seekForwardWidget(BuildContext context) {
    return GestureDetector(
      onTap: _seekVideo(forward: true),
      child: Stack(
        children: <Widget>[
          Container(
            width: VideoSeekWidget.seekCircleSize1 / 2,
            height: VideoSeekWidget.seekCircleSize1,
          ),
          Positioned(
            right: -VideoSeekWidget.seekCircleSize1 / 2,
            child: Container(
              width: VideoSeekWidget.seekCircleSize1,
              height: VideoSeekWidget.seekCircleSize1,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Style.of(context).colors.brightShadow,
              ),
            ),
          ),
          Positioned(
            top: (VideoSeekWidget.seekCircleSize1 -
                    VideoSeekWidget.seekCircleSize2) /
                2,
            right: -VideoSeekWidget.seekCircleSize2 / 2,
            child: Container(
              width: VideoSeekWidget.seekCircleSize2,
              height: VideoSeekWidget.seekCircleSize2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Style.of(context).colors.brightShadow,
              ),
            ),
          ),
          Positioned(
            right: VideoSeekWidget.seekTimePaddingValue,
            top: VideoSeekWidget.seekCircleSize1 / 2 - 8,
            child: Opacity(
              opacity: _animation.value,
              child: Text(
                "+${CustomVideoController.seekTimeValue}",
                style: Style.of(context).font.medium2.copyWith(
                      fontSize: _fontSize,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback _seekVideo({@required bool forward}) {
    return () async {
      widget.showVideoPlayerMenu();
      if (_animationController.status != AnimationStatus.dismissed) return;
      _animationController.forward();
      await widget.customController.seekVideo(forward: forward);
    };
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
