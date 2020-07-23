import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:Medschoolcoach/widgets/list_cells/schedule_list_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class BookmarkListCell extends StatefulWidget {
  final String subjectName;
  final bool initiallyExpanded;
  final List<Video> videos;
  final VoidCallback onVideoRemoved;

  BookmarkListCell({
    @required this.subjectName,
    this.initiallyExpanded = false,
    this.videos,
    this.onVideoRemoved,
  });

  @override
  _BookmarkListCellState createState() => _BookmarkListCellState();
}

class _BookmarkListCellState extends State<BookmarkListCell>
    with TickerProviderStateMixin {
  final _listKey = GlobalKey<AnimatedListState>();

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(
          milliseconds: 150,
        ),
        vsync: this,
        value: 1.0);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _animation,
      child: _buildContent(context),
    );
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Container _buildContent(BuildContext context) {
    if (widget.videos.isEmpty) {
      _animationController.reverse();
    }
    return Container(
      child: CustomExpansionTile(
        key: Key(widget.subjectName),
        initiallyExpanded: widget.initiallyExpanded,
        children: [
          AnimatedList(
            key: _listKey,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index, animation) {
              if (widget.videos[index] != null) {
                return _buildListItem(
                  widget.videos[index],
                  animation,
                  index,
                  context,
                );
              } else {
                return Container();
              }
            },
            initialItemCount: widget.videos.length,
          )
        ],
        title: Padding(
          padding: EdgeInsets.symmetric(
            vertical: whenDevice(
              context,
              large: 0,
              tablet: 20,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.subjectName,
                  style: biggerResponsiveFont(
                    context,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: Text(_getLessonsCountString()),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getLessonsCountString() {
    final count = widget.videos.length;

    if (count == 1)
      return FlutterI18n.translate(context, "bookmarks.single_lesson");

    return FlutterI18n.translate(
      context,
      "app_bar.section_subtitle",
      {
        "number": count.toString(),
      },
    );
  }

  SizeTransition _buildListItem(
    Video video,
    Animation<double> animation,
    int index,
    BuildContext context,
  ) {
    return SizeTransition(
      sizeFactor: animation,
      child: ScheduleListCell(
        index: video.order + 1,
        cellData: ScheduleListCellData(
          imagePath: video.image,
          videoId: video.id,
          lessonName: video.name,
          percentages:
              video.progress != null ? video.progress.percentage ?? 0 : 0,
          totalLength: video.length,
          bookmarked: true,
          topicId: video.topicId,
        ),
        onTap: () {
          _goToLessonScreen(
            context,
            widget.videos[index].order,
            widget.videos[index].topicId,
          );
        },
        onBookmarkTap: () {
          Video removedVideo = widget.videos[index];
          widget.videos.removeAt(index);

          _listKey.currentState.removeItem(
            index,
            (BuildContext context, Animation animation) {
              return _buildListItem(
                removedVideo,
                animation,
                index,
                context,
              );
            },
            duration: const Duration(
              milliseconds: 150,
            ),
          );
          setState(() {});
          widget.onVideoRemoved();
        },
      ),
    );
  }

  void _goToLessonScreen(BuildContext context, int index, String topicId) {
    Navigator.pushNamed(
      context,
      Routes.lesson,
      arguments: LessonVideoScreenArguments(
        order: index,
        topicId: topicId,
      ),
    );
  }
}
