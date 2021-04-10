import 'package:Medschoolcoach/utils/api/models/schedule_stats.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/cards/no_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:Medschoolcoach/utils/format_date.dart';

class CourseProgressCard extends StatefulWidget {
  final ScheduleStats scheduleProgress;
  final VoidCallback onRefresh;

  CourseProgressCard({this.scheduleProgress, this.onRefresh});

  @override
  _CourseProgressCardState createState() => _CourseProgressCardState();
}

class _CourseProgressCardState extends State<CourseProgressCard>
    with SingleTickerProviderStateMixin {
  double _programProgress = 0.0;
  double _scheduleProgress = 0.0;
  Animation<double> animation;
  AnimationController controller;
  bool isOnTrack;
  Color scheduleProgressColor;
  int currentDay;
  int totalDays;
  double scheduleProgressPercent;
  bool failedToCompleteSchedule;
  bool hasStarted;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    currentDay = widget.scheduleProgress.currentDay;
    totalDays = currentDay + widget.scheduleProgress.daysLeft;
    scheduleProgressPercent = currentDay / totalDays;

    hasStarted = widget.scheduleProgress.courseProgress > 0 &&
        scheduleProgressPercent > 0;

    failedToCompleteSchedule = widget.scheduleProgress.daysLeft == 0
        && widget.scheduleProgress.courseProgress != 1;

    var actualCompletionDate =
    DateTime.parse(widget.scheduleProgress.actualCompletionDate);
    var currentCompletionDate = DateTime.now()
        .add(Duration(days: widget.scheduleProgress.daysLeft));
    isOnTrack = currentCompletionDate.isBefore(actualCompletionDate);

    Future.delayed(Duration(milliseconds: 350), () {
      animation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(curve: Curves.easeInOutQuart, parent: controller))
        ..addListener(() {
          setState(() {
            _programProgress =
                animation.value * widget.scheduleProgress.courseProgress / 100;
            _scheduleProgress = animation.value * scheduleProgressPercent;
          });
        });
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scheduleProgressColor = isOnTrack
        ? Style.of(context).colors.accent4
        : Style.of(context).colors.questions;
    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: hasStarted
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
              child: _programProgress == 1
                  ? _buildCourseCompletedCard()
                  : _buildCourseInProgressCard()
            )
          : _buildCourseNotStartedCard(),
    );
  }

  Widget _scheduleButton() {
    if (failedToCompleteSchedule) {
      return
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: PrimaryButton(text: "Update My Schedule",
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Routes.timePerDay,
                  arguments: Routes.progressScreen);
              },
      ),
        );
    } else {
      return
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: PrimaryButton(text: "View My Schedule",
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(Routes.schedule, arguments: Routes.progressScreen);
            },
          ),
        );
    }
  }

  Widget _courseProgressFooter() {
    var progressText = isOnTrack
        ? "Keep going, you're making progress"
        : "You're behind schedule!";

    if (failedToCompleteSchedule) {
      return
        Text("But you've fallen behind schedule",
        style: smallResponsiveFont(context, fontColor: FontColor.BannerOrange),
      );
    } else {
      return
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                progressText,
                style: normalResponsiveFont(context,
                    fontWeight: FontWeight.w600),
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
                    formatDate(DateTime.now()
                        .add(Duration(
                        days: widget.scheduleProgress.daysLeft)), 'MM/dd/yyyy'),
                    style: smallResponsiveFont(context,
                        fontWeight: FontWeight.w500),
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
                    "${widget.scheduleProgress.daysLeft} days",
                    style: smallResponsiveFont(context,
                        fontWeight: FontWeight.w500),
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
          "${widget.scheduleProgress.courseProgress}% "
              " of video courses completed",
          style: normalResponsiveFont(context,
              fontWeight: FontWeight.w600),
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
              child: Image(image: AssetImage("assets/png/course_completed.png"),
                height: 50)),
          SizedBox(
            width: 10,
          ),
          Flexible(
              flex: 4,
              child: RichText(
                text: TextSpan(
                  text: 'Congratulations!'.toUpperCase(),
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
}
