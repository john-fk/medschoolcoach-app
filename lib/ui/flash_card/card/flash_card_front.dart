import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_button.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_status.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:auto_size_text/auto_size_text.dart';

class FlashCardFront extends StatelessWidget {
  final VoidCallback flip;
  final FlashcardModel flashCard;
  final String progress;
  final double width;
  final double height;

  const FlashCardFront(
      {Key key,
      @required this.flip,
      @required this.flashCard,
      @required this.progress,
      this.width,
      this.height})
      : super(key: key);

  bool textOnly(String text) {
    return !RegExp(
      r"^/<\/?[a-z][\s\S]*>/i",
      caseSensitive: false,
      multiLine: true,
    ).hasMatch(text);
  }

  String reformatText(String text) {
    return text
        .replaceAll("<sup>", "&#8288<sup>")
        .replaceAll("<sub>", "&#8288<sub>");
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = width / (isPortrait(context) ? 1 : 2);

    TextStyle txtStyle =
        medstyles.Style.of(context).font.bold.copyWith(fontSize: cWidth * 0.1);

    return Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlashCardStatusWidget(status: flashCard.status),
            flashCard.frontImage == null || flashCard.frontImage.isEmpty
                ? Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: textOnly(flashCard.front)
                        ? AutoSizeText(
                            flashCard.front,
                            style: txtStyle,
                            maxLines: 10,
                            wrapWords: false,
                          )
                        : Html(
                            data: reformatText(flashCard.front),
                            defaultTextStyle: txtStyle))
                : ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height * 0.8),
                    child: Image.network(
                      flashCard.frontImage,
                    ),
                  ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(),
            ),
          ],
        ));
  }
}
