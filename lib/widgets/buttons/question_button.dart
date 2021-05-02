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
  final String pressed;
  final Function onPressed;
  final bool showAnswer;
  final bool isCorrect;
  final bool nextQuestion;

  QuestionButton(
      {@required this.text,
      this.optionLetter,
      @required this.onPressed,
      Key key,
      this.showAnswer = false,
      this.isCorrect = false,
      this.nextQuestion = false,
      this.pressed = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: whenDevice(context, large: 50, tablet: 80),
      ),
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(whenDevice(context,
              large: nextQuestion ? 25 : 8, tablet: nextQuestion ? 50 : 15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: nextQuestion ? 0 : _getProperWidth(),
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
                child: nextQuestion
                    ? Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Text(text, style: _getTextStyle(context)),
                            SizedBox(
                              width: 30,
                            ),
                            SvgPicture.asset(
                              medstyles.Style.of(context)
                                  .svgAsset
                                  .questionArrowNext,
                              height: 14,
                            )
                          ]))
                    : Center(
                        child: Html(
                          data: text,
                          style: {
                            "html": Style.fromTextStyle(_getTextStyle(context))
                          },
                        ),
                      ),
              ),
            ),
            nextQuestion
                ? Container()
                : SizedBox(
                    width: 5,
                  ),
            nextQuestion ? Container() : _buildProperIcon(context),
          ],
        ),
        color: showAnswer
            ? (isCorrect
                ? medstyles.Style.of(context).colors.qbCorrect
                : (pressed == optionLetter
                    ? medstyles.Style.of(context).colors.qbIncorrect
                    : Colors.white))
            : Colors.white,
      ),
    );
  }

  Widget _buildProperIcon(BuildContext context) {
    if (showAnswer) {
      if (isCorrect) {
        return TickIcon();
      } else if (pressed == optionLetter) {
        return ErrorIcon();
      }
    }

    return Container(
      width: whenDevice(context, large: 20.0, tablet: 32.0),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    if (!showAnswer || (!isCorrect && !(pressed == optionLetter))) {
      return normalResponsiveFont(
        context,
        fontColor: FontColor.Accent,
        fontWeight: FontWeight.w500,
      );
    } else {
      return normalResponsiveFont(
        context,
        fontColor: FontColor.Content2,
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
