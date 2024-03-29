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
    bool fitHeight = true}) {
  final width = MediaQuery.of(context).size.width;

  Widget _content() {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: SafeArea(
            minimum: EdgeInsets.only(bottom: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: (MediaQuery.of(context).size.width - 32) / 4,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFFFFFFFF).withOpacity(0.25),
                    ),
                    height: MediaQuery.of(context).size.height / 120,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              title,
                              style: normalResponsiveFont(context,
                                  fontColor: FontColor.White, opacity: 0.5),
                            )),
                        Container(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(Icons.close),
                              color: Colors.white,
                              iconSize: whenDevice(context,
                                  large: 25.0, tablet: 40.0),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                      ]),
                  const SizedBox(
                    height: 10,
                  ),
                  !fitHeight
                      ? (Expanded(child: SingleChildScrollView(child: content)))
                      : content
                ])));
  }

  showModalBottomSheet<void>(
      backgroundColor: medstyles.Style.of(context).colors.accent,
      context: context,
      isScrollControlled: fitHeight,
      builder: (context) {
        return fitHeight
            ? Container(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            MediaQuery.of(context).size.height / 4.0 * 3.0,
                      ),
                      child: Wrap(children: [_content()])),
                ],
              ))
            : _content();
      });
}
