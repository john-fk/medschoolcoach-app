import 'package:Medschoolcoach/widgets/progress_bar/button_progress_bar.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/video_player_actions.dart';
import 'package:flutter/material.dart';

class VideoPlayerConnectionIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: VideoPlayerActions.playPauseCircleSize,
      height: VideoPlayerActions.playPauseCircleSize,
      child: ButtonProgressBar(),
    );
  }
}
