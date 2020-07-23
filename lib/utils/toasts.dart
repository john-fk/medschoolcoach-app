import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  @required String text,
  @required BuildContext context,
  @required Color color,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color.withOpacity(0.9),
    textColor: Style.of(context).colors.content2,
    fontSize: normalResponsiveFont(context).fontSize,
  );
}

void showWatchedToast(BuildContext context) {
  showToast(
    color: Style.of(context).colors.accent2,
    context: context,
    text: FlutterI18n.translate(
      context,
      "home_screen.video_watched_toast",
    ),
  );
}

void showUnwatchedToast(BuildContext context) {
  showToast(
    color: Style.of(context).colors.questions,
    context: context,
    text: FlutterI18n.translate(
      context,
      "home_screen.video_unwatched_toast",
    ),
  );
}
