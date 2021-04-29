import 'dart:async';
import 'dart:math';

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

import 'flash_card_back.dart';
import 'flash_card_front.dart';
import 'flash_card_bottom.dart';

typedef SetFront({@required bool front});

class FlashCardWidget extends StatefulWidget {
  final FlashcardModel flashCard;
  final ChangeCardIndex changeCardIndex;
  final String progress;
  final SetFront setFront;
  final bool front;
  final AnalyticsProvider analyticsProvider;

  static const flashCardWidthFactor = 0.75;
  static const flashCardHeightFactor = 0.65;
  static const flashCardBottomMarginFactor = 0.1;
  static const animationDurationValue = 500;

  const FlashCardWidget(
      {Key key,
      @required this.flashCard,
      @required this.changeCardIndex,
      @required this.progress,
      @required this.front,
      @required this.setFront,
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
  AnimationController _flipAnimationController;
  AnimationController _changeAnimationController;
  bool _showFrontSide;
  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
    _flashcardStatus = widget.flashCard.status;
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation != _currentOrientation) {
      _currentOrientation = MediaQuery.of(context).orientation;
      setState(() {});
    }

    return Stack(children: [
      Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 20),
          child: _buildFlipAnimation()),
      FlashCardBottom(
          progress: widget.progress,
          flashCard: widget.flashCard,
          nextFlashcard: _nextFlashcard,
          flashcardStatus: _flashcardStatus,
          setFlashcardStatus: _setFlashcardStatus,
          flip: _switchCardReverse)
    ]);
  }

  Widget _buildCardRear(double bc, double hc, double wc) {
    return Material(
        elevation: 5,
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
            width: wc,
            height: hc,
            child: FlashCardBack(
              progress: widget.progress,
              flashCard: widget.flashCard,
              nextFlashcard: _nextFlashcard,
              flashcardStatus: _flashcardStatus,
              setFlashcardStatus: _setFlashcardStatus,
              flip: _switchCardReverse,
            )));
  }

  Widget _buildCardFront(double bc, double hc, double wc) {
    return Container(
      child: Material(
          elevation: 5,
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
              width: wc,
              height: hc,
              child: FlashCardFront(
                progress: widget.progress,
                flashCard: widget.flashCard,
                flip: _switchCard,
              ))),
    );
  }

  void _setFlashcardStatus(FlashcardStatus status) {
    setState(() {
      _flashcardStatus = status;
    });
  }

  void _onDissmised(DismissDirection direction) {
    setState(() {
      _swipeDismiss = true;
    });

    _nextFlashcard(increase: direction == DismissDirection.endToStart);
  }

  void _nextFlashcard({bool increase = true}) async {
    if (_changeAnimationController.isAnimating ||
        _flipAnimationController.isAnimating) return;

    _updateFlashcardStatus();

    _logEvents(
        _swipeDismiss
            ? AnalyticsConstants.swipeFlashcard
            : AnalyticsConstants.tapNextFlashcard,
        additionalParams: {
          AnalyticsConstants.keyDirection: increase
              ? AnalyticsConstants.keyLeftSwipe
              : AnalyticsConstants.keyRightSwipe
        });

    if (_swipeDismiss) {
      widget.changeCardIndex(increase: increase);
      _changeAnimationController.value = 1;
    } else
      _changeAnimationController.forward();
  }

  void _updateFlashcardStatus() async {
    final result = await Injector.appInstance
        .getDependency<ApiServices>()
        .setFlashcardProgress(
          flashcardId: widget.flashCard.id,
          status: _flashcardStatus,
        );

    Injector.appInstance.getDependency<FlashcardRepository>().clearCache();

    if (result is ErrorResponse) print(result.toString());
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
    _flipAnimationController.dispose();
    _changeAnimationController.dispose();
    super.dispose();
  }

  void _switchCard() {
    _toggleDisplayState(false);
    _logEvents(AnalyticsConstants.tapFlashcardFlipBackward);
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bCard = height * FlashCardWidget.flashCardBottomMarginFactor;
    final wCard = width * FlashCardWidget.flashCardWidthFactor;
    final hCard = height * FlashCardWidget.flashCardHeightFactor;

    return Column(children: [
      Container(
        constraints: BoxConstraints.tight(Size(wCard, hCard)),
        margin: EdgeInsets.only(bottom: 20),
        alignment: Alignment.topCenter,
        child: GestureDetector(
            onTap: _switchCard,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 800),
              transitionBuilder: __transitionBuilder,
              layoutBuilder: (widget, list) =>
                  Stack(children: [widget, ...list]),
              child: _showFrontSide
                  ? _buildCardFront(bCard, hCard, wCard)
                  : _buildCardRear(bCard, hCard, wCard),
              switchInCurve: Curves.easeInBack,
              switchOutCurve: Curves.easeInBack.flipped,
            )),
      )
    ]);
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
