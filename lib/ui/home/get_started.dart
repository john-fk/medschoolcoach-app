import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/ui/home/home_section.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeSection(
      sectionTitle: FlutterI18n.translate(
        context,
        "home_screen.get_started",
      ),
      sectionWidget: Material(
        borderRadius: BorderRadius.circular(5),
        color: Style.of(context).colors.accent,
        child: InkWell(
          onTap: () {
            _goToSchedule(context);
          },
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 185,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(right: 140.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                          context,
                          "home_screen.pick_schedule",
                        ),
                        style: biggerResponsiveFont(
                          context,
                          fontColor: FontColor.Content2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 30,
                        child: RaisedButton(
                          key: const Key("get_started"),
                          color: Style.of(context).colors.content2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          onPressed: () {
                            _goToSchedule(context);
                          },
                          child: Container(
                            width: 138,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SvgPicture.asset(
                                  Style.of(context).svgAsset.play,
                                  width: 12,
                                  height: 12,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      FlutterI18n.translate(
                                        context,
                                        "home_screen.get_started",
                                      ).toUpperCase(),
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      softWrap: true,
                                      style: Style.of(context)
                                          .font
                                          .continueWatchingButton,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: SvgPicture.asset(
                  Style.of(context).svgAsset.scienceLady,
                  width: 171.0,
                  height: 185.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToSchedule(BuildContext context) {
    Navigator.of(context).pushNamed(
      Routes.schedule,
      arguments: AnalyticsConstants.screenHome
    );
  }
}
