import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordCheckbox extends StatelessWidget {
  final String text;
  final bool isChecked;
  final bool useSpace;
  final bool showError;

  const PasswordCheckbox({
    Key key,
    @required this.text,
    @required this.isChecked,
    this.useSpace = true,
    this.showError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            isChecked
                ? Container(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.done,
                        size: 10,
                        color: Style.of(context).colors.content2,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Style.of(context).colors.accent2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                : Container(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        height: 8,
                        width: 8,
                      ),
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Style.of(context).colors.separator,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
            const SizedBox(
              width: 8,
            ),
            Text(text,
                style: showError
                    ? smallResponsiveFont(context, fontColor: FontColor.Error)
                    : smallResponsiveFont(context))
          ],
        ),
        useSpace
            ? const SizedBox(
                height: 6,
              )
            : Container(),
      ],
    );
  }
}
