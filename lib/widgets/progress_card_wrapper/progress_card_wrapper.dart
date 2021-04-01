import 'package:Medschoolcoach/utils/api/models/subject.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:visibility_detector/visibility_detector.dart';

// ignore: must_be_immutable
class ProgressCardWrapper extends StatefulWidget {
  String title;
  List<Subject> allSubjects;
  String footerLinkText;
  VoidCallback onTapFooter;
  final Function(Subject) onSubjectChange;
  final Widget child;
  String selectedSubject;

  ProgressCardWrapper(
      {this.title,
      this.footerLinkText,
      this.onTapFooter,
      this.allSubjects,
      this.onSubjectChange,
      this.selectedSubject = 'All',
      this.child});

  @override
  _ProgressCardWrapper createState() =>
      _ProgressCardWrapper(this.selectedSubject);
}

class _ProgressCardWrapper extends State<ProgressCardWrapper>
    with SingleTickerProviderStateMixin {
  bool playAnimation = false;
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

  _ProgressCardWrapper(this.selectedSubject);

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.45 && !playAnimation) {
          setState(() {
            playAnimation = true;
          });
        }
      },
      child: Card(
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
              widget.child,
              SizedBox(
                height: 10,
              ),
              _footerButton(),
            ],
          ),
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
