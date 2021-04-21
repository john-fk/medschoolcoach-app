import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

// ignore: must_be_immutable
class UpsellBanner extends StatelessWidget {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final height = size.height / 4.4;
    return GestureDetector(
      onTap: () {
        Injector.appInstance.getDependency<AnalyticsProvider>()
            .logEvent("tap_tutoring_upsell_section", params: null);
        Routes.navigateToTutoringScreen(
              context, AnalyticsConstants.screenTutoring,
              isNavBar: false);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Style.of(context).colors.accent,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: whenDevice(context,
            small: height * 1.25, medium: height, large: height),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FlutterI18n.translate(
                            context, "upsell_banner.banner_text"),
                        style: bigResponsiveFont(context,
                            fontColor: FontColor.Content2),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: FlatButton(
                          onPressed: () {
                            Injector.appInstance
                                .getDependency<AnalyticsProvider>()
                                .logEvent("tap_tutoring_upsell_section",
                                params: null);
                            Routes.navigateToTutoringScreen(
                                context, AnalyticsConstants.screenTutoring,
                                isNavBar: false);
                          },
                          padding:
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                          color: Style.of(context).colors.background,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            FlutterI18n.translate(
                              context,
                              "upsell_banner.button_text",
                            ),
                            style: bigResponsiveFont(context,
                                fontColor: FontColor.Accent,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Image(
                    image: AssetImage(
                        Style.of(context).pngAsset.upSellBannerGraphic),
                    height: height,
                    fit: BoxFit.contain,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
