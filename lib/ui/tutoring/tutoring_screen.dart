import 'dart:io';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/tutoring/tutoring_slider_item.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/external_navigation_utils.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
import 'package:url_launcher/url_launcher.dart';

class TutoringScreenData {
  final String source;
  final bool isNavBar;

  TutoringScreenData({
    @required this.source,
    @required this.isNavBar,
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
  final GlobalKey _scaffoldKey = GlobalKey();

  int _current = 0;
  List<TutoringSlider> _sliders;
  CarouselController carouselController;

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
      bottomNavigationBar: widget.tutoringScreenData.isNavBar
          ? NavigationBar(page: NavigationPage.Tutoring)
          : null,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
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
                                        1.54,
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
                      padding: const EdgeInsets.only(bottom: 10),
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
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: _buildButton(context),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: widget.tutoringScreenData.isNavBar
                ? SizedBox.shrink()
                : _getAppBar(),
          ),
        ],
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
      key: const Key("request info"),
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
        color: Style.of(context).colors.premium,
        onPressed: () async {
          _analyticsProvider.logEvent(AnalyticsConstants.tapRequestInfo,
              params: {
                AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring
              });
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
                child: Column(
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
                    _getRequestInfoDialogButton(
                        "tutoring_request_info_dialog.schedule_a_meeting",
                        _navigateToScheduleAMeeting),
                    _getDivider(),
                    _getRequestInfoDialogButton(
                        "tutoring_request_info_dialog.call_us_now",
                        _openPhoneNumber),
                    _getDivider(),
                    _getRequestInfoDialogButton(
                        "tutoring_request_info_dialog.request_more_info", () {
                      Navigator.of(context).pop();
                      _requestMoreInfo();
                    }),
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
    );
  }

  void _navigateToScheduleAMeeting() {
    _analyticsProvider.logEvent(AnalyticsConstants.tapTutoringScheduleAMeeting,
        params: {
          AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring
        });
    Navigator.of(_scaffoldKey.currentContext).pop();
    ExternalNavigationUtils.openWebsite(
      Config.scheduleMeetingUrl,
    );
  }

  Future _requestMoreInfo() async {
    _analyticsProvider.logEvent(AnalyticsConstants.tapTutoringRequestMoreInfo,
        params: {
          AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring
        });
    final NetworkResponse result = await Injector.appInstance
        .getDependency<ApiServices>()
        .requestTutoringInfo();
    if (result is SuccessResponse<String>) {
      await _showSuccessDialog();
      Navigator.of(_scaffoldKey.currentContext).pop();
    } else {
      if (result is ErrorResponse &&
          result.error is ApiException &&
          (result.error as ApiException).code == 412) {
        await _showSuccessDialog();
      } else {
        await _showErrorDialog();
      }
    }
  }

  Future _showSuccessDialog() {
    return _showDialog("tutoring_modal.request_dialog_header",
        "tutoring_modal.request_dialog_message");
  }

  Future _showErrorDialog() {
    return _showDialog(
        "general.error", "tutoring_modal.request_dialog_error_message");
  }

  Future _showDialog(String header, String body) {
    return showDialog<dynamic>(
      context: _scaffoldKey.currentContext,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            header,
          ),
          content: FlutterI18n.translate(
            context,
            body,
          ),
          actions: <DialogActionData>[
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "tutoring_modal.request_dialog_button",
              ),
              onTap: _openPhoneNumber,
            ),
          ],
        );
      },
    );
  }

  void _openPhoneNumber() {
    Navigator.of(_scaffoldKey.currentContext).pop();
    launch("tel://${Config.supportPhoneNumber}");
    _analyticsProvider.logEvent(AnalyticsConstants.tapTutoringCallUs, params: {
      AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring
    });
  }

  Future<void> _fetchSliders() async {
    final result =
        await SuperStateful.of(context).updateTutoringSlider(context);
    setState(() {
      _sliders = result;
    });
  }
}
