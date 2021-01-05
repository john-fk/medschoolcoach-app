import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/bookmarks_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/bookmark/bookmark_widget.dart';
import 'package:Medschoolcoach/widgets/video_player/custom_video_controller.dart';
import 'package:Medschoolcoach/widgets/video_player/video_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';

import '../lesson_video_screen.dart';

class LessonWidget extends StatefulWidget {
  final Video video;
  final double contentWidth;
  final LessonVideoScreenArguments arguments;
  final CustomVideoController customVideoController;
  final VoidCallback openFullscrenVideo;
  final bool videoPlayerVisible;
  final VoidCallback makeVideoPlayerVisible;

  LessonWidget({
    Key key,
    @required this.video,
    @required this.contentWidth,
    @required this.arguments,
    @required this.customVideoController,
    @required this.openFullscrenVideo,
    @required this.videoPlayerVisible,
    @required this.makeVideoPlayerVisible,
  }) : super(key: key);

  @override
  _LessonWidgetState createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget> {
  final BookmarksRepository _bookmarksRepository =
      Injector.appInstance.getDependency<BookmarksRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  final radius = BorderRadius.circular(10);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = widget.contentWidth * 0.562;
    return Material(
      borderRadius: radius,
      elevation: 5,
      child: Container(
        width: widget.contentWidth,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: radius,
                  child: _buildContent(imageHeight),
                ),
                Padding(
                  padding: EdgeInsets.all(
                    whenDevice(
                      context,
                      small: 10,
                      large: 20,
                      tablet: 30,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width:
                                    whenDevice(context, large: 50, tablet: 80),
                                height:
                                    whenDevice(context, large: 25, tablet: 40),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Style.of(context).colors.accent,
                                ),
                                child: Text(
                                  widget.video == null
                                      ? ""
                                      : widget.video.length,
                                  style: normalResponsiveFont(
                                    context,
                                    fontColor: FontColor.Content2,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                FlutterI18n.translate(
                                    context,
                                    "lesson_screen.lesson",
                                    {"order": _getOrder()}),
                                style: normalResponsiveFont(
                                  context,
                                  fontColor: FontColor.Accent,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              _buildVideoProgress(),
                              BookmarkWidget(
                                active: widget.video != null &&
                                    widget.video.favourite,
                                onTap: _onBookmarkTap,
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: whenDevice(
                          context,
                          small: 5,
                          large: 10,
                          tablet: 20,
                        ),
                      ),
                      Text(
                        widget.video == null ? "" : widget.video.name,
                        key: widget.video == null
                            ? null
                            : Key(widget.video.name),
                        style: bigResponsiveFont(
                          context,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            if (!widget.videoPlayerVisible)
              ClipRRect(
                borderRadius: radius,
                child: Container(
                  color: Style.of(context).colors.shadow,
                  width: widget.contentWidth,
                  height: imageHeight,
                  child: Center(
                    child: GestureDetector(
                      key: const Key("open video player"),
                      onTap: widget.makeVideoPlayerVisible,
                      child: Container(
                        width: widget.contentWidth / 4.5,
                        height: widget.contentWidth / 4.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Style.of(context).colors.brightShadow,
                        ),
                        child: Container(
                          margin: EdgeInsets.all(widget.contentWidth / 20),
                          padding:
                              EdgeInsets.only(left: widget.contentWidth / 40),
                          child: SvgPicture.asset(
                            Style.of(context).svgAsset.playVideo,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(double imageHeight) {
    if (widget.videoPlayerVisible)
      return VideoPlayerWidget(
        customVideoController: widget.customVideoController,
        changeViewMode: widget.openFullscrenVideo,
      );
    if (widget.video == null)
      return Container(
        width: widget.contentWidth,
        height: imageHeight,
      );
    return Image.network(
      widget.video.image,
      fit: BoxFit.cover,
      height: imageHeight,
      width: widget.contentWidth,
    );
  }

  Widget _buildVideoProgress() {
    TextStyle style;
    if (widget.video == null || widget.videoPlayerVisible) return Container();
    final progress = widget.video.progress.percentage;
    if (progress == 0) return Container();
    if (progress == 100)
      style = normalResponsiveFont(
        context,
        fontWeight: FontWeight.w500,
        fontColor: FontColor.Accent2,
      );
    else
      style = normalResponsiveFont(
        context,
        fontWeight: FontWeight.w500,
        fontColor: FontColor.Accent,
      );
    return Text(
      "${widget.video.progress.percentage.toString()}%",
      style: style,
    );
  }

  String _getOrder() {
    if (widget.arguments.order != null) {
      return (widget.arguments.order + 1).toString();
    } else {
      return widget.video == null ? "" : (widget.video.order + 1).toString();
    }
  }

  Future<void> _onBookmarkTap() async {
    bool initialValue = widget.video.favourite ?? false;

    setState(() {
      widget.video.favourite = !initialValue;
    });

    RepositoryResult response;
    if (initialValue) {
      response = await _bookmarksRepository.deleteBookmark(
        videoId: widget.video.id,
      );
    } else {
      response = await _bookmarksRepository.addBookmark(
        videoId: widget.video.id,
      );
    }
    if (response is RepositoryErrorResult) {
      setState(() {
        widget.video.favourite = initialValue;
      });
    } else {
      SuperStateful.of(context).updateBookmarks(
        forceApiRequest: true,
      );
    }
    _analyticsProvider.logVideoBookMarkEvent(
        initialValue, widget.video.id, widget.video.name);
  }
}
