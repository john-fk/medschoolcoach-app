import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/tutoring/tutoring_slider_item.dart';
import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

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

  int _current = 0;
  List<TutoringSlider> _sliders;
  bool _loading = false;
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
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 9,
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
                                  height:
                                      MediaQuery.of(context).size.height/1.5,
                                  onPageChanged: (index, reason) {
                                    try {
                                      if (ModalRoute.of(context).isCurrent) {
                                        //TODO:Log Analytis
                                        // AnalyticsProvider.logEvent(
                                        //     name:
                                        //     "swiped_subscription_carousel",
                                        //     parameters: {
                                        //       AnalyticsProvider
                                        //           .genericParamName: "$index"
                                        //     });
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _sliders.map((url) {
                      int index = _sliders.indexOf(url);
                      return Container(
                        width: _current == index ? 13 :  10,
                        height: _current == index ? 13 :  10,
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Colors.blue
                              : Colors.lightBlue,
                        ),
                      );
                    }).toList(),
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
          )),
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

  }

  void _handleButtonClick() {}

  Future<void> _fetchSliders() async {
    setState(() {
      _loading = true;
    });
    final result =
        await SuperStateful.of(context).updateTutoringSlider(context);

    setState(() {
      _loading = false;
      _sliders = result;
    });
  }
}
