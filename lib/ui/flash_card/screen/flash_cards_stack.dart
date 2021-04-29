import 'dart:math' as math;
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/flash_card/card/flash_card_widget.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/no_more_flashcards.dart';
import 'package:Medschoolcoach/utils/api/models/flashcards_stack_model.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'flash_card_screen.dart';

class FlashCardsStack extends StatelessWidget {
  final FlashcardsStackModel flashcardsStackModel;
  final ChangeCardIndex changeCardIndex;
  final int cardIndex;
  final SetFront setFront;
  final bool front;
  final AnalyticsProvider analyticsProvider;

  const FlashCardsStack(
      {Key key,
      @required this.flashcardsStackModel,
      @required this.cardIndex,
      @required this.changeCardIndex,
      @required this.front,
      @required this.setFront,
      @required this.analyticsProvider})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: cardIndex == flashcardsStackModel.items.length ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: NoMoreFlashcardsWidget(
                analyticsProvider: analyticsProvider,
                isVisible: cardIndex == flashcardsStackModel.items.length),
          ),
        ),
        _buildBackgroundFlashCard(context),
        if (cardIndex < flashcardsStackModel.items.length)
          Positioned.fill(
            child: FlashCardWidget(
              flashCard: flashcardsStackModel.items[cardIndex],
              changeCardIndex: changeCardIndex,
              progress: "${cardIndex + 1}/${flashcardsStackModel.items.length}",
              front: front,
              setFront: setFront,
              analyticsProvider: analyticsProvider,
            ),
          ),
      ],
    );
  }

  Widget _buildBackgroundFlashCard(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Center(
          child: AnimatedOpacity(
            opacity: cardIndex < flashcardsStackModel.items.length - 1 ? 1 : 0,
            duration: const Duration(milliseconds: 250),
            child: Transform.rotate(
              angle: -math.pi / 32,
              child: Container(
                margin: EdgeInsets.only(
                  bottom: height * FlashCardWidget.flashCardBottomMarginFactor,
                ),
                width: width * FlashCardWidget.flashCardWidthFactor,
                height: height * FlashCardWidget.flashCardHeightFactor,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Style.of(context).colors.background,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
