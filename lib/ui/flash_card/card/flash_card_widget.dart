import 'package:enum_to_string/enum_to_string.dart';
import 'package:Medschoolcoach/ui/flash_card/card/flash_card_swipe.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/flash_card/screen/flash_card_screen.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:shake/shake.dart';
import 'flash_card_bottom.dart';
import 'flash.dart';

typedef SetFront({@required bool front});

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
        if (_flashCardSwipe != null && widget.cardIndex > 0) {
          _flashCardSwipe.currentState.undo();
          Future.delayed(Duration(milliseconds: Durations.cardFadeGap), () {
            _flashCardBottom.currentState.cancelUpdate();
            widget.changeCardIndex(increase: false);
          });

          _logEvents(AnalyticsConstants.swipeFlashcard, additionalParams: {
            AnalyticsConstants.keyDirection: AnalyticsConstants.keyLeftSwipe
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

    double hCard =
        widget.cardArea.height * FlashCardWidget.flashCardHeightFactor -
            whenDevice(context, small: 5, medium: 8, large: 10, tablet: 15)
                .toDouble() -
            whenDevice(context,
                large: isPortrait(context) ? 35 : 15,
                tablet: isPortrait(context) ? 65 : 30);
    double wCard = widget.cardArea.width /
        (isPortrait(context) ? 1 : 2) *
        FlashCardWidget.flashCardWidthFactor;
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
              status: enumFlashcardStatusToEmoji(widget.flashCard.status)),
        ]));
  }

  void updateEmoji(CardAction action, double opacity) {
    switch (action) {
      case CardAction.Success:
        _flashCardBottom.currentState.cancelExternal();
        break;
      case CardAction.Reset:
        _flashCardBottom.currentState.cancelUpdate();
        break;
      case CardAction.Left:
        _flashCardBottom.currentState
            .externalUpdate(EmojiType.Negative, opacity);
        break;
      case CardAction.Right:
        _flashCardBottom.currentState
            .externalUpdate(EmojiType.Positive, opacity);
        break;
      case CardAction.Down:
        _flashCardBottom.currentState
            .externalUpdate(EmojiType.Neutral, opacity);
        break;
      case CardAction.Up:
        break;
    }
  }

  void _nextFlashcard(
      {bool increase = true,
      String trigger = "swipe",
      FlashcardStatus cardstatus = FlashcardStatus.Seen}) async {
    _updateFlashcardStatus(flashcardStatus: cardstatus, source: trigger);

    bool isSwiped = trigger == "swipe";
    if (!isSwiped)
      _flashCardSwipe.currentState
          .animateSwipe(enumFlashcardStatusToCardAction(cardstatus), true);

    _flashcardStatus = cardstatus;
    _flashCardSwipe.currentState.returnToFront();
    Future.delayed(Duration(milliseconds: isSwiped ? 0 : Durations.emojiFade),
        () {
      _flashCardSwipe.currentState.hideCard();
    });

    Future.delayed(
        Duration(
            milliseconds: isSwiped
                ? Durations.cardSwipeGone
                : Durations.emojiFadeGap), () {
      widget.changeCardIndex(increase: increase, cardstatus: cardstatus);
      _flashCardSwipe.currentState.hideCard(hide: false);
      Future.delayed(Duration(milliseconds: Durations.cardFadeGap), () {
        if (_flashCardBottom.currentState != null)
          _flashCardBottom.currentState.preventClick = false;
      });
    });
  }

  void _updateFlashcardStatus(
      {FlashcardStatus flashcardStatus, String source}) async {
    //log if confidence level changed
    if (isConfidence(flashcardStatus)) {
      logAnalyticsEvent(EnumToString.convertToString(flashcardStatus), source);
    }

    if (flashcardStatus != null) {
      _flashcardStatus = flashcardStatus;
    }

    final result = await Injector.appInstance
        .getDependency<ApiServices>()
        .setFlashcardProgress(
          flashcardId: widget.flashCard.id,
          status: _flashcardStatus,
        );

    if (result is ErrorResponse) print(result.toString());
  }

  bool isConfidence(FlashcardStatus emojitype) {
    return [
      FlashcardStatus.Positive,
      FlashcardStatus.Negative,
      FlashcardStatus.Neutral
    ].contains(emojitype);
  }

  void logAnalyticsEvent(String type, String action) {
    _logEvents(AnalyticsConstants.swipeFlashcard, additionalParams: {
      AnalyticsConstants.keyDirection: AnalyticsConstants.keyRightSwipe
    });
    _logEvents(
        action == "swipe"
            ? AnalyticsConstants.swipeFlashcardConfidence
            : AnalyticsConstants.tapFlashcardConfidence,
        additionalParams: {"confidence": type.toLowerCase()});
  }

  void _logEvents(String event, {dynamic additionalParams}) {
    var args = {"id": widget.flashCard.id, "front": widget.flashCard.front};
    if (additionalParams != null) {
      args.addAll(additionalParams);
    }
    widget.analyticsProvider.logEvent(event, params: args);
  }
}
