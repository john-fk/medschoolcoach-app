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
  final int cardIndex;
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
      @required this.cardIndex,
      @required this.analyticsProvider})
      : super(key: key);

  @override
  _FlashCardWidgetState createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget>
    with TickerProviderStateMixin {
  FlashcardStatus _flashcardStatus;
  Orientation _currentOrientation;
  final GlobalKey<FlashCardBottomState> _flashCardBottom =
      GlobalKey<FlashCardBottomState>();
  final GlobalKey<FlashCardSwipeState> _flashCardSwipe =
      GlobalKey<FlashCardSwipeState>();

  ShakeDetector detector;
  @override
  void initState() {
    super.initState();
    if (detector == null)
      detector = ShakeDetector.autoStart(onPhoneShake: () {
        if (_flashCardSwipe != null && widget.cardIndex > 1) {
          _flashCardSwipe.currentState.undo();
          Future.delayed(Duration(milliseconds: 1200), () {
            widget.changeCardIndex(increase: false);
          });
        }
      });
  }

  @override
  void dispose() {
    detector.stopListening();
    super.dispose();
  }

  double cardHeight;
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation != _currentOrientation) {
      _currentOrientation = MediaQuery.of(context).orientation;
      setState(() {});
    }

    double wCard = widget.cardArea.width * FlashCardWidget.flashCardWidthFactor;
    double hCard =
        widget.cardArea.height * FlashCardWidget.flashCardHeightFactor -
            whenDevice(context, small: 5, medium: 8, large: 10, tablet: 15)
                .toDouble() -
            whenDevice(
              context,
              large: 35,
              tablet: 65,
            );

    return Container(
        width: widget.cardArea.width,
        child: Stack(children: [
          FlashCardSwipe(
              key: _flashCardSwipe,
              logEvents: _logEvents,
              emojiMe: updateEmoji,
              wCard: wCard,
              hCard: hCard,
              cardIndex: widget.cardIndex,
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

  void updateEmoji(String event, double opacity) {
    switch (event) {
      case "success":
        _flashCardBottom.currentState.cancelExternal();
        break;
      case "reset":
        _flashCardBottom.currentState.cancelUpdate();
        break;
      case "left":
        _flashCardBottom.currentState.externalUpdate("Negative", opacity);
        break;
      case "right":
        _flashCardBottom.currentState.externalUpdate("Positive", opacity);
        break;
      case "bottom":
        _flashCardBottom.currentState.externalUpdate("Neutral", opacity);
        break;
    }
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
    _flashCardSwipe.currentState.returnToFront();
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
}
