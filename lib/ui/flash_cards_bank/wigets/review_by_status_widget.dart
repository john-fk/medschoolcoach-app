import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReviewByStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _emojiButton(
          onPressed: () => onPress(FlashcardStatus.Positive, context),
          context: context,
          asset: Style.of(context).svgAsset.positive,
          color: Style.of(context).colors.accent2,
        ),
        _emojiButton(
          onPressed: () => onPress(FlashcardStatus.Neutral, context),
          context: context,
          asset: Style.of(context).svgAsset.neutral,
          color: Style.of(context).colors.premium,
        ),
        _emojiButton(
          onPressed: () => onPress(FlashcardStatus.Negative, context),
          context: context,
          asset: Style.of(context).svgAsset.negative,
          color: Style.of(context).colors.questions,
        ),
      ],
    );
  }

  void onPress(FlashcardStatus status, BuildContext context) {
    Navigator.pushNamed(context, Routes.flashCard,
        arguments: FlashcardsStackArguments(status: status));
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
