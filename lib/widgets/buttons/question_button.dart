import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:flutter_html/style.dart';
import 'package:Medschoolcoach/widgets/others/error_icon.dart';
import 'package:Medschoolcoach/widgets/others/tick_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';

class QuestionButton extends StatelessWidget {
  final String text;
  final String optionLetter;
  final Function onPressed;
  final bool showAnswer;
  final bool isCorrect;
  final bool nextQuestion;

  QuestionButton({
    @required this.text,
    this.optionLetter,
    @required this.onPressed,
    Key key,
    this.showAnswer = false,
    this.isCorrect = false,
    this.nextQuestion = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: whenDevice(context, large: 50, tablet: 80),
      ),
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(whenDevice(context, large: 25, tablet: 50)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: _getProperWidth(),
            ),
            optionLetter != null && optionLetter.isNotEmpty
                ? Text(
                    optionLetter,
                    style: _getTextStyle(context),
                  )
                : Container(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Center(
                  child: Html(
                    data: text,
                    style: {"html":  Style.fromTextStyle(_getTextStyle(context))},
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            _buildProperIcon(context),
          ],
        ),
        color: medstyles.Style.of(context).colors.content2,
      ),
    );
  }

  Widget _buildProperIcon(BuildContext context) {
    if (showAnswer) {
      if (isCorrect) {
        return TickIcon();
      } else {
        return ErrorIcon();
      }
    }

    if (nextQuestion) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 8.0,
        ),
        child: RotatedBox(
          quarterTurns: 2,
          child: SvgPicture.asset(
            medstyles.Style.of(context).svgAsset.backArrowDark,
            color: medstyles.Style.of(context).colors.accent,
          ),
        ),
      );
    }

    return Container(
      width: whenDevice(context, large: 20.0, tablet: 32.0),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!showAnswer) {
      return normalResponsiveFont(
        context,
        fontColor: FontColor.Accent,
        fontWeight: FontWeight.w500,
      );
    }
    if (isCorrect) {
      return normalResponsiveFont(
        context,
        fontColor: FontColor.Accent2,
        fontWeight: FontWeight.w500,
      );
    } else {
      return normalResponsiveFont(
        context,
        fontColor: FontColor.Questions,
        fontWeight: FontWeight.w500,
      );
    }
  }

  double _getProperWidth() {
    if (nextQuestion) {
      return 45;
    }
    return 5;
  }
}
