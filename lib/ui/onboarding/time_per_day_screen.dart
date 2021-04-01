import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/schedule_repository.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/estimate_schedule.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/utils/toasts.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:Medschoolcoach/widgets/app_bars/transparent_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
import 'package:Medschoolcoach/utils/format_date.dart';

class TimePerDay extends StatefulWidget {
  final String source;
  final DateTime scheduleDate;

  TimePerDay({this.source = "", this.scheduleDate});

  @override
  _TimePerDayState createState() => _TimePerDayState();
}

class _TimePerDayState extends State<TimePerDay> {
  Size size;
  UserManager userManager;
  int timePerDay;
  bool loading = false;
  bool _initialLoad = false;
  ApiServices apiServices;
  Future<EstimateSchedule> getEstimateCompletion;
  final ScheduleRepository _scheduleRepository =
      Injector.appInstance.getDependency<ScheduleRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _initialLoad = true;
    });
    _analyticsProvider.logScreenView(Routes.timePerDay, widget.source);
    apiServices = Injector.appInstance.getDependency<ApiServices>();
    userManager = Injector.appInstance.getDependency<UserManager>();
    getEstimateCompletion = apiServices.getEstimateCompletion();
    userManager?.getStudyTimePerDay()?.then((value) {
      if (value != null)
        setState(() {
          timePerDay = value ?? 2;
          _initialLoad = false;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TransparentAppBar(
          leading: BackButton(
            color: Colors.black,
          ),
        ),
        body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    size = MediaQuery.of(context).size;

    if (_initialLoad) {
      return Center(
        child: ProgressBar(),
      );
    }
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/png/schedule_picker.png"),
              height:
                  isTablet(context) ? size.height * 0.30 : size.height * 0.20,
              fit: BoxFit.cover,
            ),
            Spacer(),
            _heading(),
            SizedBox(
              height: size.height * 0.03,
            ),
            _subheading(),
            Spacer(),
            _hoursSelector(),
            Spacer(),
            PrimaryButton(
              isLoading: loading,
              text: loading
                  ? FlutterI18n.translate(context, "general.updating")
                  : FlutterI18n.translate(context, "general.confirm")
                      .toUpperCase(),
              onPressed: _updateTimePerDay,
              color: Style.of(context).colors.accent4,
            ),
            FutureBuilder<EstimateSchedule>(
                future: getEstimateCompletion,
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return SizedBox(
                      height: 30,
                    );
                  }
                  int days = snapshot.data.estimate[timePerDay.toString()];
                  String formattedDate = formatDate(
                      DateTime.now().add(Duration(days: days)), 'MM/dd/yyyy');
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Text(
                      FlutterI18n.translate(context,
                              // ignore: lines_longer_than_80_chars
                              "onboarding_scheduling.expected_completion_date") +
                          " $formattedDate",
                      style: smallResponsiveFont(context,
                          fontColor: FontColor.Accent, opacity: 0.6),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _updateTimePerDay() async {
    setState(() {
      loading = true;
    });
    final result = await apiServices.setTimePerDay(timePerDay);
    if (result is ErrorResponse) {
      showToast(
          text: "Something went wrong, please try again",
          context: context,
          color: Style.of(context).colors.error);
    } else {
      _analyticsProvider.logEvent("tap_confirm_study_time",
          params: {"hours_per_day": timePerDay.toString()});
      userManager.updateStudyTimePerDay(timePerDay);
      await _scheduleRepository.clearCache();
      if (widget.source != Routes.onboarding)
        Navigator.of(context).pop();
      else {
        await apiServices.setOnboarded();
        await Navigator.pushNamed(context, Routes.scheduleQuestionOfTheDay,
            arguments: Routes.onboarding);
      }
    }
  }

  Widget _heading() {
    String heading = "onboarding_scheduling.heading2";
    return Text(
      FlutterI18n.translate(context, heading),
      style: biggerResponsiveFont(context,
          fontWeight: FontWeight.w500, fontColor: FontColor.Accent3),
      textAlign: TextAlign.center,
    );
  }

  Widget _subheading() {
    String subheading = "onboarding_scheduling.subheading2";
    return Text(
      FlutterI18n.translate(context, subheading),
      style: bigResponsiveFont(context,
          fontWeight: FontWeight.w400, fontColor: FontColor.Content),
      textAlign: TextAlign.center,
    );
  }

  Widget _hoursSelector() {
    var initialItem = timePerDay == null ? 0 : ((timePerDay / 2) - 1)?.toInt();
    return Container(
      height: size.height * 0.15,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(),
          Expanded(
            child: CupertinoTheme(
              data: CupertinoThemeData(
                  primaryContrastingColor: Colors.transparent,
                  barBackgroundColor: Colors.transparent),
              child: CupertinoPicker(
                  itemExtent: whenDevice(context, large: 30, tablet: 40),
                  diameterRatio: 1,
                  useMagnifier: false,
                  onSelectedItemChanged: (val) {
                    print(val);
                    setState(() {
                      timePerDay = (val + 1) * 2;
                    });
                  },
                  scrollController:
                      FixedExtentScrollController(initialItem: initialItem),
                  looping: false,
                  children: List.generate(4, (index) {
                    var value = (index + 1) * 2;
                    var shownValue = value == 8 ? "8+" : value;
                    return Text(
                      "$shownValue",
                      style: biggerResponsiveFont(context,
                          fontWeight: FontWeight.w400,
                          fontColor: FontColor.Content),
                    );
                  })),
            ),
          ),
          Expanded(
              child: Text(
            FlutterI18n.translate(context, "onboarding_scheduling.hr_per_day"),
            style: normalResponsiveFont(context,
                fontWeight: FontWeight.w400, fontColor: FontColor.Content),
          )),
          Spacer()
        ],
      ),
    );
  }
}
