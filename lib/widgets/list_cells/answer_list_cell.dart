import 'package:Medschoolcoach/utils/api/models/question.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
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

  AnswerListCell({
    Key key,
    @required this.question,
    @required this.index,
  }) : super(key: key);

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
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
            vertical: 10.0,horizontal:7
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
                  left: 8.0,
                ),
                child: Text(
                  FlutterI18n.translate(
                    context,
                    "question_screen.question_index",
                    translationParams: {
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
                defaultTextStyle:
                    normalResponsiveFont(
                      context,
                      fontColor: FontColor.Content2,
                    ),
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
                        child: _buildAnswerText(false),
                      )
                    : Container(),
                _buildAnswerText(true),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,horizontal:7
                  ),
                  child: Text(
                    FlutterI18n.translate(
                      context,
                      "question_screen.other_users_percentage",
                      translationParams: {
                        "percentage":
                            question.stats.usersAnsweredCorrect.toString(),
                      },
                    ),
                    style: smallResponsiveFont(context,
                            fontColor: FontColor.White, opacity: 0.5)
                        .copyWith(
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
  Column _buildAnswerText(bool isCorrect) {
    final double _titleSize = whenDevice(
      _context,
      large: 15,
      tablet: 25,
    );
    final Color _color =isCorrect ? medstyles.Style.of(_context).colors.accent2 :  medstyles.Style.of(_context).colors.questions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment:MainAxisAlignment.start,
            children:[
              Container(
                margin: EdgeInsets.only(left:7,right:15),
                width:  _titleSize*.75,
                height: _titleSize*.75,
              decoration: BoxDecoration(
                color: _color,
                shape: BoxShape.circle,
              ),
            ),
        Text(
          isCorrect
              ? FlutterI18n.translate(
                  _context,
                  "question_screen.correct_answer",
                )
              : FlutterI18n.translate(
                  _context,
                  "question_screen.your_answer",
                ),
          style:  medstyles.Style.of(_context).font.mediumAccent2.copyWith(
                    fontSize:_titleSize,
              color: _color
                  )
        )]),
        Html(
          data: isCorrect
              ? _getAnswer(index, question.answer)
              : _getAnswer(index, question.yourAnswer),
          defaultTextStyle: smallResponsiveFont(
              _context,
              fontColor: FontColor.Content2,
            ),
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
