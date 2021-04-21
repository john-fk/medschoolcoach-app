import 'dart:ui';

import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class NewUserOnboarding extends StatefulWidget {
  @override
  _NewUserOnboardingState createState() => _NewUserOnboardingState();
}

class _NewUserOnboardingState extends State<NewUserOnboarding> {
  final AnalyticsProvider _analyticsProvider =
  Injector.appInstance.getDependency<AnalyticsProvider>();

  CarouselController carouselController;
  List<String> banners = [
    "assets/png/onboarding_banner1.png",
    "assets/png/onboarding_banner2.png",
    "assets/png/onboarding_banner3.png",
    "assets/png/onboarding_banner4.png",
  ];

  List<List<String>> messages = [
    [
      "new_user_onboarding.get_access_to",
      " 100+ ",
      "new_user_onboarding.extensive_lessons_from_top_medical_experts"
    ],
    [
      "new_user_onboarding.practice_with",
      " 1000+ ",
      "new_user_onboarding.flashcards_and_question"
    ],
    [
      "new_user_onboarding.pace_your_own_schedule",
      "new_user_onboarding.adjust_anytime",
      ""
    ],
    [
      "new_user_onboarding.track_and_speed_progress",
      "new_user_onboarding.we_are_just_a_call_away",
      ""
    ]
  ];

  int sliderIndex = 0;

  Size size;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(Routes.newUserOnboardingScreen, null);
    carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: size.width * 0.9,
            child: Column(
              children: [
                Spacer(),
                Text(
                  FlutterI18n.translate(context, "new_user_onboarding.heading"),
                  style:
                      biggerResponsiveFont(context,
                          fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                CarouselSlider(
                  carouselController: carouselController,
                  items: [0, 1, 2, 3].map(carouselItem).toList(),
                  options: CarouselOptions(
                    initialPage: sliderIndex,
                    onPageChanged: (val, _) {
                      setState(() {
                        sliderIndex = val;
                      });
                    },
                    autoPlay: false,
                    pauseAutoPlayInFiniteScroll: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
                    height: MediaQuery.of(context).size.height / 1.9,
                  ),
                ),
                Spacer(),
                _sliderIndicator(),
                Spacer(),
                PrimaryButton(
                  text: FlutterI18n.translate(
                      context, "new_user_onboarding.explore_our_features"),
                  onPressed: () {
                    Navigator.pushNamed(context,
                        Routes.scheduleTestDate, arguments: Routes.onboarding);
                  },
                  color: Style.of(context).colors.accent4,
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sliderIndicator() {
    return Center(
      child: SizedBox(
        width: whenDevice(
          context, 
          small: size.width * 0.2,
          large: size.width * 0.2,
          tablet: size.width * 0.15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [0, 1, 2, 3]
              .map((index) => CircleAvatar(
                  radius: sliderIndex == index
                      ? whenDevice(
                          context,
                          small: 6.0,
                          large: 6.0,
                          tablet: 10.0,
                        )
                      : whenDevice(
                          context,
                          small: 4.0,
                          large: 4.0,
                          tablet: 8.0,
                        ),
                  backgroundColor: Style.of(context)
                      .colors
                      .accent
                      .withOpacity(index == sliderIndex ? 1 : 0.5)))
              .toList(),
        ),
      ),
    );
  }

  Widget carouselItem(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: FlutterI18n.translate(context, messages[index][0]),
              style: biggerResponsiveFont(context,
                  fontColor: FontColor.Accent, fontWeight: FontWeight.w500),
              children: <TextSpan>[
                TextSpan(
                    text: FlutterI18n.translate(context, messages[index][1]),
                    style: biggerResponsiveFont(context,
                        fontColor: FontColor.Accent4,
                        fontWeight: FontWeight.w700)),
                TextSpan(
                    text: FlutterI18n.translate(context, messages[index][2])),
              ],
            ),
          ),
        ),
        Image(image: AssetImage(banners[index]),
          height: size.height * 0.3,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
