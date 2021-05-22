import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/schedule_repository.dart';
import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/ui/onboarding/time_per_day_screen.dart';
import 'package:Medschoolcoach/ui/slidable_cell/slidable_cell.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_date_response.dart';
import 'package:Medschoolcoach/utils/api/models/video.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/empty_state/refreshing_empty_state.dart';
import 'package:Medschoolcoach/widgets/list_cells/schedule_day_list_cell.dart';
import 'package:Medschoolcoach/widgets/list_cells/schedule_list_cell.dart';
import 'package:Medschoolcoach/widgets/others/tick_icon.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/time_banner/time_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
import 'tutor_header.dart';

class ScheduleTab extends StatefulWidget {
  @override
  _ScheduleTabState createState() => _ScheduleTabState();
}

class DaysLeft {
  int days;
  bool isSchedule;

  DaysLeft({this.days, this.isSchedule});

  DaysLeft.fromJson(Map<String, dynamic> json) {
    this.days = json['days'];
    this.isSchedule = json['isSchedule'];
  }
}

class _ScheduleTabState extends State<ScheduleTab> {
  final ScheduleRepository _scheduleRepository =
      Injector.appInstance.getDependency<ScheduleRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();
  final UserManager _userManager =
      Injector.appInstance.getDependency<UserManager>();
  final apiServices = Injector.appInstance.getDependency<ApiServices>();

  ScrollController _scrollController = ScrollController();
  bool _shouldShowSchedule = false;
  bool _loading = true;
  bool _completed = false;
  bool _isToggled = true;
  RepositoryResult _setScheduleError;
  RepositoryResult _singleScheduleError;
  RepositoryResult _globalError;
  List<DayItemData> _days;
  Map<String, int> scheduleProgress;
  DaysLeft daysLeft;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setScheduleInfo();
      fetchDaysLeft();
    });
  }

  Future<void> fetchDaysLeft() async {
    Map<String, dynamic> json = Map<String, dynamic>();
    var testDate = await _userManager.getTestDate();
    if (testDate != null) {
      var days = testDate.difference(DateTime.now()).inDays;
      json['days'] = days;
      json['isSchedule'] = false;
      if (json['days'] > 0) {
        setState(() {
          daysLeft = DaysLeft.fromJson(json);
        });
      }
    }

    var progress = SuperStateful.of(context).courseProgress;
    if (progress == null) {
      await SuperStateful.of(context)
          .updateCourseProgress(forceApiRequest: true);
    }

    progress = SuperStateful.of(context).courseProgress;
    if (progress != null && progress.daysLeft > 0) {
      json['days'] = progress.daysLeft;
      json['isSchedule'] = true;
      setState(() {
        return DaysLeft.fromJson(json);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var horizontalInset =
        whenDevice(context, large: 8.0, medium: 4.0, small: 4.0);
    return Container(
        padding: EdgeInsets.only(
            left: horizontalInset, right: horizontalInset, top: 16),
        child: _getScheduleSection(context));
  }

  Widget _getScheduleSection(BuildContext context) {
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
            //_updateScheduleSection(),
            TutorHeader(getTutor:getTutor,changeSchedule:changeSchedule),
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
      if (videos != null &&
          videos.isNotEmpty &&
          !videos.any(
              (video) => video.progress.percentage != 100 && !_completed)) {
        _completed = !_days.any((day) => !day.completed);
      }

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TutorHeader(getTutor:getTutor,changeSchedule:changeSchedule),
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
            )
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
                : Container()
          ],
        ),
      );
    }
  }

  Widget _buildScheduleHeader() {
    return
      (daysLeft==null || daysLeft.days==null) ?
        SizedBox.shrink()
        :Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15),
      child: TimeBanner(
        daysLeft: daysLeft?.days ?? -1,
        isSchedule: daysLeft?.isSchedule,
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

  //this is part of the hack to make sure the favourite
  // attribute is updated correctly in the topic for the LessonVideoScreen
  void _toggleBookmark(int index) {
    _isToggled = false;
    final videos = SuperStateful.of(context).videosScheduleList;
    videos[index].favourite = !videos[index].favourite;
    _isToggled = true;
  }

  void _doNothing() {
    //do nothing
  }

  RefreshIndicator _buildLessonsList(List<Video> videos) {
    return RefreshIndicator(
      onRefresh: () {
        return _fetchSingleSchedule(
            day: _days.firstWhere((element) => element.selected).day,
            forceApiRequest: true);
      },
      child: ListView.separated(
        key: Key("schedule_scroll"),
        itemCount: videos != null ? videos.length : 0,
        separatorBuilder: (context, index) => Container(
          height: 1,
          color: Style.of(context).colors.separator,
        ),
        itemBuilder: (context, index) {
            return SlidableCell(
              successCallback: ({bool watched}) async {
                setState(() {
                  if (watched) {
                    videos[index].progress.percentage = 100;
                  } else {
                    videos[index].progress.percentage = 0;
                  }
                });
                await SuperStateful.of(context)
                    .updateCourseProgress(forceApiRequest: true);
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
                  _isToggled
                      ? _navigateToLessonVideoScreen(videos, index)
                      : _doNothing();
                },
                onBookmarkTap: () {
                  _toggleBookmark(index);
                },
              ),
            );
        },
      ),
    );
  }

  void _logAnalytics(String event, Video video) {
    _analyticsProvider.logEvent(event,
        params: _analyticsProvider.getVideoParam(video.id, video.name,
            additionalParams: {
              AnalyticsConstants.keySource: AnalyticsConstants.screenLearn
            }));
  }

  void _navigateToLessonVideoScreen(List<Video> videos, int index) {
    Navigator.of(context).pushNamed(
      Routes.lesson,
      arguments: LessonVideoScreenArguments(
          videos: videos,
          order: index,
          topicId: videos[index].topicId,
          source: AnalyticsConstants.screenLearn),
    );

    _logAnalytics(AnalyticsConstants.tapLesson, videos[index]);
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
              _analyticsProvider.logEvent(AnalyticsConstants.tapScheduleDay,
                  params: {AnalyticsConstants.keySelectedDay: index + 1});
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
        return daysList.first;
      },
    );

    selectedDayListItem.selected = true;

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
      var existingProgress = SuperStateful.of(context).scheduleProgress;

      if (existingProgress.length == 0 || forceApiRequest) {
        await SuperStateful.of(context).updateScheduleProgress();
      }

      scheduleProgress = SuperStateful.of(context).scheduleProgress;

      _days = _getDaysList(
        daysCount: int.parse(
          scheduleDateResult.data.length,
        ),
      );

      await _fetchSingleSchedule(
          day: _days.firstWhere((dayItemData) => dayItemData.selected).day);

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
    var videosScheduleList = await _scheduleRepository.getCacheVideos(day: day);
    var hasVideos = videosScheduleList != null && videosScheduleList.length > 0;

    setState(() {
      _singleScheduleError = null;
      if (showProgressBar) {
        _loading = hasVideos ? false : true;
      }
      if (hasVideos) {
        SuperStateful.of(context).videosScheduleList = videosScheduleList;
      }
      if (hasVideos) {
        _shouldShowSchedule = true;
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
 void changeSchedule(){
   _analyticsProvider.logEvent(AnalyticsConstants.tapChangeSchedule);
   Navigator.of(context)
       .push(
     MaterialPageRoute<void>(builder: (_) => TimePerDay()),
   )
       .then((_) => setScheduleInfo(forceApiRequest: true));
 }
 void getTutor(){
   _analyticsProvider.logEvent(AnalyticsConstants.tapSpeedupSchedule);
   Routes.navigateToTutoringScreen(
       context, AnalyticsConstants.screenLearn,
       isNavBar: false);
 }
}
