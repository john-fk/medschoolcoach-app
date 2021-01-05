import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/bookmarks_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/bookmark/bookmark_widget.dart';
import 'package:Medschoolcoach/widgets/others/tick_icon.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class ScheduleListCellData {
  final String imagePath;
  final String videoId;
  final String lessonName;
  final int percentages;
  final String totalLength;
  bool bookmarked;
  final String topicId;
  final bool updateTopic;
  final VoidCallback swipeFunction;

  ScheduleListCellData({
    this.imagePath,
    this.videoId,
    this.lessonName,
    this.percentages,
    this.totalLength,
    this.bookmarked = false,
    this.topicId,
    this.updateTopic = false,
    this.swipeFunction,
  });
}

class ScheduleListCell extends StatefulWidget {
  final int index;
  final ScheduleListCellData cellData;
  final VoidCallback onTap;
  final VoidCallback onBookmarkTap;

  const ScheduleListCell({
    this.index,
    this.cellData,
    this.onTap,
    this.onBookmarkTap,
  });

  @override
  _ScheduleListCellState createState() => _ScheduleListCellState();
}

class _ScheduleListCellState extends State<ScheduleListCell> {
  final BookmarksRepository _bookmarksRepository =
      Injector.appInstance.getDependency<BookmarksRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  bool isProgressIndicator = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key(widget.cellData.lessonName),
      onTap: () {
        onItemTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 17.0,
          right: 20,
          top: 15,
        ),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        right: 8.0,
                      ),
                      child: Container(
                        height: whenDevice(context, large: 70, tablet: 112),
                        width: whenDevice(context, large: 70, tablet: 112),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Style.of(context).colors.separator,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                              widget.cellData.imagePath,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _drawImageBadge(context)
                  ],
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(context, "lesson_screen.lesson", {
                          "order": widget.index.toString(),
                        }),
                        style: smallResponsiveFont(
                          context,
                          fontWeight: FontWeight.w500,
                          fontColor: widget.cellData.percentages != 0
                              ? FontColor.Accent2
                              : FontColor.Accent,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.cellData.lessonName,
                        style: normalResponsiveFont(context),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 3,
                        child: LinearProgressIndicator(
                          backgroundColor: Style.of(context).colors.separator,
                          value: widget.cellData.percentages / 100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Style.of(context).colors.accent2),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              right: -7,
              top: -7,
              child: BookmarkWidget(
                active: widget.cellData.bookmarked,
                onTap: _onTap,
              ),
            ),
            Positioned(
              right: 20,
              top: 5,
              child: (!isProgressIndicator
                  ? Container()
                  : SizedBox(child: ProgressBar(), height: 10.0, width: 10.0)),
            )
          ],
        ),
      ),
    );
  }

  void onItemTap() {
    if (!isProgressIndicator) {
      widget.onTap();
    }
  }

  Future<void> _onTap() async {
    bool initialValue = widget.cellData.bookmarked;

    isProgressIndicator = true;
    RepositoryResult response;
    if (initialValue) {
      response = await _bookmarksRepository.deleteBookmark(
        videoId: widget.cellData.videoId,
      );
    } else {
      response = await _bookmarksRepository.addBookmark(
        videoId: widget.cellData.videoId,
      );
    }
    if (response is RepositoryErrorResult) {
      setState(() {
        widget.cellData.bookmarked = initialValue;
      });
    } else {
      widget.onBookmarkTap();
    }
    _analyticsProvider.logVideoBookMarkEvent(
        initialValue, widget.cellData.videoId, widget.cellData.lessonName);
    isProgressIndicator = false;
  }

  Positioned _drawImageBadge(BuildContext context) {
    return widget.cellData.percentages == 100
        ? Positioned(
            top: 2,
            right: 2,
            child: TickIcon(),
          )
        : Positioned(
            top: 2,
            right: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: widget.cellData.percentages != 0
                    ? Style.of(context).colors.accent2
                    : Style.of(context).colors.accent,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 3.0, horizontal: 12),
                child: Text(
                  widget.cellData.percentages != 0
                      ? widget.cellData.percentages.toString() + "%"
                      : widget.cellData.totalLength,
                  style: smallResponsiveFont(
                    context,
                    fontColor: FontColor.Content2,
                  ),
                ),
              ),
            ),
          );
  }
}
