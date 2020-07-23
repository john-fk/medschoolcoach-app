import 'package:Medschoolcoach/repository/bookmarks_repository.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/bookmark/bookmark_widget.dart';
import 'package:Medschoolcoach/widgets/others/tick_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class SearchListCellData {
  final String imagePath;
  final String lessonName;
  final int percentages;
  final String totalLength;
  final String sectionName;
  final String videoId;
  bool bookmarked;

  SearchListCellData({
    this.imagePath,
    this.lessonName,
    this.percentages,
    this.totalLength,
    this.sectionName,
    this.videoId,
    this.bookmarked,
  });
}

class SearchListCell extends StatefulWidget {
  final SearchListCellData cellData;
  final VoidCallback onTap;

  const SearchListCell({
    this.cellData,
    this.onTap,
  });

  @override
  _SearchListCellState createState() => _SearchListCellState();
}

class _SearchListCellState extends State<SearchListCell> {
  final BookmarksRepository _bookmarksRepository =
      Injector.appInstance.getDependency<BookmarksRepository>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key(widget.cellData.lessonName),
      onTap: widget.onTap,
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
                            image: NetworkImage(widget.cellData.imagePath),
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
                        widget.cellData.sectionName,
                        style: smallResponsiveFont(
                          context,
                          fontWeight: FontWeight.w500,
                          fontColor: widget.cellData.percentages != 0
                              ? FontColor.Accent2
                              : FontColor.Accent,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
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
                            Style.of(context).colors.accent2,
                          ),
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
                onTap: _tapBookmark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _tapBookmark() async {
    bool initialValue = widget.cellData.bookmarked;

    setState(() {
      widget.cellData.bookmarked = !initialValue;
    });

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
    }
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
                padding: const EdgeInsets.symmetric(
                  vertical: 3.0,
                  horizontal: 12,
                ),
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
