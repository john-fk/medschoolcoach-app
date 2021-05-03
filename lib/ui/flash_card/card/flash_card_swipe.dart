import 'dart:math';

import 'package:rxdart/subjects.dart' as _rxsub;
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'dart:async';
import 'flash_card_widget.dart';
import 'flash_card_back.dart';
import 'flash_card_front.dart';
import 'swipable.dart';

enum EmojiType {
  Neutral,
  Positive,
  Negative,
}

typedef nextFlashCard({bool increase, String trigger, String cardstatus});
typedef logEvent(String event, {dynamic additionalParams});

class FlashCardSwipe extends StatefulWidget {
  final nextFlashCard nextCard;
  final logEvent logEvents;
  final String progress;

  final double wCard;
  final double hCard;
  final FlashcardModel flashCard;
  FlashCardSwipe(
      {this.wCard,
      this.hCard,
      this.nextCard,
      this.logEvents,
      this.progress,
      this.flashCard,
      Key key})
      : super(key: key);

  @override
  FlashCardSwipeState createState() => FlashCardSwipeState();
}

class FlashCardSwipeState extends State<FlashCardSwipe>
    with TickerProviderStateMixin {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  StreamController<double> _controller = StreamController<double>();

  bool _showFrontSide;
  int _flipBack = 0;
  bool _hideCard;
  String _currentConfidence;
  AnimationController _changeAnimationController;
  Animation<double> _fadeAnimation;
  FlashcardStatus _flashcardStatus;
  bool emojiClick;
  _rxsub.BehaviorSubject<bool> willAcceptStream;

  @override
  void initState() {
    super.initState();
    _flashcardStatus = widget.flashCard.status;
    _setupAnimations();
    _showFrontSide = true;
    _hideCard = true;

    Future.delayed(Duration(milliseconds: 300), toggleCardVisibility);

    willAcceptStream = _rxsub.BehaviorSubject<bool>();
    willAcceptStream.add(false);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
    if (_hideCard) {
      _controller = StreamController<double>();
    } else {
      emojiClick = false;
    }

    return Container(
        child: Center(
            child: AnimatedOpacity(
                opacity: _hideCard ? 0 : 1,
                duration: Duration(
                    milliseconds: FlashCardWidget.animationDurationValue),
                child: _hideCard
                    ? Container()
                    : Swipable(
                        onSwipeRight: positiveConfidence,
                        onSwipeLeft: negativeConfidence,
                        onSwipeDown: neutralConfidence,
                        swipe: _controller.stream,
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 20),
                            child: _buildFlipAnimation())))));
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
            width: widget.wCard,
            height: widget.hCard,
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
              width: widget.wCard,
              height: widget.hCard,
              child: FlashCardFront(
                progress: widget.progress,
                flashCard: widget.flashCard,
                flip: _switchCard,
              ))),
    );
  }

  void _switchCard() {
    _toggleDisplayState(false);
    widget.logEvents(AnalyticsConstants.tapFlashcardFlipForward);
  }

  void _switchCardReverse() {
    _toggleDisplayState(true);
    widget.logEvents(AnalyticsConstants.tapFlashcardFlipBackward);
  }

  void _toggleDisplayState(bool reverse) {
    setState(() {
      _showFrontSide = !_showFrontSide;
      if (!reverse && _flashcardStatus == FlashcardStatus.New)
        _flashcardStatus = FlashcardStatus.Seen;
    });
  }

  void toggleCardVisibility({bool flipback = false}) {
    setState(() {
      _flipBack = flipback ? 2 : 0;
      _showFrontSide = true;
      if (!flipback) _hideCard = !_hideCard;
    });
    if (flipback) {
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _hideCard = !_hideCard;
        });
      });
    }
  }

  void swipeAction(String confidence) {
    widget.nextCard(
      cardstatus: confidence,
    );
  }

  Widget _buildFlipAnimation() {
    return Column(children: [
      Container(
        alignment: Alignment.topCenter,
        child: _draggableCard(),
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
              //if (!_swipeDismiss) widget.changeCardIndex();
              setState(() {
                //_swipeDismiss = false;
                //widget.setFront(front: true);
              });
            }
          });
  }

  void animateSwipe(String action) {
    emojiClick = true;
    switch (action) {
      case "right":
        _controller.add(pi / 4);
        break;
      case "bottom":
        _controller.add(3 * pi / 4);
        break;
      case "left":
        _controller.add(pi);
        break;
    }
  }

  //this will trigger confidences from swipe and proceed to animate to next card
  //
  void negativeConfidence(Offset offset) {
    triggerConfidence("negative");
  }

  void neutralConfidence(Offset offset) {
    triggerConfidence("neutral");
  }

  void positiveConfidence(Offset offset) {
    triggerConfidence("positive");
  }

  void hideCard({bool hide = true}) {
    setState(() {
      _hideCard = hide;
    });
  }

  void triggerConfidence(String cardstatus) {
    if (!emojiClick)
      widget.nextCard(increase: true, trigger: "swipe", cardstatus: cardstatus);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
