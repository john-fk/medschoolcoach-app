import 'dart:math';
 import 'package:universal_io/io.dart';
import 'package:enum_to_string/enum_to_string.dart';

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
import 'flash_card_top.dart';

import 'swipable.dart';
import 'flash.dart';

class FlashCardSwipe extends StatefulWidget {
  final nextFlashCard nextCard;
  final logEvent logEvents;
  final updateEmoji emojiMe;
  final String progress;
  final int cardIndex;

  final double wCard;
  final double hCard;
  final FlashcardModel flashCard;

  FlashCardSwipe(
      {this.wCard,
      this.hCard,
      this.nextCard,
      this.logEvents,
      this.progress,
      this.emojiMe,
      this.flashCard,
      this.cardIndex,
      Key key})
      : super(key: key);

  @override
  FlashCardSwipeState createState() => FlashCardSwipeState();
}

class FlashCardSwipeState extends State<FlashCardSwipe>
    with TickerProviderStateMixin {
  StreamController<double> _controller = StreamController<double>();
  final GlobalKey<FlashCardTopState> _flashcardtop =
      GlobalKey<FlashCardTopState>();

  bool _showFrontSide;
  int _flipBack = 0;
  bool _hideCard;
  double _horizontalDrag;
  double _topVerticalDrag;
  double _bottomVerticalDrag;
  String _currentConfidence;
  AnimationController _changeAnimationController;
  Animation<double> _fadeAnimation;
  FlashcardStatus _flashcardStatus;
  bool emojiClick;
  Color topColor;
  String topText;
  CardAction _confidence;

  double screenWidth;
  double screenHeight;
  DragStartDetails startPosition;
  int lastCard;
  bool _cardInPosition;
  bool _isUndoing;
  @override
  void initState() {
    topColor = Color.fromRGBO(0, 0, 0, 0.0);
    topText = "";
    super.initState();
    _flashcardStatus = widget.flashCard.status;
    _isUndoing = false;
    _setupAnimations();
    _showFrontSide = true;
    _hideCard = true;
    _cardInPosition = false;
    Future.delayed(Duration(milliseconds: 300), toggleCardVisibility);
  }

  @override
  Widget build(BuildContext context) {
    if (lastCard == null)
      lastCard = widget.cardIndex;
    else if (lastCard > widget.cardIndex) {}
    lastCard = widget.cardIndex;

    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if (_hideCard && !_isUndoing) {
      _controller = StreamController<double>();
    } else {
      emojiClick = false;
    }

    return Container(
        child: Center(
            child: AnimatedOpacity(
                opacity: _hideCard && !_isUndoing ? 0 : 1,
                duration: Duration(milliseconds: Durations.cardFade),
                child: _hideCard && !_isUndoing
                    ? Container()
                    : AnimatedOpacity(
                        opacity: _isUndoing ? 0 : 1,
                        duration: Duration(milliseconds: Durations.cardFade),
                        child: Swipable(
                            onSwipeRight: positiveConfidence,
                            onSwipeLeft: negativeConfidence,
                            onSwipeDown: neutralConfidence,
                            onSwipeStart: startDrag,
                            onSwipeCancel: endDrag,
                            onPositionChanged: confidenceDrag,
                            swipe: _controller.stream,
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 20),
                                child: _buildFlipAnimation()))))));
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
                height: widget.hCard,
                width: widget.wCard,
                progress: widget.progress,
                flashCard: widget.flashCard,
                flip: _switchCard,
              ))),
    );
  }

  void _switchCard() {
    if (_cardInPosition) {
      _toggleDisplayState(false);
      widget.logEvents(AnalyticsConstants.tapFlashcardFlipForward);
    }
  }

  void _switchCardReverse() {
    if (_cardInPosition) {
      _toggleDisplayState(true);
      widget.logEvents(AnalyticsConstants.tapFlashcardFlipBackward);
    }
  }

  void _toggleDisplayState(bool reverse) {
    setState(() {
      _showFrontSide = !_showFrontSide;
      _cardInPosition = false;
      if (!reverse && _flashcardStatus == FlashcardStatus.New)
        _flashcardStatus = FlashcardStatus.Seen;
    });
  }

  void undo() {
    if (_isUndoing)
      return;
    else
      _isUndoing = true;
    //triggered after top bar shown
    setState(() {
      _confidence = null;
      _hideCard = true;
      _showFrontSide = true;
      _cardInPosition = false;
    });
    Future.delayed(Duration(milliseconds: Durations.cardFadeGap), () {
      //animate top
      _flashcardtop.currentState.undoTab();
      setState(() {
        _hideCard = false;
        _cardInPosition = false;
        _isUndoing = false;
      });
    });
  }

  void returnToFront() {
    _showFrontSide = true;
  }

  void toggleCardVisibility({bool flipback = false}) {
    setState(() {
      _showFrontSide = true;
      if (!flipback) _hideCard = !_hideCard;
      _cardInPosition = false;
    });
    if (flipback) {
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _hideCard = !_hideCard;
          _cardInPosition = false;
        });
      });
    }
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
    Future.delayed(Duration(milliseconds: _hideCard ? 0 : 300), () {
      _cardInPosition = true;
    });

    return Stack(children: [
      Align(
          alignment: Alignment.center,
          child: GestureDetector(
              onTap: _switchCard,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: _hideCard ? 0 : 375),
                transitionBuilder: __transitionBuilder,
                layoutBuilder: (widget, list) =>
                    Stack(children: [widget, ...list]),
                child: _showFrontSide ? _buildCardFront() : _buildCardRear(),
                switchInCurve: Curves.easeInBack,
                switchOutCurve: Curves.easeInBack.flipped,
              ))),
      Align(
          alignment: Alignment.center,
          child: FlashCardTop(
              key: _flashcardtop, height: widget.hCard, width: widget.wCard)),
    ]);
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
        final isUnder = ValueKey(_showFrontSide) != true;
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.001;
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
      duration: const Duration(milliseconds: Durations.cardFade),
    );

    _fadeAnimation =
        Tween<double>(begin: 1, end: 0).animate(_changeAnimationController)
          ..addListener(() {
            setState(() {});
            if (_changeAnimationController.status ==
                AnimationStatus.completed) {
              _changeAnimationController.reverse();
            }
          });
  }

  void animateSwipe(CardAction action, [bool isClick = false]) {
    emojiClick = isClick;
    switch (action) {
      case CardAction.Right:
        _controller.add(pi / 4);
        break;
      case CardAction.Down:
        _controller.add(3 * pi / 4);
        break;
      case CardAction.Left:
        _controller.add(pi);
        break;
      case CardAction.Up:
      case CardAction.Reset:
      case CardAction.Success:
        break;
    }
  }

  void startDrag(DragStartDetails details) {
    startPosition = details;
    _horizontalDrag = widget.wCard * .33;
    _topVerticalDrag = (details.globalPosition.dy - widget.hCard / 2) * .33;

    _horizontalDrag = whenDevice(
      context,
      small: _horizontalDrag > 80 ? 80 : _horizontalDrag,
      large: _horizontalDrag > 120 ? 120 : _horizontalDrag,
      tablet: _horizontalDrag > 80
          ? isPortrait(context)
              ? 60
              : 50
          : _horizontalDrag,
    );

    _bottomVerticalDrag = _horizontalDrag;

    _topVerticalDrag = whenDevice(
      context,
      small: _horizontalDrag > 80 ? 80 : _horizontalDrag,
      tablet: _horizontalDrag > 80 ? 80 : _horizontalDrag,
      large: _horizontalDrag > 120 ? 120 : _horizontalDrag,
    );
  }

  void endDrag(Offset position, DragEndDetails details) {
    if (_confidence == null) {
      _flashcardtop.currentState
          .updateTab(Color(0xFFFFFFFF).withOpacity(0), "");
      widget.emojiMe(CardAction.Reset, 1);
    } else {
      animateSwipe(_confidence);
    }
  }

  double calculateOpacity(double X, double space) {
    return X / space > 1 ? 1 : (X / space);
  }

  //these will be triggered on drag
  void confidenceDrag(DragUpdateDetails position) {
    double moveX = position.globalPosition.dx - startPosition.globalPosition.dx;
    double moveY = position.globalPosition.dy - startPosition.globalPosition.dy;
    if (moveY < 0) {
      if (moveY.abs() > moveX.abs() * 2) {
        setConfidenceHelper(
            calculateOpacity(moveY.abs(), _topVerticalDrag), CardAction.Up);
      } else if (moveX > 0) {
        setConfidenceHelper(
            calculateOpacity(moveX, _horizontalDrag), CardAction.Right);
      } else {
        setConfidenceHelper(
            calculateOpacity(moveX.abs(), _horizontalDrag), CardAction.Left);
      }
    } else if (moveY > moveX.abs()) {
      setConfidenceHelper(
          calculateOpacity(moveY, _bottomVerticalDrag), CardAction.Down);
    } else if (moveX > 0) {
      setConfidenceHelper(
          calculateOpacity(moveX, _horizontalDrag), CardAction.Right);
    } else {
      setConfidenceHelper(
          calculateOpacity(moveX.abs(), _horizontalDrag), CardAction.Left);
    }
  }

  void setConfidenceHelper(double opacity, CardAction type) {
    if (opacity == 1 && type != CardAction.Up) {
      _confidence = type;
    } else {
      _confidence = null;
    }
    //update opacity & text for top banner
    switch (type) {
      case CardAction.Left:
        widget.emojiMe(type, opacity);
        _flashcardtop.currentState.updateTab(
            Color(0xFFFFAEA6).withOpacity(opacity),
            FlutterI18n.translate(context, "flashcards_tips.negative"));
        break;
      case CardAction.Right:
        widget.emojiMe(type, opacity);
        _flashcardtop.currentState.updateTab(
            Color(0xFF009D7A).withOpacity(opacity),
            FlutterI18n.translate(context, "flashcards_tips.positive"));
        break;
      case CardAction.Down:
        widget.emojiMe(type, opacity);
        _flashcardtop.currentState.updateTab(
            Color(0xFFFFB84A).withOpacity(opacity),
            FlutterI18n.translate(context, "flashcards_tips.neutral"));
        break;
      case CardAction.Up:
        widget.emojiMe(type, 1);
        _flashcardtop.currentState
            .updateTab(Color(0xFFFFFFFF).withOpacity(opacity), "");
        break;
      case CardAction.Success:
      case CardAction.Reset:
        break;
    }
    //update opacity for bottom icon
    return null;
  }

  void negativeConfidence(Offset offset) {
    triggerConfidence(FlashcardStatus.Negative);
  }

  void neutralConfidence(Offset offset) {
    triggerConfidence(FlashcardStatus.Neutral);
  }

  void positiveConfidence(Offset offset) {
    triggerConfidence(FlashcardStatus.Positive);
  }

  void hideCard({bool hide = true}) {
    setState(() {
      _hideCard = hide;
    });
  }

  void triggerConfidence(FlashcardStatus cardstatus) {
    if (!emojiClick) {
      widget.emojiMe(CardAction.Success, 1);
      widget.nextCard(increase: true, trigger: "swipe", cardstatus: cardstatus);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
