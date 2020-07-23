import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class FlashCardBar extends StatefulWidget {
  @override
  _FlashCardBarState createState() => _FlashCardBarState();
}

class _FlashCardBarState extends State<FlashCardBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        20,
        10 + MediaQuery.of(context).padding.top,
        20,
        10,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                key: const Key("app_bar_back_button"),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(
                    Style.of(context).svgAsset.backArrowDark,
                    color: Style.of(context).colors.content2,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 10),
              Text(
                FlutterI18n.translate(context, "flashcard_screen.flashcards"),
                style: Style.of(context).font.bold2Great,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
