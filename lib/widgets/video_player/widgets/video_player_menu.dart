import 'dart:async';

import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/video_player_actions.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/video_progress_bar_menu.dart';
import 'package:flutter/material.dart';
import 'package:srt_parser/srt_parser.dart';

import '../custom_video_controller.dart';

class VideoPlayerMenu extends StatefulWidget {
  final CustomVideoController customController;
  final VoidCallback minimizeVideo;

  const VideoPlayerMenu({
    Key key,
    @required this.minimizeVideo,
    @required this.customController,
  }) : super(key: key);

  @override
  _VideoPlayerMenuState createState() => _VideoPlayerMenuState();
}

class _VideoPlayerMenuState extends State<VideoPlayerMenu>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _animationController;
  Timer _closeMenuTimer;
  Timer _showMenuTimer;
  List<Subtitle> _subtitles;

  @override
  void initState() {
    super.initState();
    _subtitles = parseSrt(widget.customController.video.srt);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _showMenuTimer = Timer.periodic(
        const Duration(milliseconds: 1), (Timer t) => _showHideMenuListener());
  }

  void _showHideMenuListener() {
    if (widget.customController.commercial) {
      if (_animationController.status == AnimationStatus.dismissed)
        _animationController.forward();
      return;
    }
    if (_animationController.status == AnimationStatus.dismissed &&
        !widget.customController.isVideoPlaying())
      _animationController.forward();
    if (_animationController.status == AnimationStatus.completed &&
        (_closeMenuTimer == null || !_closeMenuTimer.isActive)) {
      _closeMenuTimer = Timer(const Duration(milliseconds: 2000), () {
        if (widget.customController.isVideoPlaying())
          _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: _showVideoPlayerMenu,
      child: Container(
        width: size.width,
        height: size.height,
        padding:
            !isPortrait(context) ? MediaQuery.of(context).viewPadding : null,
        child: _animation.value == 0
            ? Container(
                padding: EdgeInsets.only(
                  bottom: whenDevice(
                    context,
                    large: 20,
                    tablet: 30,
                  ),
                ),
                color: Colors.transparent,
                width: size.width,
                height: size.height,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: _buildSubtitleCell(context, size.width),
                ),
              )
            : Opacity(
                opacity: _animation.value,
                child: Container(
                  width: size.width,
                  height: size.height,
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: whenDevice(
                            context,
                            large: isPortrait(context) ? 10 : 20,
                            tablet: 30,
                          ),
                        ),
                        child: _buildSubtitleCell(context, size.width),
                      ),
                      VideoPlayerActions(
                        customController: widget.customController,
                        showVideoPlayerMenu: _showVideoPlayerMenu,
                        minimizeVideo: widget.minimizeVideo,
                      ),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: isPortrait(context) ? 0 : 10,
                        child: Container(
                          width: isPortrait(context)
                              ? size.width - 30
                              : size.width,
                          child: VideoProgressBarMenu(
                            minimizeVideo: widget.minimizeVideo,
                            customController: widget.customController,
                            showVideoPlayerMenu: _showVideoPlayerMenu,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSubtitleCell(BuildContext context, double width) {
    if (_getSubtitleText().isEmpty || !widget.customController.subtitles)
      return Container();
    return Container(
      width: width,
      color: Color.fromRGBO(0, 0, 0, 0.5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          _getSubtitleText(),
          style: normalResponsiveFont(context, fontColor: FontColor.Content2),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  String _getSubtitleText() {
    final currentPosition = widget.customController?.videoPlayerController
        ?.value?.position?.inMilliseconds;
    if (currentPosition == null) return "";
    List<Subtitle> foundList = _subtitles
        .where(
          (subtitle) =>
              subtitle.range.begin < currentPosition &&
              subtitle.range.end > currentPosition,
        )
        .toList();

    if (foundList != null && foundList.isNotEmpty) {
      final sub = foundList[0].rawLines.toString();
      return sub.substring(1, sub.length - 1);
    } else {
      return "";
    }
  }

  void _showVideoPlayerMenu() {
    if (_closeMenuTimer != null) _closeMenuTimer.cancel();
    if (_animationController.status == AnimationStatus.dismissed)
      _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _closeMenuTimer?.cancel();
    _showMenuTimer.cancel();
    super.dispose();
  }
}
