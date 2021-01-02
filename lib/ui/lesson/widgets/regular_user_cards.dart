import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/ui/lesson/widgets/wide_feature_button.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/modals/podcast_modal.dart';
import 'package:Medschoolcoach/widgets/modals/premium_modal.dart';
import 'package:Medschoolcoach/widgets/modals/tutoring_modal/tutoring_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class RegularUserCards extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        WideFeatureButton(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Style.of(context).colors.premium,
          text: FlutterI18n.translate(
            context,
            "lesson_screen.premium_features",
          ),
          icon: Icon(
            Icons.star,
            color: Style.of(context).colors.content2,
            size: whenDevice(
              context,
              large: 25,
              tablet: 50,
            ),
          ),
          onTap: () => openPremiumModal(context),
        ),
        SizedBox(
          height: 10,
        ),
        WideFeatureButton(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Style.of(context).colors.content,
          text: FlutterI18n.translate(
            context,
            "lesson_screen.tutoring",
          ),
          icon: RotatedBox(
            quarterTurns: 2,
            child: SvgPicture.asset(
              Style.of(context).svgAsset.backArrowDark,
              color: Style.of(context).colors.content2,
              width: whenDevice(
                context,
                large: 25,
                tablet: 50,
              ),
            ),
          ),
          onTap: () => openTutoringModal(
              context, AnalyticsConstants.screenLessonVideo),
        ),
        SizedBox(
          height: 10,
        ),
        WideFeatureButton(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Style.of(context).colors.questions,
          text: FlutterI18n.translate(
            context,
            "lesson_screen.podcast",
          ),
          icon: Icon(
            Icons.music_note,
            color: Style.of(context).colors.content2,
            size: whenDevice(
              context,
              large: 25,
              tablet: 50,
            ),
          ),
          onTap: () => openPodcastModal(
              context, AnalyticsConstants.screenPremiumCard),
        ),
      ],
    );
  }
}
