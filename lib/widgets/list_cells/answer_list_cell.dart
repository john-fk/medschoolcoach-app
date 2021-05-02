import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter_html/style.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:Medschoolcoach/widgets/custom_expansion_tile/custom_expansion_tile.dart';
import 'package:Medschoolcoach/widgets/others/error_icon.dart';
import 'package:Medschoolcoach/widgets/others/tick_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class AnswerListCell extends StatelessWidget {
  final Question question;
  final int index;

  const AnswerListCell({
    Key key,
    @required this.question,
    @required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool _isCorrect = question.yourAnswer == question.answer;
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        accentColor: medstyles.Style.of(context).colors.content2,
        unselectedWidgetColor: medstyles.Style.of(context).colors.content2,
      ),
      child: CustomExpansionTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Row(
            children: <Widget>[
              _isCorrect
                  ? TickIcon(
                      flipColor: true,
                    )
                  : ErrorIcon(
                      flipColor: true,
                    ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  FlutterI18n.translate(
                    context,
                    "question_screen.question_index",
                    {
                      "index": (index + 1).toString(),
                    },
                  ),
                  style: normalResponsiveFont(
                    context,
                    fontColor: FontColor.Content2,
                  ),
                ),
              ),
            ],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(
            bottom: 10.0,
          ),
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, width / 15, 0),
              child: Html(
                data: question.stem,
                style: {
                  "html": Style.fromTextStyle(
                    normalResponsiveFont(
                      context,
                      fontColor: FontColor.Content2,
                    ),
                  )
                },
              )),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(),
                !_isCorrect
                    ? Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: _buildAnswerText(
                          context,
                          false,
                        ),
                      )
                    : Container(),
                _buildAnswerText(
                  context,
                  true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Text(
                    FlutterI18n.translate(
                      context,
                      "question_screen.other_users_percentage",
                      {
                        "percentage":
                            question.stats.usersAnsweredCorrect.toString(),
                      },
                    ),
                    style: smallResponsiveFont(
                      context,
                      fontColor: FontColor.HalfWhite,
                    ).copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Column _buildAnswerText(BuildContext context, bool isCorrect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          isCorrect
              ? FlutterI18n.translate(
                  context,
                  "question_screen.correct_answer",
                )
              : FlutterI18n.translate(
                  context,
                  "question_screen.your_answer",
                ),
          style: isCorrect
              ? medstyles.Style.of(context).font.mediumAccent2.copyWith(
                    fontSize: whenDevice(
                      context,
                      large: 15,
                      tablet: 25,
                    ),
                  )
              : medstyles.Style.of(context).font.mediumAccent2.copyWith(
                    fontSize: whenDevice(
                      context,
                      large: 15,
                      tablet: 25,
                    ),
                    color: medstyles.Style.of(context).colors.questions,
                  ),
        ),
        Html(
          data: isCorrect
              ? _getAnswer(index, question.answer)
              : _getAnswer(index, question.yourAnswer),
          style: {
            "html": Style.fromTextStyle(smallResponsiveFont(
              context,
              fontColor: FontColor.Content2,
            ))
          },
        ),
      ],
    );
  }

  String _getAnswer(int index, String answer) {
    switch (answer) {
      case "A":
        return question.choiceA;
      case "B":
        return question.choiceB;
      case "C":
        return question.choiceC;
      case "D":
        return question.choiceD;
      default:
        return "";
    }
  }
}
