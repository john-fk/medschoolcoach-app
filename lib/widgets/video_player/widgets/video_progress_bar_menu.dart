import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

import '../custom_video_controller.dart';

class VideoProgressBarMenu extends StatefulWidget {
  final CustomVideoController customController;
  final VoidCallback showVideoPlayerMenu;
  final VoidCallback minimizeVideo;

  const VideoProgressBarMenu({
    @required this.customController,
    @required this.showVideoPlayerMenu,
    @required this.minimizeVideo,
  });

  @override
  _VideoProgressBarMenuState createState() => _VideoProgressBarMenuState();
}

class _VideoProgressBarMenuState extends State<VideoProgressBarMenu>
    with TickerProviderStateMixin {
  bool _showSettings = false;
  double sideMarginValue = 50.0;

  AnimationController rotationController;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isPortrait(context)) {
      sideMarginValue = 20;
    } else {
      sideMarginValue = 50;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        isPortrait(context)
            ? Container(
                margin: EdgeInsets.only(
                  right: widget.customController.commercial
                      ? whenDevice(
                          context,
                          large: 36,
                          tablet: 56,
                        )
                      : whenDevice(
                          context,
                          large: 16,
                          tablet: 36,
                        ),
                ),
                child: _showSettings ? _settingsPicker(context) : Container(),
              )
            : Container(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: sideMarginValue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isPortrait(context))
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        constraints: _videoTitleTextConstrains(),
                        child: Text(
                          _getVideoName(),
                          style: bigResponsiveFont(
                            context,
                            fontColor: FontColor.Content2,
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                        ),
                      ),
                      _showSettings
                          ? Padding(
                              padding: widget.customController.commercial
                                  ? EdgeInsets.only(right: 16.0)
                                  : EdgeInsets.all(0),
                              child: _settingsPicker(context),
                            )
                          : Container()
                    ],
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: whenDevice(context, large: 50, tablet: 80),
                    child: Text(
                      _getFormatedTime(widget.customController
                          .videoPlayerController.value.position),
                      style: normalResponsiveFont(
                        context,
                        fontColor: FontColor.Content2,
                      ),
                    ),
                  ),
                  Expanded(
                    child: VideoProgressBar(
                      customController: widget.customController,
                      showVideoPlayerMenu: widget.showVideoPlayerMenu,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: whenDevice(context, large: 50, tablet: 80),
                    child: Text(
                      _getFormatedTime(widget.customController
                          .videoPlayerController.value.duration),
                      style: normalResponsiveFont(
                        context,
                        fontColor: FontColor.Content2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (!widget.customController.commercial)
                    InkWell(
                      onTap: () {
                        widget.customController.switchSubtitles();
                      },
                      child: Icon(
                        Icons.subtitles,
                        color: widget.customController.subtitles
                            ? Colors.white
                            : Colors.white38,
                        size: whenDevice(context, large: 24, tablet: 45),
                      ),
                    ),
                  const SizedBox(width: 5),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.17)
                        .animate(rotationController),
                    child: InkWell(
                      onTap: _tapSettings,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: whenDevice(context, large: 24, tablet: 45),
                      ),
                    ),
                  ),
                  InkWell(
                    key: const Key("minimize video"),
                    onTap: widget.minimizeVideo,
                    child: SvgPicture.asset(
                      Style.of(context).svgAsset.minimizeVideo,
                      width: whenDevice(context, large: 35, tablet: 56),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Container _settingsPicker(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        color: Colors.black38,
      ),
      child: Padding(
        padding: EdgeInsets.all(whenDevice(context, large: 5, tablet: 10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _renderQualityColumn(),
            if (!widget.customController.commercial)
              Row(
                children: <Widget>[
                  SizedBox(
                    width: whenDevice(context, large: 10, tablet: 20),
                  ),
                  _renderSpeedColumn(),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _renderQualityColumn() {
    final availableQualities = List<VideoQuality>.from(VideoQuality.values);

    return Container(
      child: Column(
        children: <Widget>[
          Text(
            FlutterI18n.translate(context, "video_screen.quality"),
            style: normalResponsiveFont(
              context,
              fontColor: FontColor.Content2,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            children:
                availableQualities.reversed.map(_renderQualityWidget).toList(),
          ),
        ],
      ),
    );
  }

  Widget _renderQualityWidget(VideoQuality quality) {
    bool currentQuality = quality == widget.customController.videoQuality;
    return GestureDetector(
      onTap: currentQuality
          ? null
          : () {
              _showHideSettings();
              widget.customController.switchVideoResource(quality);
            },
      child: Container(
        alignment: Alignment.center,
        width: whenDevice(context, large: 50, tablet: 80),
        height: whenDevice(context, large: 25, tablet: 40),
        child: Text(
          _getQualityText(quality),
          style: normalResponsiveFont(
            context,
            fontColor: FontColor.Content2,
            fontWeight: currentQuality ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _renderSpeedColumn() {
    final availableSpeeds =
        List<VideoPlaybackSpeed>.from(VideoPlaybackSpeed.values);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "video_screen.speed"),
          style: normalResponsiveFont(
            context,
            fontColor: FontColor.Content2,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          children: availableSpeeds.reversed.map(_renderSpeedWidget).toList(),
        ),
      ],
    );
  }

  Widget _renderSpeedWidget(VideoPlaybackSpeed speed) {
    bool currentSpeed = speed == widget.customController.videoPlaybackSpeed;
    return InkWellObject(
      onTap: currentSpeed
          ? null
          : () {
              _showHideSettings();
              widget.customController.switchSpeed(speed);
            },
      child: Container(
        alignment: Alignment.center,
        height: whenDevice(context, large: 25, tablet: 40),
        width: whenDevice(context, large: 60, tablet: 90),
        child: Text(
          _getPlaybackSpeed(speed),
          style: normalResponsiveFont(
            context,
            fontColor: FontColor.Content2,
            fontWeight: currentSpeed ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _tapSettings() {
    rotationController.forward(from: 0.0);
    _showHideSettings();
  }

  String _getVideoName() {
    if (widget.customController.commercial)
      return FlutterI18n.translate(context, "video_screen.commercial",
          translationParams:  {
        "name": widget.customController.video.commercial.name,
      });
    return widget.customController.lessonScreenArguments.videos == null
        ? FlutterI18n.translate(context, "lesson_screen.lesson",
          translationParams:
          {"order": "${widget.customController.video.order + 1}"}) +
            ": ${widget.customController.video.name}"
        : FlutterI18n.translate(context, "lesson_screen.lesson",
            translationParams: {
              "order":
                  "${widget.customController.lessonScreenArguments.order + 1}"
            }) +
            ": ${widget.customController.video.name}";
  }

  BoxConstraints _videoTitleTextConstrains() {
    return BoxConstraints(
        maxWidth:
            (MediaQuery.of(context).size.width - 2 * sideMarginValue) - 100);
  }

  void _showHideSettings() {
    widget.showVideoPlayerMenu();
    setState(() {
      _showSettings = !_showSettings;
    });
  }

  String _getQualityText(VideoQuality quality) {
    switch (quality) {
      case VideoQuality.P360:
        return "360p";
      case VideoQuality.P540:
        return "540p";
      case VideoQuality.P720:
      default:
        return "720p";
    }
  }

  String _getPlaybackSpeed(VideoPlaybackSpeed playbackSpeed) {
    switch (playbackSpeed) {
      case VideoPlaybackSpeed.x15:
        return "1.5";
      case VideoPlaybackSpeed.x125:
        return "1.25";
      case VideoPlaybackSpeed.x175:
        return "1.75";
      case VideoPlaybackSpeed.x2:
        return "2";
      case VideoPlaybackSpeed.x1:
      default:
        return "Normal";
    }
  }

  String _getFormatedTime(Duration duration) {
    String twoDigits(dynamic n) {
      if (n == null) n = 0;
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration?.inMinutes?.remainder(60));
    String twoDigitSeconds = twoDigits(duration?.inSeconds?.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
