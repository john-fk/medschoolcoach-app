import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class NoMoreFlashcardsWidget extends StatelessWidget {

  final AnalyticsProvider analyticsProvider;
  final bool isVisible;

  const NoMoreFlashcardsWidget({this.analyticsProvider, this.isVisible});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    if (isVisible) {
      analyticsProvider.logScreenView(AnalyticsConstants.screenNoMoreFlashcard,
          AnalyticsConstants.screenFlashcards);
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width * 0.7,
          padding: EdgeInsets.all(
            whenDevice(
              context,
              large: 20,
              tablet: 60,
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Style.of(context).colors.background,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.event_available,
                size: width * 0.3,
                color: Style.of(context).colors.accent2.withOpacity(0.8),
              ),
              const SizedBox(height: 20),
              Text(
                FlutterI18n.translate(
                  context,
                  "flashcard_screen.no_more.title",
                ),
                style:
                    normalResponsiveFont(context, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                FlutterI18n.translate(
                  context,
                  "flashcard_screen.no_more.subtitle",
                ),
                textAlign: TextAlign.center,
                style: normalResponsiveFont(context),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.2,
        )
      ],
    );
  }
}
