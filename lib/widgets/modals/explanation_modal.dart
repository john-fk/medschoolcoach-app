import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter_html/style.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;

void openExplanationModal(
    {@required BuildContext context,
    @required Widget content,
    @required String title,
    bool scrollable = true}) {
  final width = MediaQuery.of(context).size.width;

  showModalBottomSheet<void>(
    backgroundColor: medstyles.Style.of(context).colors.accent,
    context: context,
    builder: (context) {
      return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: (MediaQuery.of(context).size.width - 32) / 4,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                  ),
                  height: MediaQuery.of(context).size.height / 120,
                ),
                Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.white,
                      iconSize: whenDevice(context, large: 25.0, tablet: 40.0),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )),
                Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      title,
                      style: normalResponsiveFont(context,
                          fontColor: FontColor.White, opacity: 0.5),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: scrollable
                      ? SingleChildScrollView(child: content)
                      : content,
                ),
                const SizedBox(
                  height: 20,
                ),
              ]));
    },
  );
}
