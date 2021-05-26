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
  double size;
  double width;
  double fsize;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size.height / 8;
    double height = size > 96 ? size : 96.00;
    final double width = MediaQuery.of(context).size.width;
    fsize = mediumResponsiveFont(context).fontSize;
    return
      Container(
          margin: EdgeInsets.symmetric(
              horizontal:8.0, vertical:height/10),
      height: height,
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.1),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: height*0.15,
                vertical: height*0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                    image: AssetImage(
                        Style.of(context).pngAsset.progressTutor),
                    height:height*0.5
                  ),
                SizedBox(width:width*0.04),
                Expanded(
                  child:
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          FlutterI18n.translate(
                            context,
                            "progress_screen.tutor_title",
                          ),
                        minFontSize: 0,
                        maxLines:1,
                        stepGranularity: 0.1,
                        textAlign: TextAlign.left,
                        style: mediumResponsiveFont(context,
                            fontColor: FontColor.Accent,
                            fontWeight: FontWeight.w800)
                            .copyWith(color: Color(0xFF112D44)),
                      ),SizedBox(height:height*0.05),
                        AutoSizeText(FlutterI18n.translate(
                          context,
                          "progress_screen.tutor_content_line1"
                        ) + "\n" + FlutterI18n.translate(
                            context,
                            "progress_screen.tutor_content_line2"
                        ),
                          maxLines:2,
                          minFontSize: 0,
                          maxFontSize: fsize,
                          stepGranularity: 0.1,
                          textAlign: TextAlign.left,
                          style: mediumResponsiveFont(context,
                              fontWeight: FontWeight.w400)
                              .copyWith(color: Color(0xFF000000)
                              .withOpacity(0.5)
                          ),
                        ),
                      ])
                ),
                SizedBox(width:width*0.04),
              Container(
              width: width*0.3,
              height: height*0.3,
                child:
                FlatButton(
                    onPressed: () {
                      Injector.appInstance
                          .getDependency<AnalyticsProvider>()
                          .logEvent(AnalyticsConstants.tapTutoringUpsell,
                          params: null);

                      Routes.navigateToTutoringScreen(
                          context, AnalyticsConstants.screenTutoring,
                          isNavBar: false);
                    },
                    color: Color.fromRGBO(20, 94, 215, 0.15),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child:Padding(
                          padding: EdgeInsets.symmetric(vertical:height*0.08),
                          child:
                          AutoSizeText(
                            FlutterI18n.translate(
                              context,
                              "progress_screen.tutor_button",
                            ),
                            maxLines: 1,
                            minFontSize: 0,
                            stepGranularity: 0.1,
                            maxFontSize: fsize,
                            style: mediumResponsiveFont(context,
                                fontColor: FontColor.Accent,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                  ),
              )],
            )),
      )
    );
  }
}
