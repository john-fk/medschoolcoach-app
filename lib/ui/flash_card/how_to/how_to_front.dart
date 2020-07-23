import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'flashcards_how_to.dart';

class HowToFrontWidget extends StatelessWidget {
  final VoidCallback gotIt;

  const HowToFrontWidget(this.gotIt);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                FlutterI18n.translate(context, "flashcards_how_to.welcome"),
                style: Style.of(context).font.medium2.copyWith(
                      fontSize: whenDevice(
                        context,
                        large: 25,
                        tablet: 45,
                      ),
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: height * 0.05),
              FlashcardsHowTo.buildIconWithText(
                iconAsset: Style.of(context).svgAsset.touch,
                translateKey: "flashcards_how_to.flip",
                context: context,
              ),
              FlashcardsHowTo.buildIconWithText(
                iconAsset: Style.of(context).svgAsset.swipeLeft,
                translateKey: "flashcards_how_to.swipe_left",
                context: context,
              ),
              FlashcardsHowTo.buildIconWithText(
                iconAsset: Style.of(context).svgAsset.swipeRight,
                translateKey: "flashcards_how_to.swipe_right",
                context: context,
              ),
              FlashcardsHowTo.buildIconWithText(
                iconAsset: Style.of(context).svgAsset.rotate,
                translateKey: "flashcards_how_to.rotate",
                spaceBetween: whenDevice(context, large: 10, tablet: 20),
                context: context,
              ),
              FlashcardsHowTo.buildGotItButton(context, gotIt),
              SizedBox(height: height * 0.1),
            ]),
      ),
    );
  }
}
