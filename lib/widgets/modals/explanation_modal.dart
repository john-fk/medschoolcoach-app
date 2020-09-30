import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_html/style.dart';

void openExplanationModal({
  @required BuildContext context,
  @required String explanationText,
}) {
  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Text(
                FlutterI18n.translate(context, "question_screen.explanation"),
                style:
                    biggerResponsiveFont(context, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Html(data: explanationText, style: {
                "html": Style.fromTextStyle(
                  normalResponsiveFont(context),
                )
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}
