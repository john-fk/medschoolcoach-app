import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/video_player/widgets/video_player_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReconnectWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ReconnectWidget({Key key, @required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: VideoPlayerActions.playPauseCircleSize,
        height: VideoPlayerActions.playPauseCircleSize,
        child: SvgPicture.asset(
          Style.of(context).svgAsset.reconnectVideo,
        ),
      ),
    );
  }
}
