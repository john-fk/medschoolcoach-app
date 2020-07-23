import 'package:Medschoolcoach/ui/flash_card/card/flash_card_widget.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'flashcards_how_to.dart';

class HowToBackWidget extends StatelessWidget {
  final VoidCallback gotIt;

  const HowToBackWidget(this.gotIt);

  static const flashcardAppBarHeight = 50;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Center(
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + flashcardAppBarHeight,
                bottom: height * FlashCardWidget.flashCardBottomMarginFactor,
              ),
              height: height * FlashCardWidget.flashCardHeightFactor,
              padding: EdgeInsets.all(
                whenDevice(
                  context,
                  large: 15.0,
                  tablet: 30.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(),
                  FlashcardsHowTo.buildIconWithText(
                    iconAsset: Style.of(context).svgAsset.touch,
                    translateKey: "flashcards_how_to.flip",
                    context: context,
                  ),
                  _buildBackBottomTips(context),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: whenDevice(
            context,
            large: 30,
            tablet: 50,
            small: 15,
          ),
          right: 0,
          left: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlashcardsHowTo.buildGotItButton(context, gotIt),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBackBottomTips(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          width: width * FlashCardWidget.flashCardWidthFactor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: whenDevice(
                  context,
                  large: 30,
                  tablet: 50,
                ),
              ),
              Expanded(
                child: _buildStep1(context),
              ),
              Container(
                width: whenDevice(
                  context,
                  small: 90,
                  large: 100,
                  tablet: 190,
                ),
                child: _buildStep2(context),
              )
            ],
          ),
        ),
        SizedBox(
          height: whenDevice(
            context,
            small: 45,
            large: 50,
            tablet: 90,
          ),
        )
      ],
    );
  }

  Widget _buildStep1(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildStepCircle(context, "1"),
        Text(
          FlutterI18n.translate(
            context,
            "flashcards_how_to.confidence",
          ),
          textAlign: TextAlign.center,
          style: Style.of(context).font.normal2.copyWith(
                fontSize: whenDevice(
                  context,
                  small: 12,
                  large: 15,
                  tablet: 25,
                ),
              ),
        ),
        Icon(
          Icons.keyboard_arrow_down,
          color: Style.of(context).colors.content2,
          size: whenDevice(
            context,
            large: 30,
            tablet: 50,
          ),
        ),
        SizedBox(
          height: whenDevice(context, large: 10, tablet: 40),
        ),
      ],
    );
  }

  Widget _buildStep2(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildStepCircle(context, "2"),
        Text(
          FlutterI18n.translate(context, "flashcards_how_to.next"),
          textAlign: TextAlign.center,
          style: Style.of(context).font.normal2.copyWith(
                fontSize: whenDevice(
                  context,
                  small: 12,
                  large: 15,
                  tablet: 25,
                ),
              ),
        ),
        Icon(
          Icons.arrow_downward,
          color: Style.of(context).colors.content2,
          size: whenDevice(
            context,
            large: 20,
            tablet: 40,
          ),
        )
      ],
    );
  }

  Widget _buildStepCircle(BuildContext context, String step) {
    return Container(
      padding: EdgeInsets.all(
        whenDevice(
          context,
          large: 10,
          tablet: 15,
        ),
      ),
      child: Text(
        step,
        style: Style.of(context).font.normal2.copyWith(
              fontSize: whenDevice(
                context,
                large: 15,
                tablet: 25,
              ),
            ),
      ),
      decoration: BoxDecoration(
        color: Style.of(context).colors.accent2,
        shape: BoxShape.circle,
      ),
    );
  }
}
