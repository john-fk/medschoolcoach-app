import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/pop_back_questions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuestionAppBar extends StatefulWidget {
  final String category;
  final int currentQuestion;
  final int questionsSize;
  final String questionId;
  final String stem;
  final bool summary;
  final bool isFlashCard;
  VoidCallback onHowtoTap;

  QuestionAppBar(
      {Key key,
      @required this.category,
      this.currentQuestion,
      this.stem,
      this.questionsSize,
      this.questionId,
      this.summary = false,
      this.isFlashCard = false,
      this.onHowtoTap})
      : super(key: key);

  @override
  _QuestionAppBarState createState() => _QuestionAppBarState();
}

class _QuestionAppBarState extends State<QuestionAppBar> {
  @override
  Widget build(BuildContext context) {
    final String userAnswer = widget.questionsSize > 0
        ? "${widget.currentQuestion}/${widget.questionsSize}"
        : "";
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.fromLTRB(
            10,
            MediaQuery.of(context).padding.top,
            10,
            10,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: 30,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: PopBackQuestions(),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.category ?? "Questions of the Day",
                        style: greatResponsiveFont(
                          context,
                          fontColor: FontColor.Content2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                !widget.isFlashCard
                    ? Container()
                    : ClipOval(
                        child: Material(
                          color: Colors.white60, // button color
                          child: InkWell(
                            splashColor: Colors.white, // inkwell color
                            child: SizedBox(
                                height: whenDevice(context,
                                    small: 16.5,
                                    medium: 19.5,
                                    large: 23.25,
                                    tablet: 25.5),
                                width: whenDevice(context,
                                    small: 16.5,
                                    medium: 19.5,
                                    large: 23.25,
                                    tablet: 25.5),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text("?",
                                        style: mediumResponsiveFont(
                                          context,
                                          fontColor: FontColor.Accent,
                                          fontWeight: FontWeight.bold,
                                        )))),
                            onTap: widget.onHowtoTap,
                          ),
                        ),
                      ),
                widget.isFlashCard ? const SizedBox(width: 20) : Container(),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 0),
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                  child: child,
                  position: Tween<Offset>(
                          begin: Offset(0.0, -0.5), end: Offset(0.0, 0.0))
                      .animate(animation),
                );
              },
              child: Text(
                userAnswer,
                key: ValueKey<String>(userAnswer),
                style: normalResponsiveFont(context,
                    fontColor: FontColor.Content2),
              )),
        ),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: widget.questionsSize > 0
                ? (FAProgressBar(
                    currentValue: ((widget.questionsSize > 0 &&
                                widget.currentQuestion > 1) ||
                            widget.summary)
                        ? (widget.currentQuestion * 100 / widget.questionsSize)
                            .floor()
                        : 0,
                    backgroundColor: Color(0x4BFFFFFF),
                    progressColor: Color(0xFFFFFFFF),
                    size: 10))
                : Container()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.2),
          ),
        )
      ],
    );
  }
}
