import 'package:Medschoolcoach/widgets/video_player/custom_video_controller.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/video_player_menu.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatelessWidget {
  final CustomVideoController customVideoController;
  final VoidCallback changeViewMode;

  const VideoPlayerWidget({
    Key key,
    @required this.customVideoController,
    @required this.changeViewMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: AspectRatio(
            aspectRatio: customVideoController.aspectRatio,
            child: customVideoController.isVideoInitialized()
                ? VideoPlayer(customVideoController.videoPlayerController)
                : Container(),
          ),
        ),
        Positioned.fill(
          child: VideoPlayerMenu(
            minimizeVideo: changeViewMode,
            customController: customVideoController,
          ),
        )
      ],
    );
  }
}
