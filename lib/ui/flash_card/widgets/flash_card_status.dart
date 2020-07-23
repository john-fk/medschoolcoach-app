import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class FlashCardStatusWidget extends StatelessWidget {
  final FlashcardStatus status;
  final String progress;

  const FlashCardStatusWidget({
    @required this.status,
    @required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        _buildElement(
          status == FlashcardStatus.New
              ? FlutterI18n.translate(context, "flashcard_screen.new")
              : FlutterI18n.translate(context, "flashcard_screen.seen"),
          status == FlashcardStatus.New
              ? Style.of(context).colors.accent2
              : Style.of(context).colors.questions,
          context,
        ),
        SizedBox(width: 5),
        _buildElement(progress, Style.of(context).colors.content, context)
      ],
    );
  }

  Widget _buildElement(String text, Color color, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: whenDevice(context, large: 50, tablet: 100),
      height: whenDevice(context, large: 20, tablet: 40),
      child: Text(
        text,
        style: Style.of(context)
            .font
            .normal2
            .copyWith(fontSize: whenDevice(context, large: 12, tablet: 20)),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
