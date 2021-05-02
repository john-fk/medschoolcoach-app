import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/api/models/question_bank_progress.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_progress.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/cards/no_progress_card.dart';
import 'package:Medschoolcoach/widgets/progress_card/progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

// ignore: must_be_immutable
class ProgressCardWrapper extends StatefulWidget {
  String title;
  List<Subject> allSubjects;
  String footerLinkText;
  VoidCallback onTapFooter;
  VoidCallback onTapAction;
  final Function(Subject) onSubjectChange;
  final Widget child;
  final bool isFlashCard;
  String selectedSubject;

  ProgressCardWrapper(
      {this.title,
      this.footerLinkText,
      this.onTapFooter,
      this.allSubjects,
      this.onSubjectChange,
      this.selectedSubject = 'All',
      this.onTapAction,
      this.isFlashCard = true,
      this.child});

  @override
  _ProgressCardWrapper createState() =>
      _ProgressCardWrapper(this.selectedSubject);
}

class _ProgressCardWrapper extends State<ProgressCardWrapper>
    with SingleTickerProviderStateMixin {
  String selectedSubject = "All";

  final List<String> subjectsList = [
    "All",
    "Biochemistry",
    "General Chemistry",
    "Psychology",
    "Biology",
    "Organic Chemistry",
    "Sociology",
    "Physics"
  ];
  QuestionBankProgress questionBankProgress;
  FlashcardsProgress flashCardProgress;
  _ProgressCardWrapper(this.selectedSubject);

  @override
  Widget build(BuildContext context) {
    if (widget.isFlashCard) {
      flashCardProgress = SuperStateful.of(context).flashcardProgress;
    } else {
      questionBankProgress = SuperStateful.of(context).questionBankProgress;
    }

    bool noProgress;
    double incorrect, correct, positive, negative, neutral;
    int attempted;
    if (widget.isFlashCard) {
      var progress = flashCardProgress?.progress == null
          ? null
          : flashCardProgress?.progress[selectedSubject];
      noProgress = progress?.attempted == null || progress.attempted == 0;
      if (!noProgress) {
        positive = double.parse(
            (progress.positive / progress.attempted * 100).toStringAsFixed(1));
        negative = double.parse(
            (progress.negative / progress.attempted * 100).toStringAsFixed(1));
        neutral = double.parse(
            (progress.neutral / progress.attempted * 100).toStringAsFixed(1));
        attempted = progress.attempted;
      }
    } else {
      var progress = questionBankProgress?.progress == null
          ? null
          : questionBankProgress?.progress[selectedSubject];
      noProgress = progress?.attempted == null || progress.attempted == 0;
      if (!noProgress) {
        incorrect = double.parse(
            ((progress.wrong / progress.attempted) * 100).toStringAsFixed(1));
        correct = double.parse(
            ((progress.correct / progress.attempted) * 100).toStringAsFixed(1));
        attempted = progress.attempted;
      }
    }

    return Card(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  FlutterI18n.translate(context, widget.title),
                  style: normalResponsiveFont(context,
                      fontWeight: FontWeight.w700),
                ),
                Spacer(),
                Text(
                  "${selectedSubject}",
                  textAlign: TextAlign.right,
                  style: smallResponsiveFont(context,
                      fontWeight: FontWeight.w400, opacity: 0.5),
                ),
                SizedBox(
                  width: 6,
                ),
                _filterDropDown(
                    onChanged: (val) {
                      setState(() {
                        selectedSubject = val;
                      });
                    },
                    selectedSubject: this.selectedSubject)
              ],
            ),
            SizedBox(
              height: 20,
            ),
            noProgress
                ? NoProgressCard(
                    text: "progress_screen.no_questions",
                    onTapButton: widget.onTapAction,
                    buttonText: "progress_screen.see_questions",
                    icon: Icons.help_outline_rounded,
                  )
                : widget.isFlashCard
                    ? PracticeProgressCard(
                        cardData: ProgressCardData(
                            graphData: [
                              RadianGraphData(
                                  label: "Positive Confidence",
                                  percent: positive,
                                  color: Style.of(context).colors.accent4),
                              RadianGraphData(
                                  label: "Neutral Confidence",
                                  percent: neutral,
                                  color: Style.of(context).colors.premium),
                              RadianGraphData(
                                  label: "Negative Confidence",
                                  percent: negative,
                                  color: Style.of(context).colors.questions),
                            ],
                            graphSubtitle: attempted.toString(),
                            graphTitle: "Total Attempted"),
                      )
                    : PracticeProgressCard(
                        cardData: ProgressCardData(
                            graphData: [
                              RadianGraphData(
                                  label: "Correctly Answered",
                                  percent: correct,
                                  color: Style.of(context).colors.accent4),
                              RadianGraphData(
                                  label: "Incorrectly Answered",
                                  percent: incorrect,
                                  color: Style.of(context).colors.questions),
                            ],
                            graphSubtitle: attempted.toString(),
                            graphTitle: "Total Attempted"),
                      ),
            SizedBox(
              height: 10,
            ),
            _footerButton(),
          ],
        ),
      ),
    );
  }

  Widget _footerButton() {
    if (widget.footerLinkText?.isEmpty ?? true) {
      return Container();
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: FlatButton(
          onPressed: () {
            print("tap button");
            widget.onTapFooter();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                FlutterI18n.translate(context, widget.footerLinkText),
                style: normalResponsiveFont(context,
                    fontColor: FontColor.Accent,
                    fontWeight: FontWeight.w400,
                    style: TextStyle(decoration: TextDecoration.underline)),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.arrow_forward,
                color: Style.of(context).colors.accent,
              )
            ],
          )),
    );
  }

  Widget _filterDropDown({Function(String) onChanged, String selectedSubject}) {
    return PopupMenuButton(
        itemBuilder: (context) => widget.allSubjects.map((subject) {
              // ignore: lines_longer_than_80_chars
              return PopupMenuItem(
                  value: subject,
                  child: CheckboxListTile(
                    activeColor: Style.of(context).colors.accent4,
                    value: selectedSubject == subject.name,
                    onChanged: (val) {
                      onChanged(subject.name);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      widget.onSubjectChange(subject);
                    },
                    title: Text(subject.name),
                  ));
            }).toList(),
        icon: Icon(
          Icons.filter_list,
          color: Colors.black.withOpacity(0.5),
        ),
        onSelected: (Subject val) {});
  }
}
