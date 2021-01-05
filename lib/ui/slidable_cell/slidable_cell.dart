import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/video_repository.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:injector/injector.dart';

typedef SuccessCallback({@required bool watched});

class SlidableCell extends StatelessWidget {
  final Widget child;
  final Video video;
  final SuccessCallback successCallback;
  final AnalyticsProvider _analyticsProvider =
    Injector.appInstance.getDependency<AnalyticsProvider>();

  SlidableCell({
    @required this.child,
    @required this.video,
    @required this.successCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.34,
      child: child,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
          ),
          child: IconSlideAction(
            caption: FlutterI18n.translate(
              context,
              "schedule_screen.unwatched",
            ),
            color: Style.of(context).colors.questions,
            icon: Icons.check_box_outline_blank,
            onTap: () => _markWatchedUnwatched(false),
          ),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: FlutterI18n.translate(
            context,
            "schedule_screen.watched",
          ),
          color: Style.of(context).colors.accent2,
          icon: Icons.check_box,
          onTap: () => _markWatchedUnwatched(true),
        )
      ],
    );
  }

  void _markWatchedUnwatched(bool watch) async {
    final videoRepository =
        Injector.appInstance.getDependency<VideoRepository>();

    final result = await videoRepository.setVideoProgress(
      videoId: video.id,
      seconds: watch ? "${video.seconds + 5}" : "0",
    );
    if (result is RepositorySuccessResult) {
      _analyticsProvider.logEvent(
          watch
              ? AnalyticsConstants.tapVideoMarkWatched
              : AnalyticsConstants.tapVideoMarkUnwatched,
          params: _analyticsProvider.getVideoParam(video.id, video.name));
      successCallback(watched: watch);
    }
  }
}
