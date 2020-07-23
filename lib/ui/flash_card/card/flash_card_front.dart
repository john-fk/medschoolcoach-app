import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_button.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_status.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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
                ? Html(
                    useRichText: false,
                    data: flashCard.front,
                    defaultTextStyle: Style.of(context)
                        .font
                        .bold
                        .copyWith(fontSize: width * 0.07),
                    customTextAlign: (_) => TextAlign.center,
                  )
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
