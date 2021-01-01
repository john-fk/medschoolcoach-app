import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class NoFlashcardsWidget extends StatelessWidget {
  final FlashcardsStackArguments arguments;

  const NoFlashcardsWidget(this.arguments);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                Icons.event_busy,
                size: width * 0.3,
                color: Style.of(context).colors.error.withOpacity(0.8),
              ),
              const SizedBox(height: 20),
              Text(
                FlutterI18n.translate(
                  context,
                  "flashcard_screen.no_flashcards.title",
                ),
                style:
                    normalResponsiveFont(context, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                FlutterI18n.translate(
                  context,
                  _getTranslationKey(),
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

  String _getTranslationKey() {
    if (arguments.status != null)
      return "flashcard_screen.no_flashcards.confidence";
    if (arguments.subjectId != null)
      return "flashcard_screen.no_flashcards.subject";
    if (arguments.videoId != null)
      return "flashcard_screen.no_flashcards.video";
    return "";
  }
}
