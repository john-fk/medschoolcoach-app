import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/schedule_repository.dart';

import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/ui/schedule/widgets/schedule_picker.dart';
import 'package:Medschoolcoach/ui/slidable_cell/slidable_cell.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_date_response.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/schedule_day_list_cell.dart';
import 'package:Medschoolcoach/widgets/list_cells/schedule_list_cell.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:Medschoolcoach/widgets/others/tick_icon.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final ScheduleRepository _scheduleRepository =
      Injector.appInstance.getDependency<ScheduleRepository>();

  ScrollController _scrollController = ScrollController();
  bool _shouldShowSchedule = false;
  bool _loading = true;
  bool _completed = false;
  RepositoryResult _setScheduleError;
  RepositoryResult _singleScheduleError;
  RepositoryResult _globalError;
  List<DayItemData> _days;
  Map<String, int> scheduleProgress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => setScheduleInfo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        page: NavigationPage.Schedule,
      ),
      body: SafeArea(
        child: _getSectionWidget(context),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _getSectionWidget(BuildContext context) {
    if (_loading) {
      return _buildProgressBar();
    }

    if (_globalError != null) {
      return _buildGlobalError();
    }

    if (_singleScheduleError != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildScheduleHeader(),
            _buildDatesList(),
            Expanded(
              child: RefreshingEmptyState(
                repositoryResult: _singleScheduleError,
                refreshFunction: () {
                  _fetchSingleSchedule(
                    day: _days.firstWhere((element) => element.selected).day,
                    forceApiRequest: true,
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    if (_shouldShowSchedule) {
      final videos = SuperStateful.of(context).videosScheduleList;
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            _buildScheduleHeader(),
            _buildCompleted(),
            _buildDatesList(),
            videos != null && videos.isNotEmpty
                ? videos.any(
                    (video) => video.progress.percentage != 100,
                  )
                    ? Container()
                    : _buildLessonsDone()
                : Container(),
            Expanded(
              child: _buildLessonsList(videos),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(
          8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _setScheduleError != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: EmptyState(
                      repositoryResult: _setScheduleError,
                    ),
                  )
                : Container(),
            Center(
              child: SchedulePickerWidget(
                pickingSchedule: !_shouldShowSchedule || _completed,
                startSchedule: _startSchedule,
                currentScheduleLength: _days?.length,
              ),
            ),
          ],
        ),
      );
    }
  }

  Align _buildScheduleHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        FlutterI18n.translate(
          context,
          "navigation_bar.schedule",
        ),
        style: bigResponsiveFont(context, fontWeight: FontWeight.bold),
      ),
    );
  }

  RenderObjectWidget _buildProgressBar() {
    if (_shouldShowSchedule) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildScheduleHeader(),
            _buildCompleted(),
            _buildDatesList(),
            Expanded(
              child: Center(
                child: ProgressBar(),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: ProgressBar(),
      );
    }
  }

  Padding _buildGlobalError() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: RefreshingEmptyState(
              repositoryResult: _globalError,
              refreshFunction: () {
                setScheduleInfo(
                  forceApiRequest: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  RefreshIndicator _buildLessonsList(List<Video> videos) {
    return RefreshIndicator(
      onRefresh: () => _fetchSingleSchedule(
        day: _days.firstWhere((element) => element.selected).day,
        forceApiRequest: true,
      ),
      child: ListView.separated(
        key: Key("schedule_scroll"),
        itemCount: videos.length + 1,
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Style.of(context).colors.separator,
        ),
        itemBuilder: (context, index) {
          if (index == videos.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SchedulePickerWidget(
                pickingSchedule: !_shouldShowSchedule || _completed,
                startSchedule: _startSchedule,
                currentScheduleLength: _days?.length,
              ),
            );
          } else {
            return SlidableCell(
              successCallback: ({bool watched}) async {
                setState(() {
                  if(watched) {
                    videos[index].progress.percentage = 100;
                  } else {
                    videos[index].progress.percentage = 0;
                  }
                });
                await SuperStateful.of(context).updateScheduleProgress();
                scheduleProgress = SuperStateful.of(context).scheduleProgress;

                _fetchSingleSchedule(
                  showProgressBar: false,
                  day: _days.firstWhere((element) => element.selected).day,
                  forceApiRequest: true,
                );
              },
              video: videos[index],
              child: ScheduleListCell(
                index: index + 1,
                cellData: ScheduleListCellData(
                  imagePath: videos[index].image,
                  videoId: videos[index].id,
                  lessonName: videos[index].name,
                  percentages: videos[index].progress != null
                      ? videos[index].progress.percentage ?? 0
                      : 0,
                  totalLength: videos[index].length,
                  bookmarked: videos[index].favourite ?? false,
                  topicId: videos[index].topicId,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    Routes.lesson,
                    arguments: LessonVideoScreenArguments(
                      videos: videos,
                      order: index,
                      topicId: videos[index].topicId,
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Padding _buildDatesList() {
    scheduleProgress = SuperStateful.of(context).scheduleProgress;
    _days.forEach((date) => date.completed = _getProgress(date.day) == 100);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: whenDevice(
          context,
          large: 54,
          tablet: 80,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => ScheduleDayListCell(
            key: Key("day$index"),
            itemData: _days[index],
            onTap: () {
              _days.forEach((element) => element.selected = false);
              setState(() {
                _days[index].selected = true;
              });
              _fetchSingleSchedule(
                day: _days[index].day,
              );
            },
          ),
          itemCount: _days.length,
          separatorBuilder: (BuildContext context, int index) => SizedBox(
            width: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildCompleted() {
    return _completed
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  FlutterI18n.translate(
                    context,
                    "general.congratulations",
                  ),
                  style: normalResponsiveFont(
                    context,
                    fontWeight: FontWeight.bold,
                    fontColor: FontColor.Accent2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: Text(
                    FlutterI18n.translate(
                      context,
                      "schedule_screen.schedule_completed",
                    ),
                    style: normalResponsiveFont(context),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _buildLessonsDone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          FlutterI18n.translate(
            context,
            "schedule_screen.lessons_completed",
          ),
          style: normalResponsiveFont(
            context,
            fontColor: FontColor.Accent2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        TickIcon(),
      ],
    );
  }

  List<DayItemData> _getDaysList({
    @required int daysCount,
  }) {
    List<DayItemData> daysList = List<DayItemData>();

    for (int i = 0; i < daysCount; i++) {
      daysList.add(
        DayItemData(
          day: i + 1,
          selected: false,
          completed: _getProgress(i + 1) == 100,
        ),
      );
    }

    daysList
      ..sort(
        (a, b) => a.day.compareTo(b.day),
      );

    DayItemData selectedDayListItem = daysList.firstWhere(
      (dayItemData) => dayItemData.completed == false,
      orElse: () {
        return null;
      },
    );

    if (selectedDayListItem != null) {
      selectedDayListItem.selected = true;
    }

    _scrollController = ScrollController(
      initialScrollOffset:
          62 * daysList.indexWhere((element) => element.selected).toDouble(),
    );

    return daysList;
  }

  int _getProgress(int day) {
    if (scheduleProgress.isNotEmpty &&
        scheduleProgress.containsKey(day.toString())) {
      return scheduleProgress[day.toString()];
    } else {
      return 0;
    }
  }

  Future<void> _startSchedule(int days) async {
    if (_shouldShowSchedule) {
      _showConfirmationDialog(days);
    } else {
      Navigator.pop(context);
      await _sendStartScheduleRequest(days);
    }
  }

  Future _sendStartScheduleRequest(int days) async {
    setState(() {
      _loading = true;
      _setScheduleError = null;
    });
    var result = await _scheduleRepository.startSchedule(
      days: days,
    );

    if (result is RepositorySuccessResult) {
      setScheduleInfo(
        forceApiRequest: true,
      );
    } else {
      setState(() {
        _loading = false;
        _setScheduleError = result;
      });
    }
  }

  Future<void> setScheduleInfo({
    bool forceApiRequest = false,
  }) async {
    setState(() {
      _loading = true;
      _shouldShowSchedule = false;
      _globalError = null;
      _setScheduleError = null;
      _singleScheduleError = null;
    });

    var scheduleDateResult = await _scheduleRepository.fetchScheduleDate(
      forceApiRequest: forceApiRequest,
    );

    if (scheduleDateResult is RepositorySuccessResult<ScheduleDateResponse>) {
      await SuperStateful.of(context).updateScheduleProgress();
      scheduleProgress = SuperStateful.of(context).scheduleProgress;

      _days = _getDaysList(
        daysCount: int.parse(
          scheduleDateResult.data.length,
        ),
      );

      if (_days.any((day) => !day.completed)) {
        await _fetchSingleSchedule(
            day: _days.firstWhere((dayItemData) => dayItemData.selected).day);
      }

      setState(() {
        _completed = !_days.any((day) => !day.completed);
        _loading = false;
        _shouldShowSchedule = true;
      });
    } else if ((scheduleDateResult as RepositoryErrorResult).error ==
        ApiError.scheduleNotSelected) {
      setState(() {
        _loading = false;
        _shouldShowSchedule = false;
      });
    } else {
      setState(() {
        _loading = false;
        _globalError = scheduleDateResult;
      });
    }
  }

  Future<void> _fetchSingleSchedule({
    bool showProgressBar = true,
    int day,
    bool forceApiRequest = false,
  }) async {
    setState(() {
      _singleScheduleError = null;
      if(showProgressBar) {
        _loading = true;
      }
    });
    var response = await SuperStateful.of(context).updateSchedule(
      day: day,
      forceApiRequest: forceApiRequest,
    );

    if (response is RepositoryErrorResult) {
      setState(() {
        _loading = false;
        _singleScheduleError = response;
      });
    } else {
      setState(() {
        _loading = false;
        _singleScheduleError = null;
      });
    }
  }

  void _showConfirmationDialog(int days) {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "general.warning",
          ),
          content: FlutterI18n.translate(
            context,
            "schedule_screen.dialog_description",
          ),
          actions: <DialogActionData>[
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "general.cancel",
              ),
              onTap: () => {
                Navigator.pop(context),
              },
            ),
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "general.continue",
              ),
              onTap: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                await _sendStartScheduleRequest(days);
              },
            ),
          ],
        );
      },
    );
  }
}
