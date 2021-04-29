import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter_html/style.dart';

void openExplanationModal({
  @required BuildContext context,
  @required String explanationText,
}) {
  final width = MediaQuery.of(context).size.width;

  showModalBottomSheet<void>(
    backgroundColor: Color.fromRGBO(12, 83, 199, 1),
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.white,
                          iconSize:
                              whenDevice(context, large: 25.0, tablet: 40.0),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                    Text(
                      FlutterI18n.translate(
                          context, "question_screen.explanation"),
                      style: normalResponsiveFont(context,
                          fontColor: FontColor.HalfWhite),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Html(data: explanationText, style: {
                      "html": Style.fromTextStyle(
                        normalResponsiveFont(context,
                            fontColor: FontColor.Content2),
                      )
                    })
                  ])),
              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}
