import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/video_player/custom_video_controller.dart';
import 'package:Medschoolcoach/widgets/video_player/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class FullscreenVideo extends StatelessWidget {
  final bool loading;
  final CustomVideoController customVideoController;
  final VoidCallback closeFullscreenVideo;
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  FullscreenVideo({
    @required this.loading,
    @required this.customVideoController,
    @required this.closeFullscreenVideo,
  }) {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (loading) return loadingContent();
    if (customVideoController == null) return errorContent(context);

    return VideoPlayerWidget(
      customVideoController: customVideoController,
      changeViewMode: closeFullscreenVideo,
    );
  }

  Widget loadingContent() {
    return Center(
      child: ProgressBar(),
    );
  }

  Widget errorContent(BuildContext context) {
    return GestureDetector(
      onTap: closeFullscreenVideo,
      child: Container(
        color: Colors.transparent,
        child: Center(
          child: Text(
            FlutterI18n.translate(context, "video_screen.error"),
            style: Style.of(context).font.normal2Big,
          ),
        ),
      ),
    );
  }
}
