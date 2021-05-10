import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Medschoolcoach/ui/flash_card/card/flash.dart';

class ReviewByStatusWidget extends StatelessWidget {
  final AnalyticsProvider _analyticsProvider;

  const ReviewByStatusWidget(this._analyticsProvider);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _emojiButton(
          onPressed: () => onPress(FlashcardStatus.Positive, context),
          context: context,
          asset: Style.of(context).pngAsset.ePositive,
          color: Style.of(context).colors.accent2,
        ),
        _emojiButton(
          onPressed: () => onPress(FlashcardStatus.Neutral, context),
          context: context,
          asset: Style.of(context).pngAsset.eNeutral,
          color: Style.of(context).colors.premium,
        ),
        _emojiButton(
          onPressed: () => onPress(FlashcardStatus.Negative, context),
          context: context,
          asset: Style.of(context).pngAsset.eNegative,
          color: Style.of(context).colors.questions,
        ),
      ],
    );
  }

  void onPress(FlashcardStatus status, BuildContext context) {
    _analyticsProvider.logEvent(AnalyticsConstants.tapFlashcardsReviewBy,
        params: {
          AnalyticsConstants.keyReviewBy: describeEnum(status).toLowerCase()
        });
    Navigator.pushNamed(context, Routes.flashCard,
        arguments: FlashcardsStackArguments(
            status: status, source: AnalyticsConstants.screenFlashcardsBank));
  }

  Widget _emojiButton({
    @required VoidCallback onPressed,
    @required String asset,
    @required Color color,
    @required BuildContext context,
  }) {
    final width = MediaQuery.of(context).size.width * 0.28;
    return Container(
      width: width,
      height: whenDevice(context, large: 50, tablet: 100),
      child: ButtonTheme(
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SvgPicture.asset(
              asset,
              width: whenDevice(context, large: 30, tablet: 60),
              color: Style.of(context).colors.content2,
            ),
          ),
          color: color,
        ),
      ),
    );
  }
}
