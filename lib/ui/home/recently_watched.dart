import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/home/home_section.dart';
import 'package:Medschoolcoach/ui/lesson/lesson_video_screen.dart';
import 'package:Medschoolcoach/utils/api/models/last_watched_response.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class RecentlyWatched extends StatelessWidget {
  final LastWatchedResponse recentlyWatched;
  final AnalyticsProvider analyticsProvider;

  const RecentlyWatched({
    Key key,
    this.recentlyWatched,
    this.analyticsProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      sectionTitle: FlutterI18n.translate(
        context,
        "home_screen.recently_watched",
      ),
      sectionWidget: Material(
        color: Style.of(context).colors.accent,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: () {
            _goToLesson(context);
          },
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 35,
                              child: RaisedButton(
                                key: const Key("continue watching"),
                                color: Style.of(context).colors.content2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    15.0,
                                  ),
                                ),
                                onPressed: () {
                                  _goToLesson(context);
                                },
                                child: Container(
                                  width: whenDevice(
                                    context,
                                    large: 138,
                                    tablet: 300,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        Style.of(context).svgAsset.play,
                                        width: whenDevice(
                                          context,
                                          large: 12,
                                          tablet: 20,
                                        ),
                                        height: whenDevice(
                                          context,
                                          large: 12,
                                          tablet: 20,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: Text(
                                          FlutterI18n.translate(
                                            context,
                                            "home_screen.continue_watching",
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                          softWrap: true,
                                          style: smallerResponsiveFont(
                                            context,
                                            fontColor: FontColor.Accent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              recentlyWatched.subject.name +
                                  " - " +
                                  recentlyWatched.topic.name,
                              style: smallResponsiveFont(
                                context,
                                fontWeight: FontWeight.w500,
                                fontColor: FontColor.Content2,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              FlutterI18n.translate(
                                context,
                                "home_screen.lesson",
                                {
                                  "number":
                                      (recentlyWatched.order + 1).toString(),
                                },
                              ),
                              style: smallResponsiveFont(
                                context,
                                fontWeight: FontWeight.w500,
                                fontColor: FontColor.Content2,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              recentlyWatched.name,
                              style: Style.of(context).font.normal2.copyWith(
                                    fontSize: whenDevice(
                                      context,
                                      large: 18,
                                      tablet: 28,
                                    ),
                                  ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    color: Style.of(context).colors.content2,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      recentlyWatched.length,
                                      style: smallResponsiveFont(
                                        context,
                                        fontWeight: FontWeight.w500,
                                        fontColor: FontColor.Accent,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    FlutterI18n.translate(
                                      context,
                                      "home_screen.watched",
                                      {
                                        "number": recentlyWatched
                                            .progress.percentage
                                            .toString(),
                                      },
                                    ),
                                    style: smallResponsiveFont(
                                      context,
                                      fontColor: FontColor.Content2,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 138,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: SvgPicture.asset(Style.of(context).svgAsset.scienceLady,
                  height: whenDevice(
                    context,
                    large: 185.0,
                    tablet: 230,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToLesson(BuildContext context) {
    analyticsProvider.logEvent(AnalyticsConstants.tapRecentlyWatched,
        params: analyticsProvider.getVideoParam(
            recentlyWatched.id, recentlyWatched.subject.name,
            additionalParams: {
              AnalyticsConstants.keySource:
                  AnalyticsConstants.screenRecentlyWatched
            }));
    Navigator.of(context).pushNamed(
      Routes.lesson,
      arguments: LessonVideoScreenArguments(
          order: recentlyWatched.order,
          topicId: recentlyWatched.topicId,
          source: AnalyticsConstants.screenRecentlyWatched),
    );
  }
}
