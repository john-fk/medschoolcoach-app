import 'dart:io';

import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/tutoring/tutoring_slider_item.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class TutoringScreenData {
  final String source;
  final bool showNavigationBar;

  TutoringScreenData({
    @required this.source,
    @required this.showNavigationBar,
  });
}

class TutoringScreen extends StatefulWidget {
  final TutoringScreenData tutoringScreenData;
  const TutoringScreen(this.tutoringScreenData);

  @override
  _TutoringScreenPageState createState() => _TutoringScreenPageState();
}

class _TutoringScreenPageState extends State<TutoringScreen> {
  final AnalyticsProvider _analyticsProvider =
  Injector.appInstance.getDependency<AnalyticsProvider>();
  final userRepository = Injector.appInstance.getDependency<UserRepository>();
  final GlobalKey _scaffoldKey = GlobalKey();
  bool checked = false;
  int _current = 0;
  List<TutoringSlider> _sliders;
  CarouselController carouselController;
  int isLoading = -1;

  @override
  void initState() {
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenTutoring, widget.tutoringScreenData.source);
    carouselController = CarouselController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSliders());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _sliders = SuperStateful.of(context).tutoringSliders;

    return Scaffold(
      bottomNavigationBar: widget.tutoringScreenData.showNavigationBar
          ? NavigationBar(page: NavigationPage.Tutoring)
          : null,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Center(
                              child: CarouselSlider(
                                carouselController: carouselController,
                                items: _sliders
                                    .map((item) =>
                                    TutoringSliderItem(sliderModel: item))
                                    .toList(),
                                options: CarouselOptions(
                                    autoPlay: true,
                                    viewportFraction: 1.0,
                                    height: MediaQuery.of(context).size.height /
                                        1.94,
                                    onPageChanged: (index, reason) {
                                      try {
                                        if (ModalRoute.of(context).isCurrent) {
                                          _analyticsProvider.logEvent(
                                              AnalyticsConstants
                                                  .swipeTutoringSlider,
                                              params: {
                                                AnalyticsConstants.keyPageIndex:
                                                index
                                              });
                                          setState(() {
                                            _current = index;
                                          });
                                        }
                                      } catch (err) {
                                        print(err);
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: _sliders.map((url) {
                            int index = _sliders.indexOf(url);
                            final enabledDotSize = whenDevice(
                              context,
                              small: 10.0,
                              large: 13.0,
                              tablet: 14.0,
                            );
                            final disabledDotSize = whenDevice(
                              context,
                              small: 8.0,
                              large: 10.0,
                              tablet: 11.0,
                            );
                            return Container(
                              width: _current == index
                                  ? enabledDotSize
                                  : disabledDotSize,
                              height: _current == index
                                  ? enabledDotSize
                                  : disabledDotSize,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _current == index
                                    ? Style.of(context).colors.accent3
                                    : Style.of(context)
                                    .colors
                                    .accent3
                                    .withAlpha(25),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Container(
                                      margin: EdgeInsets.fromLTRB(
                                          2.5, 2, 2.5, 15),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height : mediumResponsiveFont(context).fontSize * 1.2,
                                          width : mediumResponsiveFont(context).fontSize * 3,
                                          child:(
                                                Image(image:
                                                AssetImage(checked ?
                                                    Style.of(context).pngAsset.tutoringChecked:
                                                    Style.of(context).pngAsset.tutoringUnchecked),
                                                fit:BoxFit.fitHeight)
                                              )
                                          ),
                                          AutoSizeText(
                                              FlutterI18n.translate(context,
                                                  "tutoring_sliders.qualifier"),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              style: mediumResponsiveFont(
                                                context,
                                                fontColor: FontColor.QualifyingText,
                                                fontWeight: FontWeight.w400,
                                              )
                                          ),
                                        ])
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          checked = !checked;
                                        });
                                      },
                                    ),
                                    _buildButton(context),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: !widget.tutoringScreenData.showNavigationBar
                ? closeButton()
                : _getAppBar(),
          ),
        ],
      ),
    );
  }

  Widget closeButton() {
    return SafeArea(
      child: CloseButton(
        color: Colors.black,
        key: Key("dialog close"),
        onPressed: () {
          Navigator.of(_scaffoldKey.currentContext).pop();
        },
      ),
    );
  }

  Widget _getAppBar() {
    return Container(
      height: whenDevice(
        context,
        medium: Platform.isAndroid ? 85 : 80,
        large: 120,
        tablet: 120,
      ),
      child: Center(
        child: CustomAppBar(
          title: FlutterI18n.translate(
            context,
            "common.tutoring",
          ),
          padding: EdgeInsets.only(
              top: whenDevice(
                context,
                medium: 15,
                large: 25,
                tablet: 30,
              ),
              bottom: whenDevice(
                context,
                medium: 5,
                large: 5,
                tablet: 10,
              )),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      key: const Key("explore tutoring options"),
      width: double.infinity,
      height: whenDevice(context, small: 35, large: 40, tablet: 60),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            whenDevice(
              context,
              large: 25,
              tablet: 35,
            ),
          ),
        ),
        color: Color(0xFF009D7A),
        onPressed: () async {
          _flagForTutoringUpsell();
          _sendRequestInfo();
        },
        child: Text(
          FlutterI18n.translate(context, "tutoring_modal.button"),
          style: normalResponsiveFont(
            context,
            fontColor: FontColor.Content2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future _sendRequestInfo() async {
    Widget _getRequestInfoDialogButton(String text, Function onTap) {
      return InkWell(
          child: Container(
              height: 50,
              child: Center(
                child: Text(FlutterI18n.translate(context, text),
                    textAlign: TextAlign.center,
                    style: mediumResponsiveFont(context,
                        fontColor: FontColor.Accent3)),
              )),
          onTap: onTap);
    }

    Widget _getDivider() {
      return Divider(height: 1, color: Style.of(context).colors.separator);
    }

    showDialog<dynamic>(
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return Dialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 19),
                          child: Text(
                              FlutterI18n.translate(context,
                                  "tutoring_request_info_dialog.dialog_header"),
                              textAlign: TextAlign.center,
                              style: biggerResponsiveFont(
                                context,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        _getDivider(),
                        isLoading==0 ? ProgressBar() :
                        _getRequestInfoDialogButton(
                            "tutoring_request_info_dialog.call_us_now",
                            _openPhoneNumber),
                        _getDivider(),
                        isLoading==1 ? ProgressBar() :
                        _getRequestInfoDialogButton(
                            "tutoring_request_info_dialog.schedule_a_meeting",
                            _navigateToScheduleAMeeting),
                      ],
                    ),
                    Positioned(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CloseButton(
                          color: Colors.black,
                          key: Key("dialog close"),
                          onPressed: () {
                            Navigator.of(_scaffoldKey.currentContext).pop();
                          },
                        ),
                      ),
                      right: 0.0,
                      top: -15.0,
                    ),
                  ],
                ),
              )
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    ).then((dynamic result) {
      if (result != "success") {
        _sendTutoringUpsellAnalytics(isSuccess: true);
        Navigator.of(_scaffoldKey.currentContext).pop();
      }
    });
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future _navigateToScheduleAMeeting() async {
    setState(() {
        isLoading = 1;
    });
    await reportClick();
    _analyticsProvider.logEvent(AnalyticsConstants.tapTutoringScheduleAMeeting,
        params: {
          AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring
        });
    Navigator.of(_scaffoldKey.currentContext).pop("success");
    setState(() {
      isLoading = -1;
    });
    await launchURL(Config.scheduleMeetingUrl);
  }

  Future reportClick() async{
    await Injector.appInstance
        .getDependency<ApiServices>()
        .requestForTutoringUpsell(checked);
  }
  Future _flagForTutoringUpsell() async {

    _analyticsProvider
        .logEvent(AnalyticsConstants.tapExploreOptions, params: {
      AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring,
      AnalyticsConstants.keyType: "button",
    });
  }

  void _sendTutoringUpsellAnalytics({bool isSuccess = false}) {
    _analyticsProvider
        .logEvent(AnalyticsConstants.tapTutoringInfoModalDismiss, params: {
      AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring,
      AnalyticsConstants.keyIsSuccess: isSuccess
    });
  }

  void _openPhoneNumber() {
    setState(() {
      isLoading = 0;
    });
    reportClick();
    _analyticsProvider.logEvent(AnalyticsConstants.tapTutoringCallUs, params: {
      AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring,
      AnalyticsConstants.keyEmail: userRepository.userLoggingEmail,
    });
    setState(() {
      isLoading = -1;
    });
    Navigator.of(_scaffoldKey.currentContext).pop("success");
    launch("tel://${Config.supportPhoneNumber}");
  }

  Future<void> _fetchSliders() async {
    final result =
    await SuperStateful.of(context).updateTutoringSlider(context);
    setState(() {
      _sliders = result;
    });
  }
}
