import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

import '../custom_video_controller.dart';

class VideoProgressBar extends StatelessWidget {
  final CustomVideoController customController;
  final VoidCallback showVideoPlayerMenu;

  final GlobalKey progressBarKey = GlobalKey();

  VideoProgressBar({
    Key key,
    @required this.customController,
    @required this.showVideoPlayerMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currectPositionSeconds =
        customController.videoPlayerController.value?.position?.inSeconds;
    final durationSeconds =
        customController.videoPlayerController.value?.duration?.inSeconds;

    return GestureDetector(
      onTap: showVideoPlayerMenu,
      onTapDown: _seekTo,
      child: Container(
        color: Colors.transparent,
        height: 30,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          key: progressBarKey,
          children: <Widget>[
            Expanded(
              flex: currectPositionSeconds,
              child: Container(
                color: customController.commercial
                    ? Style.of(context).colors.premium
                    : Style.of(context).colors.accent,
                height: whenDevice(context, large: 5, tablet: 8),
              ),
            ),
            Expanded(
              flex: _leftVideoBarFlex(durationSeconds, currectPositionSeconds),
              child: Container(
                color: Style.of(context).colors.content2,
                height: whenDevice(context, large: 5, tablet: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _seekTo(TapDownDetails details) {
    if (!customController.isVideoInitialized() || customController.commercial)
      return;
    final positionFactor =
        details.localPosition.dx / progressBarKey.currentContext.size.width;
    final duration =
        customController.videoPlayerController.value.duration.inMilliseconds;
    final newPositionInMilliseconds = (duration * positionFactor).round();
    customController.seekTo(
        position: Duration(milliseconds: newPositionInMilliseconds));
  }

  int _leftVideoBarFlex(
    dynamic durationSeconds,
    dynamic currectPositionSeconds,
  ) {
    if (durationSeconds != null) {
      return durationSeconds - currectPositionSeconds;
    } else
      return 1;
  }
}
