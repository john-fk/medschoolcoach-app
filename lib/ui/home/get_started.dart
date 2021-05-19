import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/home/home_section.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class GetStarted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final width = MediaQuery.of(context).size.width - 24;
    return HomeSection(
      sectionTitle: FlutterI18n.translate(
        context,
        "home_screen.get_started",
      ),
      sectionWidget: Material(
        child: InkWell(
          onTap: () {
            _goToSchedule(context);
          },
          child: Stack(
          children: <Widget>[
            Container(
              height:  whenDevice(context,
                  large: 150,
                  tablet: 280),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Style.of(context).colors.accent,
              ),
            ),
            Positioned(
              right: width * 0.01,
              bottom: 0,
              child: Image(image: AssetImage(Style.of(context).
                  pngAsset.globalDoctors),
                  height: whenDevice(context,
                  large: size.height * 0.15,
                  tablet: size.height * 0.25),
                fit: BoxFit.cover,
            )),
            Positioned(
              left: width * 0.01,
              top: 0,
              bottom: 0,
              right: width * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, "home_screen.pick_schedule"),
                    style: bigResponsiveFont(context,
                          fontColor: FontColor.Content2),
                    textAlign: TextAlign.center,
                  ),
                  SecondaryButton(
                    margin: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      top: width * 0.05,
                    ),
                    onPressed: () {
                              _goToSchedule(context);
                            },
                    text: FlutterI18n.translate(
                      context,
                      "home_screen.get_started",
                    ),
                  )
                ],
              ),
            )
          ]),
        )
      )
    );
  }

    void _goToSchedule(BuildContext context) {
      Injector.appInstance.getDependency<AnalyticsProvider>()
          .logEvent(AnalyticsConstants.tapGetStarted);
      Navigator.of(context).pushNamed(
      Routes.schedule,
      arguments: AnalyticsConstants.screenHome
    );
  }
}
