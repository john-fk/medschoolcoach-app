import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/ui/slidable_cell/slidable_cell.dart';
import 'package:Medschoolcoach/utils/api/models/dashboard_schedule.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/utils/toasts.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/list_cells/schedule_list_cell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class _HomeScheduleVideo {
  final Video video;
  final int index;

  _HomeScheduleVideo(
    this.video,
    this.index,
  );
}

class HomeSchedule extends StatefulWidget {
  const HomeSchedule({
    Key key,
  }) : super(key: key);

  @override
  _HomeScheduleState createState() => _HomeScheduleState();
}

class _HomeScheduleState extends State<HomeSchedule> {

  bool _isToggled = true;

  //this is part of the hack to make sure the favorte attribute is updated correctly in the topic for the LessonVideoScreen
  void _toggleBookmark(int index)  {
    _isToggled = false;
    DashboardSchedule dashboardSchedule =
        SuperStateful.of(context).todaySchedule;
    List<Video> videos = dashboardSchedule.items;
    videos[index].favourite = !videos[index].favourite;
    _isToggled = true;
  }

  void _doNothing() {
    //do nothing
  }

  @override
  Widget build(BuildContext context) {
    DashboardSchedule dashboardSchedule =
        SuperStateful.of(context).todaySchedule;
    List<Video> videos = dashboardSchedule.items;
    List<_HomeScheduleVideo> videosToDisplay = videos
        .where((element) => element.progress.percentage != 100)
        .take(3)
        .toList()
        .map(
          (video) => _HomeScheduleVideo(
            video,
            videos.indexOf(video),
          ),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FlutterI18n.translate(context, 'home_screen.up_next'),
                style:
                    normalResponsiveFont(context, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  FlutterI18n.translate(
                    context,
                    "home_screen.day",
                    {
                      "number": (dashboardSchedule.today).toString(),
                    },
                  ),
                  style: normalResponsiveFont(context,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: videosToDisplay.length + 1,
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Style.of(context).colors.separator,
            ),
            itemBuilder: (context, index) {
              if (index == videosToDisplay.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _goToScheduleButton(context),
                );
              } else {
                return SlidableCell(
                  successCallback: ({bool watched}) async {
                    await SuperStateful.of(context).updateTodaySchedule(
                      forceApiRequest: true,
                    );
                    await SuperStateful.of(context)
                        .updateGlobalStatistics(forceApiRequest: true);
                    await SuperStateful.of(context)
                        .updateSectionsList(forceApiRequest: true);
                    if (watched)
                      showWatchedToast(context);
                    else
                      showUnwatchedToast(context);
                  },
                  video: videosToDisplay[index].video,
                  child: ScheduleListCell(
                    index: videosToDisplay[index].index + 1,
                    cellData: ScheduleListCellData(
                      imagePath: videosToDisplay[index].video.image,
                      videoId: videosToDisplay[index].video.id,
                      lessonName: videosToDisplay[index].video.name,
                      percentages: videosToDisplay[index].video.progress != null
                          ? videosToDisplay[index].video.progress.percentage ??
                              0
                          : 0,
                      totalLength: videosToDisplay[index].video.length,
                      bookmarked:
                          videosToDisplay[index].video.favourite ?? false,
                      topicId: videosToDisplay[index].video.topicId,
                    ),
                    onTap: () { _isToggled ?
                      Navigator.of(context).pushNamed(
                        Routes.lesson,
                        arguments: LessonVideoScreenArguments(
                          videos: videos,
                          order: videosToDisplay[index].index,
                          topicId: videosToDisplay[index].video.topicId,
                        ),
                      ) : _doNothing();
                    },
                    onBookmarkTap: () {
                      _toggleBookmark(index);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Padding _goToScheduleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: PrimaryButton(
        text: FlutterI18n.translate(
          context,
          "home_screen.see_full_schedule_button",
        ),
        onPressed: () {
          Navigator.pushNamed(
            context,
            Routes.schedule,
          );
        },
      ),
    );
  }
}
