import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:Medschoolcoach/ui/onboarding/qotd_notifications.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:Medschoolcoach/widgets/app_bars/transparent_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
import 'local_notification.dart';

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
  int  isLoading = -1;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        Routes.scheduleQuestionOfTheDay, widget.source);
    userManager = Injector.appInstance.getDependency<UserManager>();
    userManager.getQuestionOfTheDayTime().then((value) {
      if (value == 0) value = 24;
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
          userManager.markOnboardingComplete();
          _analyticsProvider.logEvent(AnalyticsConstants.tapQOTDSkip,
              params: null);
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
              isLoading : isLoading == 1,
              text: FlutterI18n.translate(
                  context,
                  "general."
                  "${widget.source == Routes.profile_screen ?
                  "save" : "continue"}").toUpperCase(),
              onPressed: () async {
                  _updateAction(isSet:true);
              },
              color: Color(0xff009D7A),
            ),
            SizedBox(
              height: 20,
            ),
            if (isLoading == 0)
              ProgressBar()
            else if (widget.source != Routes.profile_screen)
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
        onPressed: () async {
          _updateAction(isSet:false);
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
          fontWeight: FontWeight.w500,
          fontColor: FontColor.Accent3),
      textAlign: TextAlign.center,
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
            activeTrackColor: Style.of(context).colors.divider,
            inactiveTrackColor: Style.of(context).colors.divider,
          ),
          child:
          AbsorbPointer(
            absorbing: isLoading > -1,
            child:Slider(
              value: sliderValue,
              min: 1,
              max: 24,
              onChanged: (val) {
                setState(() {
                  sliderValue = val.floor().toDouble();
                });
              },
            )
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

  Future<void> _updateAction({bool isSet}) async{
    if (isLoading > -1) return;

    setState(() {
      isLoading = isSet ? 1 : 0;
    });

    NetworkResponse<bool> result;

    if (isSet){
      result = await Injector.appInstance
          .getDependency<ApiServices>()
          .setQoD("${ sliderValue.toInt() == 24 ? "00"
          : sliderValue.toInt().toString()}0000");
    } else {
      result = await Injector.appInstance
          .getDependency<ApiServices>()
          .setQoD(null);
    }

    Fluttertoast.cancel();

    if (result is ErrorResponse) {
      Fluttertoast.showToast(
          msg: FlutterI18n.translate(context, "general.net_error"),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Style.of(context).colors.error);
    } else {
      if (isSet) {
        _analyticsProvider.logEvent(AnalyticsConstants.tapQOTDConfirm,
            params: null);

        LocalNotification().setReminder(sliderValue.toInt().toString(),userManager);

        if (widget.source == Routes.profile_screen)
          Navigator.of(context).pop();
        else
          Navigator.pushNamed(context, Routes.home);
      } else {
        userManager.markOnboardingComplete();
        userManager.removeDailyNotification();
        await QuestionOfTheDayNotification.cancelNotifications();
        _analyticsProvider.logEvent(AnalyticsConstants.tapQOTDSkip,
            params: null);
        Navigator.pop(context);
      }
    }

    setState(() {
      isLoading = -1;
    });

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

}
