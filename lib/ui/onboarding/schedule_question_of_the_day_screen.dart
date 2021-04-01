import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/onboarding/qotd_notifications.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/notification_helper.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:Medschoolcoach/widgets/app_bars/transparent_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injector/injector.dart';

class ScheduleQuestionOfTheDay extends StatefulWidget {
  final String source;

  ScheduleQuestionOfTheDay({this.source});

  @override
  _ScheduleQuestionOfTheDayState createState() =>
      _ScheduleQuestionOfTheDayState();
}

class _ScheduleQuestionOfTheDayState extends State<ScheduleQuestionOfTheDay> {
  double sliderValue = 12;
  UserManager userManager;
  final AnalyticsProvider _analyticsProvider =
  Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        Routes.scheduleQuestionOfTheDay, widget.source);
    userManager = Injector.appInstance.getDependency<UserManager>();
    userManager.getQuestionOfTheDayTime().then((value) {
      setState(() {
        sliderValue = (value ?? 12).toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(
        leading: (widget.source == Routes.profile_screen)
            ? BackButton(
                color: Colors.black,
              )
            : null,
        actions: widget.source == Routes.profile_screen ?
        [] : [_skipButton(context)],
      ),
      body: _buildBody(),
    );
  }

  Widget _skipButton(BuildContext context) {
    return FlatButton(
        onPressed: () {
          _analyticsProvider.logEvent("tap_question_of_the_day_skip");
          Navigator.pushNamed(context, Routes.home);
        },
        child: Text(
          FlutterI18n.translate(
            context,
            "question_of_the_day.skip",
          ),
          style: bigResponsiveFont(context, fontWeight: FontWeight.w400),
        ));
  }

  Widget _buildBody() {
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            _heading(),
            SizedBox(
              height: 20,
            ),
            _subheading(),
            Spacer(),
            _clock(),
            Spacer(),
            _timeSlider(),
            Spacer(),
            PrimaryButton(
              text: FlutterI18n.translate(
                  context,
                  "general."
                  "${widget.source == Routes.profile_screen ?
                  "save" : "continue"}").toUpperCase(),
              onPressed: () async {
                userManager.updateQuestionOfTheDayTime(sliderValue.toInt());
                final FlutterLocalNotificationsPlugin notifsPlugin =
                FlutterLocalNotificationsPlugin();
                var success = await requestPermissions(notifsPlugin);
                if (success) {
                  // ignore: lines_longer_than_80_chars
                  QuestionOfTheDayNotification.scheduleNotifications(initialSchedulingDate());
                }
                _analyticsProvider.logEvent("tap_question_of_the_day_confirm");
                userManager.markOnboardingComplete();
                if (widget.source == Routes.profile_screen)
                  Navigator.of(context).pop();
                else
                  Navigator.pushNamed(context, Routes.home);
              },
              color: Color(0xff009D7A),
            ),
            SizedBox(
              height: 20,
            ),
            if (widget.source != Routes.profile_screen)
              _message()
            else
              _disableNotificationButton(),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _disableNotificationButton() {
    return TextButton(
        onPressed: () {
          userManager.markOnboardingComplete();
          userManager.removeDailyNotification();
          QuestionOfTheDayNotification.cancelNotifications();
          _analyticsProvider.logEvent("tap_question_of_the_day_skip");
          Navigator.pop(context);
        },
        child: Text(
          FlutterI18n.translate(
              context, "question_of_the_day.i_dont_want_daily_notifications"),
          style: mediumResponsiveFont(context,
              fontColor: FontColor.Content4,
              opacity: 0.6,
              style: TextStyle(decoration: TextDecoration.underline)),
        ));
  }

  Widget _heading() {
    return Text(
      FlutterI18n.translate(context, "question_of_the_day.heading"),
      style: biggerResponsiveFont(context,
          fontWeight: FontWeight.w500, fontColor: FontColor.Accent3),
    );
  }

  Widget _subheading() {
    return Text(
      FlutterI18n.translate(context, "question_of_the_day.subheading"),
      style: bigResponsiveFont(context,
          fontWeight: FontWeight.w400, fontColor: FontColor.Content),
      textAlign: TextAlign.center,
    );
  }

  Widget _clock() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(150),
          gradient: LinearGradient(colors: [
            Style.of(context).colors.accent4,
            Style.of(context).colors.accent3,
          ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
      child: Center(
        child: Container(
          height: 145,
          width: 145,
          decoration: BoxDecoration(
              color: Style.of(context).colors.background,
              borderRadius: BorderRadius.circular(1000)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${getTime()} : 00\n"
                  "${sliderValue == 24 ?
                  "AM" : (sliderValue < 12 ? "AM" : "PM")}",
                  style: bigResponsiveFont(context,
                      fontColor: FontColor.Content,
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int getTime() {
    return sliderValue < 13 ? sliderValue.toInt() : sliderValue.toInt() - 12;
  }

  Widget _timeSlider() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderThemeData(
            thumbColor:  Color(0xff009D7A),
            overlayColor: Color(0xff009D7A).withOpacity(0.1),
            activeTrackColor: Style.of(context).colors.accent,
            inactiveTrackColor: Style.of(context).colors.divider,
          ),
          child: Slider(
            value: sliderValue,
            min: 1,
            max: 24,
            onChanged: (val) {
              setState(() {
                sliderValue = val.floor().toDouble();
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Text(
                FlutterI18n.translate(
                  context,
                  "question_of_the_day.morning",
                ),
                style: smallResponsiveFont(context,
                    fontWeight: FontWeight.w500, fontColor: FontColor.Content4),
              ),
              Spacer(),
              Text(
                FlutterI18n.translate(
                  context,
                  "question_of_the_day.noon",
                ),
                style: smallResponsiveFont(context,
                    fontWeight: FontWeight.w500, fontColor: FontColor.Content4),
              ),
              Spacer(),
              Text(
                FlutterI18n.translate(
                  context,
                  "question_of_the_day.evening",
                ),
                style: smallResponsiveFont(context,
                    fontWeight: FontWeight.w500, fontColor: FontColor.Content4),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _message() {
    return Text(
      FlutterI18n.translate(context, "question_of_the_day.message"),
      textAlign: TextAlign.center,
      style: mediumResponsiveFont(context,
          fontWeight: FontWeight.w400,
          fontColor: FontColor.Content,
          opacity: 0.5),
    );
  }

  DateTime initialSchedulingDate() {
    var currentValue = sliderValue.toInt();
    if (currentValue == 24) {
      currentValue = 0;
    }
    var newHour = currentValue;
    var time = DateTime.now().toLocal();
    // ignore: lines_longer_than_80_chars
    var scheduledTime = DateTime(time.year, time.month, time.day, newHour, 0, 0, 0, 0);
    return scheduledTime;
  }
}
