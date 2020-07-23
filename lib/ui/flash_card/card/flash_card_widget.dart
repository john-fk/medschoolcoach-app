import 'dart:async';
import 'dart:math';

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

typedef SetFront({@required bool front});

class FlashCardWidget extends StatefulWidget {
  final FlashcardModel flashCard;
  final ChangeCardIndex changeCardIndex;
  final String progress;
  final SetFront setFront;
  final bool front;

  static const flashCardWidthFactor = 0.75;
  static const flashCardHeightFactor = 0.75;
  static const flashCardBottomMarginFactor = 0.1;
  static const animationDurationValue = 500;

  const FlashCardWidget({
    Key key,
    @required this.flashCard,
    @required this.changeCardIndex,
    @required this.progress,
    @required this.front,
    @required this.setFront,
  }) : super(key: key);

  @override
  _FlashCardWidgetState createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget>
    with TickerProviderStateMixin {
  bool _swipeDissmis = false;
  FlashcardStatus _flashcardStatus;
  Orientation _currentOrientation;

  Animation<double> _rotationAnimation;
  Animation<double> _offsetAnimation;
  Animation<double> _fadeAnimation;

  AnimationController _flipAnimationController;
  AnimationController _changeAnimationController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    _flashcardStatus = widget.flashCard.status;
  }

  void _setupAnimations() {
    _flipAnimationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: FlashCardWidget.animationDurationValue),
    );

    _changeAnimationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: FlashCardWidget.animationDurationValue),
    );

    _rotationAnimation =
        Tween<double>(begin: 0, end: pi).animate(_flipAnimationController)
          ..addListener(() {
            setState(() {});
          });

    _fadeAnimation =
        Tween<double>(begin: 1, end: 0).animate(_changeAnimationController)
          ..addListener(() {
            setState(() {});
            if (_changeAnimationController.status ==
                AnimationStatus.completed) {
              _changeAnimationController.reverse();
              _flipAnimationController.reset();
              if (!_swipeDissmis) widget.changeCardIndex();
              setState(() {
                _swipeDissmis = false;
                widget.setFront(front: true);
              });
            }
          });
  }

  void _setupTransformAnimation() {
    _offsetAnimation = Tween<double>(
            begin: 0,
            end: MediaQuery.of(context).size.width *
                FlashCardWidget.flashCardWidthFactor)
        .animate(_flipAnimationController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if (MediaQuery.of(context).orientation != _currentOrientation) {
      _currentOrientation = MediaQuery.of(context).orientation;
      _setupTransformAnimation();
      setState(() {});
    }

    return Center(
      child: Dismissible(
        direction: widget.progress.startsWith("1/")
            ? DismissDirection.endToStart
            : DismissDirection.horizontal,
        key: Key(widget.flashCard.id),
        onDismissed: _onDissmised,
        child: Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(_offsetAnimation?.value ?? 0, 0),
            child: Transform(
              transform: Matrix4.rotationY(_rotationAnimation.value),
              child: Container(
                margin: EdgeInsets.only(
                  bottom: height * FlashCardWidget.flashCardBottomMarginFactor,
                ),
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
                    width: width * FlashCardWidget.flashCardWidthFactor,
                    height: height * FlashCardWidget.flashCardHeightFactor,
                    child: widget.front
                        ? FlashCardFront(
                            progress: widget.progress,
                            flashCard: widget.flashCard,
                            flip: _switchSides,
                          )
                        : FlashCardBack(
                            progress: widget.progress,
                            flashCard: widget.flashCard,
                            nextFlashcard: _nextFlashcard,
                            flashcardStatus: _flashcardStatus,
                            setFlashcardStatus: _setFlashcardStatus,
                            flip: _switchSidesReverse,
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setFlashcardStatus(FlashcardStatus status) {
    setState(() {
      _flashcardStatus = status;
    });
  }

  void _onDissmised(DismissDirection direction) {
    setState(() {
      _swipeDissmis = true;
    });

    _nextFlashcard(increase: direction == DismissDirection.endToStart);
  }

  void _nextFlashcard({bool increase = true}) async {
    if (_changeAnimationController.isAnimating) return;

    _updateFlashcardStatus();

    if (_swipeDissmis) {
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

  void _switchSides() {
    if (_flipAnimationController.isAnimating) return;
    if (_flashcardStatus == FlashcardStatus.New)
      setState(() {
        _flashcardStatus = FlashcardStatus.Seen;
      });
    _flipAnimationController.forward();
    _changeSideContent();
  }

  void _switchSidesReverse() {
    if (_flipAnimationController.isAnimating) return;
    _flipAnimationController.reverse();
    _changeSideContent();
  }

  void _changeSideContent() async {
    await Timer(
      Duration(milliseconds: FlashCardWidget.animationDurationValue ~/ 2),
      () => widget.setFront(front: !widget.front),
    );
  }

  @override
  void dispose() {
    _flipAnimationController.dispose();
    _changeAnimationController.dispose();
    super.dispose();
  }
}
