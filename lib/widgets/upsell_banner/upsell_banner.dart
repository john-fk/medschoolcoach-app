import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
import 'package:auto_size_text/auto_size_text.dart';

// ignore: must_be_immutable
class UpsellBanner extends StatelessWidget {
  Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final height = size.height / 8;
    return
      Container(
        padding: EdgeInsets.symmetric(vertical:10),
      height: whenDevice(context,
          small: height * 1.25, medium: height, large: height),
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.1),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Image(
                    image: AssetImage(
                        Style.of(context).pngAsset.progressTutor),
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width:10),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    AutoSizeText(
                        FlutterI18n.translate(
                          context,
                          "progress_screen.tutor_title",
                        ),
                      maxLines:1,
                      minFontSize: 0,
                      stepGranularity: 0.1,
                      textAlign: TextAlign.left,
                      style: bigResponsiveFont(context,
                          fontColor: FontColor.Accent,
                          fontWeight: FontWeight.w800)
                          .copyWith(color: Color(0xFF112D44)),
                    ),
                      SizedBox(height:height/20),
                      AutoSizeText(FlutterI18n.translate(
                        context,
                        "progress_screen.tutor_content",
                      ),
                        maxLines:2,
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.left,
                        style: mediumResponsiveFont(context,
                            fontWeight: FontWeight.w400)
                            .copyWith(color: Color(0xFF000000).withOpacity(0.5)
                        ),
                      )
                    ],
                  )
                ),
                SizedBox(width:10),
                Expanded(
                  flex: 2,
                  child:FlatButton(
                    onPressed: () {
                      Injector.appInstance
                          .getDependency<AnalyticsProvider>()
                          .logEvent(AnalyticsConstants.tapTutoringUpsell,
                          params: null);

                      Routes.navigateToTutoringScreen(
                          context, AnalyticsConstants.screenTutoring,
                          isNavBar: false);
                    },
                    padding:
                    EdgeInsets.symmetric(
                        vertical: 2, horizontal: 10),
                    color: Color.fromRGBO(20, 94, 215, 0.15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: AutoSizeText(
                      FlutterI18n.translate(
                        context,
                          "progress_screen.tutor_button",
                      ),
                      maxLines: 1,
                      minFontSize: 0,
                      stepGranularity: 0.1,
                      style: bigResponsiveFont(context,
                          fontColor: FontColor.Accent,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            )),
      )
    );
  }
}
