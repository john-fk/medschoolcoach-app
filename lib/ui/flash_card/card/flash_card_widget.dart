import 'dart:math';
import 'package:Medschoolcoach/ui/flash_card/card/flash_card_swipe.dart';
import 'package:rxdart/subjects.dart' as _rxsub;

import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/flashcard_repository.dart';
import 'package:Medschoolcoach/ui/flash_card/screen/flash_card_screen.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:shake/shake.dart';

import 'flash_card_bottom.dart';

typedef SetFront({@required bool front});

enum EmojiType {
  Neutral,
  Positive,
  Negative,
}

class FlashCardWidget extends StatefulWidget {
  final FlashcardModel flashCard;
  final ChangeCardIndex changeCardIndex;
  final String progress;
  final SetFront setFront;
  final bool front;
  final AnalyticsProvider analyticsProvider;
  final Size cardArea;
  static const flashCardWidthFactor = 0.75;
  static const flashCardHeightFactor = 1;
  static const flashCardBottomMarginFactor = 0.1;
  static const animationDurationValue = 200;

  const FlashCardWidget(
      {Key key,
      @required this.flashCard,
      @required this.changeCardIndex,
      @required this.progress,
      @required this.front,
      @required this.setFront,
      @required this.cardArea,
      @required this.analyticsProvider})
      : super(key: key);

  @override
  _FlashCardWidgetState createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget>
    with TickerProviderStateMixin {
  FlashcardStatus _flashcardStatus;
  Orientation _currentOrientation;
  final GlobalKey<FlashCardBottomState> _flashCardBottom = GlobalKey();
  final GlobalKey<FlashCardSwipeState> _flashCardSwipe = GlobalKey();

  @override
  void initState() {
    super.initState();

    ShakeDetector.autoStart(onPhoneShake: () {
      //todo : ensure not shaking during flip or other animation
      widget.changeCardIndex(increase: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation != _currentOrientation) {
      _currentOrientation = MediaQuery.of(context).orientation;
      setState(() {});
    }

    double wCard = widget.cardArea.width * FlashCardWidget.flashCardWidthFactor;
    double hCard =
        widget.cardArea.height * FlashCardWidget.flashCardHeightFactor;

    return Container(
        width: widget.cardArea.width,
        child: Stack(children: [
          FlashCardSwipe(
              key: _flashCardSwipe,
              wCard: wCard,
              hCard: hCard,
              flashCard: widget.flashCard,
              progress: widget.progress,
              nextCard: _nextFlashcard),
          FlashCardBottom(
              key: _flashCardBottom,
              nextCard: _nextFlashcard,
              updatedOption: false,
              status: widget.flashCard.status.toString().split(".")[1]),
        ]));
  }

  void _setFlashcardStatus(FlashcardStatus status) {
    setState(() {
      _flashcardStatus = status;
    });
  }

  String swipeDirection(String confidence) {
    switch (confidence) {
      case "Neutral":
        return "bottom";
      case "Positive":
        return "right";
      case "Negative":
        return "left";
      default:
        return "";
    }
  }

  void _nextFlashcard(
      {bool increase = true,
      String trigger = "swipe",
      String cardstatus = "seen"}) async {
    _updateFlashcardStatus(flashcardStatus: cardstatus, source: trigger);

    /*
    _logEvents(
        _swipeDismiss
            ? AnalyticsConstants.swipeFlashcard
            : AnalyticsConstants.tapNextFlashcard,
        additionalParams: {
          AnalyticsConstants.keyDirection: increase
              ? AnalyticsConstants.keyLeftSwipe
              : AnalyticsConstants.keyRightSwipe
        });
    */
    bool isSwiped = trigger == "swipe";
    if (isSwiped) {
      _flashCardBottom.currentState.swipeEmoji(cardstatus);
    } else {
      _flashCardSwipe.currentState.animateSwipe(swipeDirection(cardstatus));
    }

    _flashcardStatus = getFlashcardStatusEnum(cardstatus);
    Future.delayed(Duration(milliseconds: isSwiped ? 0 : 200), () {
      _flashCardSwipe.currentState.hideCard();
    });

    Future.delayed(Duration(milliseconds: isSwiped ? 100 : 400), () {
      widget.changeCardIndex(increase: increase);
      _flashCardSwipe.currentState.hideCard(hide: false);
    });
  }

  void _updateFlashcardStatus({String flashcardStatus, String source}) async {
    //log if confidence level changed
    if (isConfidence(flashcardStatus)) {
      logAnalyticsEvent(flashcardStatus, source);
    }

    if (flashcardStatus != null) {
      _flashcardStatus = getFlashcardStatusEnum(flashcardStatus);
    }

    final result = await Injector.appInstance
        .getDependency<ApiServices>()
        .setFlashcardProgress(
          flashcardId: widget.flashCard.id,
          status: _flashcardStatus,
        );

    Injector.appInstance.getDependency<FlashcardRepository>().clearCache();

    if (result is ErrorResponse) print(result.toString());
  }

  bool isConfidence(String emojitype) {
    return ["positive", "neutral", "negative"].contains(emojitype);
  }

  void logAnalyticsEvent(String type, String action) {
    _logEvents(AnalyticsConstants.tapFlashcardConfidence,
        additionalParams: {"confidence": type.toLowerCase(), "action": action});
  }

  void _logEvents(String event, {dynamic additionalParams}) {
    var args = {"id": widget.flashCard.id, "front": widget.flashCard.front};
    if (additionalParams != null) {
      args.addAll(additionalParams);
    }
    widget.analyticsProvider.logEvent(event, params: args);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
