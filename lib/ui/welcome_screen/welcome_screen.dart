import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/onboarding/onboarding_state.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/auth_service.dart';
import 'package:Medschoolcoach/utils/api/models/schedule_date_response.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:Medschoolcoach/widgets/buttons/secondary_button.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/text_button.dart';
import 'package:Medschoolcoach/ui/onboarding/schedule_question_of_the_day_screen.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';
import 'package:Medschoolcoach/ui/onboarding/local_notification.dart';
import 'package:Medschoolcoach/utils/api/models/profile_user.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:universal_io/io.dart';
import 'dart:core';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  final AuthServices _authService =
      Injector.appInstance.getDependency<AuthServices>();

  bool loading = false;
  String QOTD = null;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenWelcome, AnalyticsConstants.screenWelcome);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Config.showSwitch
        ? Scaffold(
            drawer: Drawer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Production API : "),
                  Checkbox(
                    value: Config.switchValue,
                    onChanged: (value) {
                      Config.switchValue = !Config.switchValue;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  width: screenWidth,
                  height: screenHeight,
                  child: SvgPicture.asset(
                    Style.of(context).svgAsset.welcomeScreenBackground,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: -3.65 * screenWidth,
                  left: -1.5 * screenWidth,
                  child: Container(
                    width: 4 * screenWidth,
                    height: 4 * screenWidth,
                    decoration: BoxDecoration(
                      color: Style.of(context).colors.background,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
                  margin: EdgeInsets.only(top: screenWidth * 0.1),
                  child: Image.asset(
                    Style.of(context).pngAsset.logo,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: screenWidth * 0.34),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.07),
                        child: Text(
                          FlutterI18n.translate(
                              context, "welcome_screen.header"),
                          textAlign: TextAlign.center,
                          style: Style.of(context)
                              .font
                              .normal2
                              .copyWith(fontSize: screenWidth * 0.07),
                        ),
                      ),
                      SvgPicture.asset(
                        Style.of(context).svgAsset.manOnBooks,
                        height: screenHeight * 0.3,
                      ),
                      Column(
                        children: <Widget>[
                          SecondaryButton(
                            key: const Key("go_register_button"),
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.07),
                            text: FlutterI18n.translate(
                                    context, "welcome_screen.register"),
                            onPressed: () => _navigateToAuth(false),
                          ),
                          const SizedBox(height: 5),
                          MSCTextButton(
                            key: const Key("go_login_button"),
                            text: FlutterI18n.translate(
                                    context, "welcome_screen.login"),
                            onPressed: () => _navigateToAuth(true),
                            secondaryButton: true,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : loading
            ? Material(
                child: Center(
                child: ProgressBar(),
              ))
            : Scaffold(
                body: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Container(
                      width: screenWidth,
                      height: screenHeight,
                      child: SvgPicture.asset(
                        Style.of(context).svgAsset.welcomeScreenBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -3.65 * screenWidth,
                      left: -1.5 * screenWidth,
                      child: Container(
                        width: 4 * screenWidth,
                        height: 4 * screenWidth,
                        decoration: BoxDecoration(
                          color: Style.of(context).colors.background,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.18),
                      margin: EdgeInsets.only(top: screenWidth * 0.1),
                      child: Image.asset(
                        Style.of(context).pngAsset.logo,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenWidth * 0.34),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.07),
                            child: Text(
                              FlutterI18n.translate(
                                  context, "welcome_screen.header"),
                              textAlign: TextAlign.center,
                              style: Style.of(context)
                                  .font
                                  .normal2
                                  .copyWith(fontSize: screenWidth * 0.07),
                            ),
                          ),
                          SvgPicture.asset(
                            Style.of(context).svgAsset.manOnBooks,
                            height: screenHeight * 0.3,
                          ),
                          Column(
                            children: <Widget>[
                              SecondaryButton(
                                key: const Key("go_register_button"),
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.07),
                                text: FlutterI18n.translate(
                                    context, "welcome_screen.register"),
                                onPressed: () {
                                  _navigateToAuth(false);
                                },
                              ),
                              const SizedBox(height: 5),
                              MSCTextButton(
                                key: const Key("go_login_button"),
                                text: FlutterI18n.translate(
                                    context, "welcome_screen.login"),
                                onPressed: () {
                                  _navigateToAuth(true);
                                },
                                secondaryButton: true,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
  }

  void _navigateToAuth(bool isLogin) async {
    if (loading) return;
    //toggle loading
    setState(() {
      loading = true;
    });
    //Fluttertoast.cancel();

        _analyticsProvider.logScreenView("screen_auth", Routes.welcome);
        var response = await _authService.loginAuth0(isLogin);

        var eventName =
            isLogin ? AnalyticsConstants.signIn : AnalyticsConstants.signUp;
        _analyticsProvider
            .logEvent(eventName, params: {"network": response.network});

        UserManager userManager =
            Injector.appInstance.getDependency<UserManager>();

        if (await shouldShowOnboarding()) {
          if (isLogin) {
            userManager
                .markOnboardingState(OnboardingState.ShowForExistingUser);
            Navigator.pushNamed(context, Routes.oldUserOnboarding);
          } else {
            userManager.markOnboardingState(OnboardingState.ShowForNewUser);
            Navigator.pushNamed(context, Routes.newUserOnboardingScreen);
          }
        } else {
          Future.wait([
            this.fetchAndStoreMcatTestDate(),
            this.fetchAndStoreNumberOfHoursPerDay()
          ]);

          userManager.markOnboardingComplete();

          if (QOTD == null) {
            Navigator.pushNamed(context, Routes.scheduleQuestionOfTheDay,
                arguments: Routes.welcome);
          } else {
            LocalNotification().setReminder(QOTD,userManager);
            Navigator.pushNamed(context, Routes.home,
                arguments: Routes.welcome);
          }
        }
        setState(() {
          loading = false;
        });
  }

  Future<bool> shouldShowOnboarding() async {
    ApiServices apiServices = Injector.appInstance.getDependency<ApiServices>();
    var data = await apiServices.getAccountData();
    final hasOnboarded = data?.onboarded ?? false;
    QOTD = data?.qotd;

    return !hasOnboarded;
  }

  Future<void> fetchAndStoreMcatTestDate() async {
    var response = await Injector.appInstance
        .getDependency<UserRepository>()
        .getProfileUser();
    if (response is RepositorySuccessResult<ProfileUser>) {
      var user = response.data;
      var testDate = user.mcatTestDate;
      if (testDate != null) {
        Injector.appInstance
            .getDependency<UserManager>()
            .updateTestDate(testDate);
      }
    }
  }

  Future<void> fetchAndStoreNumberOfHoursPerDay() async {
    var apiServices = Injector.appInstance.getDependency<ApiServices>();
    final response = await apiServices.getScheduleDate();
    var userManager = Injector.appInstance.getDependency<UserManager>();
    if (response is SuccessResponse<ScheduleDateResponse>) {
      var hours = response.body.hours;
      if (hours != null) {
        userManager.updateStudyTimePerDay(int.parse(hours));
      } else {
        FirebaseCrashlytics.instance
            .log("Client expected onboarded to be true but data was invalid");
        await apiServices.setTimePerDay(2);
        userManager.updateStudyTimePerDay(2);
      }
    }
  }
}
