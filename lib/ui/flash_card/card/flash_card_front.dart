import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_button.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_status.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FlashCardFront extends StatelessWidget {
  final VoidCallback flip;
  final FlashcardModel flashCard;
  final String progress;

  const FlashCardFront({
    Key key,
    @required this.flip,
    @required this.flashCard,
    @required this.progress,
  }) : super(key: key);

  double fontSize(String content) {
    var words = content.split(" ");
    int longest = 0;
    for (var i = 0; i < words.length || longest > 12; i++) {}
    return 0.00;
  }

  bool textOnly(String text) {
    return !RegExp(
      r"^/<\/?[a-z][\s\S]*>/i",
      caseSensitive: false,
      multiLine: true,
    ).hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;

    if (isPortrait(context)) {
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
    } else {
      width = MediaQuery.of(context).size.height;
      height = MediaQuery.of(context).size.width;
    }

    TextStyle txtStyle =
        medstyles.Style.of(context).font.bold.copyWith(fontSize: width * 0.07);

    return GestureDetector(
      onTap: flip,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlashCardStatusWidget(
              progress: progress,
              status: flashCard.status,
            ),
            flashCard.frontImage == null || flashCard.frontImage.isEmpty
                ? Container(
                    margin: EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                    child: textOnly(flashCard.front)
                        ? AutoSizeText(
                            flashCard.front,
                            style: txtStyle,
                            maxLines: 10,
                            wrapWords: false,
                          )
                        : Html(
                            data: flashCard.front,
                            style: {"html": Style.fromTextStyle(txtStyle)}))
                : ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height * 0.2),
                    child: Image.network(
                      flashCard.frontImage,
                    ),
                  ),
            Align(
              alignment: Alignment.centerRight,
              child: FlashCardButton(
                onPress: flip,
                text: FlutterI18n.translate(context, "flashcard_screen.flip"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
