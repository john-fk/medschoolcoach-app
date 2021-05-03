import 'dart:math';
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

import 'flash_card_back.dart';
import 'flash_card_front.dart';
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
  bool _swipeDismiss = false;
  FlashcardStatus _flashcardStatus;
  Orientation _currentOrientation;
  AnimationController _changeAnimationController;
  Animation<double> _fadeAnimation;
  bool _showFrontSide;
  int _flipBack = 0;
  bool _hideCard;
  double wCard;
  double hCard;
  String _currentConfidence;
  bool _externalUpdate;
  _rxsub.BehaviorSubject<bool> willAcceptStream;
  final GlobalKey<FlashCardBottomState> _flashCardBottom = GlobalKey();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _showFrontSide = true;
    _externalUpdate = false;
    _hideCard = true;

    Future.delayed(Duration(milliseconds: 500), toggleCardVisibility);

    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      // Do stuff on phone shake
      widget.changeCardIndex(increase: false);
    });

    willAcceptStream = _rxsub.BehaviorSubject<bool>();
    willAcceptStream.add(false);
  }

  void toggleCardVisibility({bool flipback = false}) {
    setState(() {
      _flipBack = flipback ? 2 : 0;
      _showFrontSide = true;
      if (!flipback) _hideCard = !_hideCard;
      _externalUpdate = false;
    });
    if (flipback) {
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _hideCard = !_hideCard;
        });
      });
    }
  }

  void _setupAnimations() {
    _changeAnimationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: FlashCardWidget.animationDurationValue),
    );

    _fadeAnimation =
        Tween<double>(begin: 1, end: 0).animate(_changeAnimationController)
          ..addListener(() {
            setState(() {});
            if (_changeAnimationController.status ==
                AnimationStatus.completed) {
              _changeAnimationController.reverse();
              if (!_swipeDismiss) widget.changeCardIndex();
              setState(() {
                _swipeDismiss = false;
                widget.setFront(front: true);
              });
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation != _currentOrientation) {
      _currentOrientation = MediaQuery.of(context).orientation;
      setState(() {});
    }

    final height = widget.cardArea.height;
    final width = widget.cardArea.width;

    wCard = width * FlashCardWidget.flashCardWidthFactor;
    hCard = widget.cardArea.height * FlashCardWidget.flashCardHeightFactor;

    _currentConfidence = _externalUpdate
        ? _currentConfidence
        : widget.flashCard.status.toString().split(".")[1];

    return Container(
        width: widget.cardArea.width,
        child: Stack(children: [
          //swipe left target
          DragTarget<String>(onAccept: (value) {
            swipeAction("Negative");
          }, builder: (_, candidateData, rejectedData) {
            return Container(width: width / 4, height: height);
          }),
          //Swipe right target
          Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: DragTarget<String>(onAccept: (value) {
                swipeAction("Positive");
              }, builder: (_, candidateData, rejectedData) {
                return Container(width: width / 4, height: height);
              })),
          //swipe down
          Positioned(
              bottom: 0,
              left: width * 0.25,
              child: DragTarget<String>(onAccept: (value) {
                swipeAction("Neutral");
              }, builder: (_, candidateData, rejectedData) {
                return Container(width: width * 0.5, height: height / 3);
              })),
          Container(
              child: Center(
                  child: AnimatedOpacity(
                      opacity: _hideCard ? 0 : 1,
                      duration: Duration(
                          milliseconds: FlashCardWidget.animationDurationValue),
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          child: _buildFlipAnimation())))),
          FlashCardBottom(
              key: _flashCardBottom,
              nextCard: _nextFlashcard,
              updatedOption: _externalUpdate,
              forceUpdated: forceUpdated,
              status: _currentConfidence),
        ]));
  }

  void swipeAction(String confidence) {
    _nextFlashcard(
      cardstatus: confidence,
    );
  }

  Widget _buildCardRear() {
    return Material(
        elevation: 1,
        color: Style.of(context).colors.background,
        borderRadius: BorderRadius.circular(10),
        child: Container(
            padding: EdgeInsets.all(
              whenDevice(
                context,
                large: 15.0,
                tablet: 30.0,
              ),
            ),
            width: wCard,
            height: hCard,
            child: FlashCardBack(
              progress: widget.progress,
              flashCard: widget.flashCard,
              flip: _switchCardReverse,
            )));
  }

  Widget _buildCardFront() {
    return Container(
      child: Material(
          elevation: 1,
          color: Style.of(context).colors.background,
          borderRadius: BorderRadius.circular(10),
          child: Container(
              padding: EdgeInsets.all(
                whenDevice(
                  context,
                  large: 15.0,
                  tablet: 30.0,
                ),
              ),
              width: wCard,
              height: hCard,
              child: FlashCardFront(
                progress: widget.progress,
                flashCard: widget.flashCard,
                flip: _switchCard,
              ))),
    );
  }

  void forceUpdated() {
    _externalUpdate = false;
  }

  void _setFlashcardStatus(FlashcardStatus status) {
    setState(() {
      _flashcardStatus = status;
    });
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
      setState(() {
        _externalUpdate = true;
        _currentConfidence = cardstatus;
      });
    }

    Future.delayed(Duration(milliseconds: isSwiped ? 500 : 0), () {
      setState(() {
        _flashcardStatus = getFlashcardStatusEnum(cardstatus);
        _hideCard = true;
      });
    });
    //animate, when complete change card index, then animate back
    //
    Future.delayed(
        Duration(
            milliseconds: FlashCardWidget.animationDurationValue +
                200 +
                (isSwiped ? 500 : 0)), () {
      if (_externalUpdate) _externalUpdate = false;
      widget.changeCardIndex(increase: increase);
      toggleCardVisibility(flipback: !_showFrontSide);
    });
  }

  void _updateFlashcardStatus({String flashcardStatus, String source}) async {
    //log if confidence level changed
    if (getEmojiType(flashcardStatus)) {
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

  bool getEmojiType(String emojitype) {
    switch (emojitype.toLowerCase()) {
      case "positive":
      case "neutral":
      case "negative":
        return true;
      default:
        return false;
    }
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

  void _switchCard() {
    _toggleDisplayState(false);
    _logEvents(AnalyticsConstants.tapFlashcardFlipForward);
  }

  void _switchCardReverse() {
    _toggleDisplayState(true);
    _logEvents(AnalyticsConstants.tapFlashcardFlipForward);
  }

  void _toggleDisplayState(bool reverse) {
    setState(() {
      _showFrontSide = !_showFrontSide;
      if (!reverse && _flashcardStatus == FlashcardStatus.New)
        _flashcardStatus = FlashcardStatus.Seen;
    });
    widget.setFront(front: !widget.front);
  }

  Widget _buildFlipAnimation() {
    return Column(children: [
      Container(
        constraints: BoxConstraints.tight(Size(wCard, hCard)),
        alignment: Alignment.topCenter,
        child: Draggable(
          data: "Text",
          child: _draggableCard(),
          feedback: StreamBuilder(
              initialData: false,
              stream: willAcceptStream,
              builder: (context, snapshot) {
                return _draggableCard(true);
              }),
          childWhenDragging: Container(),
        ),
      )
    ]);
  }

  Widget _draggableCard([bool isFeedback = false]) {
    return GestureDetector(
        onTap: _switchCard,
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: flipBack() ? 0 : 300),
          transitionBuilder: __transitionBuilder,
          layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
          child: _showFrontSide ? _buildCardFront() : _buildCardRear(),
          switchInCurve: Curves.easeInBack,
          switchOutCurve: Curves.easeInBack.flipped,
        ));
  }

  bool flipBack() {
    if (_flipBack > 0) {
      _flipBack--;
      return true;
    } else
      return false;
  }

  void logAnalyticsEvent(String type, String action) {
    _logEvents(AnalyticsConstants.tapFlashcardConfidence,
        additionalParams: {"confidence": type.toLowerCase(), "action": action});
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != true);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: (Matrix4.rotationY(value)..setEntry(3, 0, tilt)),
          child: widget,
          alignment: Alignment.bottomCenter,
        );
      },
    );
  }
}
