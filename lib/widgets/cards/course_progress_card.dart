import 'package:Medschoolcoach/utils/api/models/schedule_stats.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/cards/no_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:Medschoolcoach/utils/format_date.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:Medschoolcoach/utils/sizes.dart';

enum ProgressType {
  Behind,
  /* now < actual_completion_date && daysLeft + now >
           actual_completion_date */
  OnTrack, // daysLeft + now == actual_completion_date
  Ahead, // daysLeft + now < actual_completion_date
  FirstDay, // courseProgress == 0
  Failed, // now > actual_completion_date && courseProgress < 100
  Completed,
  NotStarted
}

class CourseProgressCard extends StatefulWidget {
  final VoidCallback onRefresh;

  CourseProgressCard({this.onRefresh, Key key}) : super(key: key);

  @override
  CourseProgressCardState createState() => CourseProgressCardState();
}

class CourseProgressCardState extends State<CourseProgressCard>
    with SingleTickerProviderStateMixin {
  double _programProgress = 0.0;
  double _scheduleProgress = 0.0;
  Color scheduleProgressColor;
  double scheduleProgressPercent;
  ProgressType track;
  ScheduleStats scheduleProgress;
  bool showLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  void setProgress() {
    if (scheduleProgress == null) {
      track = ProgressType.NotStarted;
      return;
    }
    var courseProgress = scheduleProgress.courseProgress;
    int daysLeft = scheduleProgress.daysLeft;
    int totalDays = scheduleProgress.totalDays;
    DateTime actualCompletionDate =
        DateTime.parse(scheduleProgress.actualCompletionDate);
    scheduleProgressPercent = (totalDays - daysLeft) / totalDays;
    DateTime currentCompletionDate =
        DateTime.now().add(Duration(days: daysLeft));

    bool hasStarted = courseProgress > 0;

    if (!hasStarted) {
      track = ProgressType.NotStarted;
      return;
    }

    if (scheduleProgressPercent == 0) {
      track = ProgressType.FirstDay;
    } else if (formatDate(actualCompletionDate, 'MM/dd/yyyy') ==
        formatDate(currentCompletionDate, 'MM/dd/yyyy')) {
      track = ProgressType.OnTrack;
    } else if (DateTime.now().isBefore(actualCompletionDate) &&
        currentCompletionDate.isAfter(actualCompletionDate)) {
      track = ProgressType.Behind;
    } else if (currentCompletionDate.isBefore(actualCompletionDate)) {
      track = ProgressType.Ahead;
    } else if (courseProgress < 100 &&
        DateTime.now().isAfter(actualCompletionDate)) {
      track = ProgressType.Failed;
    } else if (courseProgress == 100) {
      track = ProgressType.Completed;
    } else {
      track = ProgressType.NotStarted;
    }

    _programProgress = scheduleProgress.courseProgress / 100;
    _scheduleProgress = scheduleProgressPercent;
  }

  @override
  Widget build(BuildContext context) {
    scheduleProgress = SuperStateful.of(context).courseProgress;
    setProgress();

    scheduleProgressColor = track != ProgressType.Behind
        ? Style.of(context).colors.accent4
        : Style.of(context).colors.questions;
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: showLoading
          ? _buildCourseLoading()
          : (track != ProgressType.NotStarted
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20),
                  child: _programProgress == 1
                      ? _buildCourseCompletedCard()
                      : _buildCourseInProgressCard())
              : _buildCourseNotStartedCard()),
    );
  }

  Widget _scheduleButton() {
    if (track == ProgressType.Failed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: PrimaryButton(
          text: "Update My Schedule",
          onPressed: () {
            Navigator.of(context)
                .pushNamed(Routes.timePerDay, arguments: Routes.progressScreen);
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: PrimaryButton(
          text: "View My Schedule",
          onPressed: () {
            Navigator.of(context)
                .pushNamed(Routes.schedule, arguments: Routes.progressScreen);
          },
        ),
      );
    }
  }

  Widget _courseProgressFooter() {
    String progressText;
    switch (track) {
      case ProgressType.OnTrack:
        progressText = "Keep going, you're making progress";
        break;
      case ProgressType.FirstDay:
        progressText = "You haven't completed a full day yet";
        break;
      case ProgressType.Behind:
        progressText = "You're behind schedule!";
        break;
      case ProgressType.Ahead:
        progressText = "Great job, you’re ahead of schedule!";
        break;
      default:
        break;
    }

    if (track == ProgressType.Failed) {
      return Text(
        "But you've fallen behind schedule",
        style: smallResponsiveFont(context, fontColor: FontColor.BannerOrange),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            progressText,
            style: normalResponsiveFont(context, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Estimated Completion:  ",
                style: smallResponsiveFont(context, opacity: 0.6),
              ),
              Text(
                formatDate(
                    DateTime.now()
                        .add(Duration(days: scheduleProgress.daysLeft)),
                    'MM/dd/yyyy'),
                style:
                    smallResponsiveFont(context, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                "Days left:  ",
                style: smallResponsiveFont(context, opacity: 0.6),
              ),
              Text(
                """${scheduleProgress.daysLeft} ${scheduleProgress.daysLeft == 1 ? 'day' : 'days'}""",
                style:
                    smallResponsiveFont(context, fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          LinearPercentIndicator(
            backgroundColor: Style.of(context).colors.background3,
            percent: _scheduleProgress,
            lineHeight: 15,
            progressColor: scheduleProgressColor,
          ),
        ],
      );
    }
  }

  Widget _buildCourseInProgressCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${scheduleProgress.courseProgress}%"
          " of video courses completed",
          style: normalResponsiveFont(context, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 15,
        ),
        LinearPercentIndicator(
          backgroundColor: Style.of(context).colors.background3,
          percent: _programProgress,
          lineHeight: 15,
          progressColor: Style.of(context).colors.accent4,
        ),
        SizedBox(
          height: 30,
        ),
        _courseProgressFooter(),
        SizedBox(
          height: 15,
        ),
        _scheduleButton(),
      ],
    );
  }

  Widget _buildCourseCompletedCard() {
    return Container(
      child: Row(
        children: [
          Flexible(
              flex: 2,
              child: Image(
                  image: AssetImage("assets/png/course_completed.png"),
                  height: 50)),
          SizedBox(
            width: 10,
          ),
          Flexible(
              flex: 4,
              child: RichText(
                text: TextSpan(
                  text: 'Congratulations!\n'.toUpperCase(),
                  style:
                      bigResponsiveFont(context, fontWeight: FontWeight.w900),
                  children: <TextSpan>[
                    TextSpan(
                        text: '100% completed'.toUpperCase(),
                        style: bigResponsiveFont(context,
                            fontWeight: FontWeight.w900,
                            fontColor: FontColor.Accent4)),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildCourseLoading() {
    return Padding(
        padding: EdgeInsets.symmetric(
            vertical: whenDevice(
          context,
          medium: 100,
          large: 100,
          tablet: 150,
        )),
        child: Container(
          child: Center(
            child: ProgressBar(),
          ),
        ));
  }

  Widget _buildCourseNotStartedCard() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        NoProgressCard(
            icon: Icons.book_outlined,
            text: "progress_screen.no_progress",
            buttonText: "progress_screen.get_started",
            onTapButton: () async {
              await Navigator.pushNamed(context, Routes.schedule);
              widget.onRefresh();
            })
      ],
    );
  }

  Future<void> update() async {
    setState(() {
      showLoading = true;
    });
    await SuperStateful.of(context).updateCourseProgress(forceApiRequest: true);
    setState(() {
      showLoading = false;
    });
  }
}
