import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/pop_back_questions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuestionAppBar extends StatefulWidget {
  final Function onChange;
  final String category;
  final int currentQuestion;
  final int questionsSize;
  final String questionId;
  final String stem;
  final bool summary;
  final bool isFlashCard;
  bool isVisible;
  VoidCallback onHowtoTap;

  QuestionAppBar(
      {Key key,
      @required this.category,
      this.onChange,
      this.currentQuestion,
      this.stem,
      this.questionsSize,
      this.questionId,
      this.summary = false,
      this.isFlashCard = false,
      this.onHowtoTap,
      this.isVisible = false})
      : super(key: key);

  @override
  _QuestionAppBarState createState() => _QuestionAppBarState();
}

class _QuestionAppBarState extends State<QuestionAppBar> {
  @override
  void dispose() {
    super.dispose();
  }

  var widgetKey = GlobalKey();
  Size oldSize;

  void postFrameCallback() {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    if (widget.onChange != null) widget.onChange(newSize);
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => postFrameCallback());

    if (!widget.isVisible) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (this.mounted) {
          setState(() {
            widget.isVisible = true;
          });
        }
      });
    }

    String userAnswer = "";
    if (widget.summary) {
      userAnswer = widget.category ?? "Questions of the Day";
    } else {
      userAnswer = widget.questionsSize > 0 &&
              !(!widget.isVisible && widget.currentQuestion == 1)
          ? "${widget.currentQuestion - (widget.isVisible ? 0 : 1)}/${widget.questionsSize}"
          : "";
    }
    return Column(
      key: widgetKey,
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
              top: whenDevice(context,
                  small: 10, medium: 15, large: 20, tablet: 25),
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
                        widget.summary
                            ? "Questions"
                            : (widget.category ?? "Questions of the Day"),
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
          alignment: widget.summary ? Alignment.centerLeft : Alignment.center,
          margin: EdgeInsets.only(
            top: 0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.summary ? 30.0 : 0,
          ),
          child: AnimatedOpacity(
              opacity: widget.isVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: Text(
                userAnswer,
                style:
                    smallResponsiveFont(context, fontColor: FontColor.Content2),
              )),
        ),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: whenDevice(context,
                    small: 5, medium: 6, large: 8, tablet: 10)),
            child: !widget.summary && widget.questionsSize > 0
                ? (FAProgressBar(
                    currentValue: ((widget.questionsSize > 0 &&
                                widget.currentQuestion > 1) ||
                            widget.summary)
                        ? (widget.currentQuestion * 100 / widget.questionsSize)
                            .floor()
                        : 0,
                    backgroundColor: Color(0x4BFFFFFF),
                    progressColor: Color(0xFFFFFFFF),
                    size: whenDevice(context,
                        small: 5, medium: 6, large: 8, tablet: 10)))
                : Container()),
        widget.isFlashCard
            ? Container()
            : Padding(
                padding: EdgeInsets.fromLTRB(
                    16,
                    whenDevice(context,
                        small: 8, medium: 12, large: 16, tablet: 32),
                    16,
                    16),
                child: Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.2),
                ),
              )
      ],
    );
  }
}
