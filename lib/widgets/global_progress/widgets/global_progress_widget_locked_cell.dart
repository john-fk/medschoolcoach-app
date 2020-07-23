import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

enum LockedFeature {
  Flashcards,
  Questions,
}

class GlobalProgressWidgetLockedCell extends StatelessWidget {
  final LockedFeature lockedFeature;
  final double iconHeight;

  const GlobalProgressWidgetLockedCell({
    Key key,
    @required this.lockedFeature,
    @required this.iconHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = lockedFeature == LockedFeature.Flashcards
        ? Style.of(context).colors.accent
        : Style.of(context).colors.questions;
    final translateKey = lockedFeature == LockedFeature.Flashcards
        ? "global_progress.locked_flashcards"
        : "global_progress.locked_questions";
    final width = MediaQuery.of(context).size.width;
    return InkWellObject(
      borderRadius: BorderRadius.circular(10),
      onTap: () => Navigator.of(context).pushNamed(Routes.goPremium),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.05,
          vertical: width * 0.1,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.lock,
              color: color,
              size: iconHeight,
            ),
            Text(
              FlutterI18n.translate(context, translateKey),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.normal,
                fontSize: whenDevice(context, large: 15, tablet: 25),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
