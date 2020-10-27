import 'dart:math';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_button.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_status.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter_html/style.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';
import 'package:native_mixpanel/native_mixpanel.dart';

import 'flash_card_widget.dart';

enum EmojiType {
  Neutral,
  Positive,
  Negative,
}

typedef SetFlashcardStatus(FlashcardStatus status);

class FlashCardBack extends StatefulWidget {
  final VoidCallback nextFlashcard;
  final FlashcardModel flashCard;
  final String progress;
  final FlashcardStatus flashcardStatus;
  final SetFlashcardStatus setFlashcardStatus;
  final VoidCallback flip;

  const FlashCardBack({
    Key key,
    @required this.nextFlashcard,
    @required this.flashCard,
    @required this.progress,
    @required this.flashcardStatus,
    @required this.setFlashcardStatus,
    @required this.flip,
  }) : super(key: key);

  @override
  _FlashCardBackState createState() => _FlashCardBackState();
}

class _FlashCardBackState extends State<FlashCardBack>
    with TickerProviderStateMixin {
  final Mixpanel _mixPanel = Injector.appInstance.getDependency<Mixpanel>();

  AnimationController _negativeAnimationController;
  AnimationController _neutralAnimationController;
  AnimationController _positiveAnimationController;
  Animation<double> _negativeAnimation;
  Animation<double> _neutralAnimation;
  Animation<double> _positiveAnimation;
  final animationDuration = const Duration(milliseconds: 300);
  String _anHtml = "";
  String _anHtmlDefinition = "";
  String _anHtmlExample = "";

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _anHtmlDefinition = widget.flashCard.definition;
    _anHtmlDefinition = _anHtmlDefinition.replaceAll("<sup>", "&#8288<sup>");
    _anHtmlDefinition = _anHtmlDefinition.replaceAll("<sub>", "&#8288<sub>");

    _anHtmlExample = widget.flashCard.example;
    _anHtmlExample = _anHtmlExample.replaceAll("<sup>", "&#8288<sup>");
    _anHtmlExample = _anHtmlExample.replaceAll("<sub>", "&#8288<sub>");

    _anHtml = widget.flashCard.front;
    _anHtml = _anHtml.replaceAll("<sup>", "&#8288<sup>");
    _anHtml = _anHtml.replaceAll("<sub>", "&#8288<sub>");
  }

  void _setupAnimation() {
    _negativeAnimationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    _neutralAnimationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    _positiveAnimationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );

    _negativeAnimation =
        Tween<double>(begin: 1, end: 0.3).animate(_negativeAnimationController)
          ..addListener(() {
            setState(() {});
          });
    _neutralAnimation =
        Tween<double>(begin: 1, end: 0.3).animate(_neutralAnimationController)
          ..addListener(() {
            setState(() {});
          });
    _positiveAnimation =
        Tween<double>(begin: 1, end: 0.3).animate(_positiveAnimationController)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final xOffset = MediaQuery.of(context).size.width *
            FlashCardWidget.flashCardWidthFactor -
        whenDevice(
          context,
          large: 30,
          tablet: 60,
        );
    return GestureDetector(
      onTap: widget.flip,
      child: Container(
        color: Colors.transparent,
        child: Transform.translate(
          offset: Offset(xOffset, 0),
          child: Transform(
            transform: Matrix4.rotationY(pi),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlashCardStatusWidget(
                  progress: widget.progress,
                  status: widget.flashCard.status,
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                              child: Html(
                                data: _anHtml,
                                style: {
                                  "html": Style.fromTextStyle(
                                    medstyles.Style.of(context)
                                        .font
                                        .bold
                                        .copyWith(
                                          fontSize: whenDevice(
                                            context,
                                            small: 18.0,
                                            large: 20.0,
                                            tablet: 40.0,
                                          ),
                                        ),
                                  )
                                },
                              )),
                          widget.flashCard.definitionImage == null ||
                                  widget.flashCard.definitionImage.isEmpty
                              ? Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                                  child: Html(
                                    data: _anHtmlDefinition,
                                    style: {
                                      "html": Style.fromTextStyle(
                                        medstyles.Style.of(context)
                                            .font
                                            .normal
                                            .copyWith(
                                              fontSize: whenDevice(
                                                context,
                                                small: 15.0,
                                                large: 12.0,
                                                tablet: 25.0,
                                              ),
                                            ),
                                      )
                                    },
                                  ))
                              : ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: height * 0.15),
                                  child: Image.network(
                                      widget.flashCard.definitionImage),
                                ),
                          const SizedBox(height: 15),
                          widget.flashCard.exampleImage == null ||
                                  widget.flashCard.exampleImage.isEmpty
                              ? Container(
                                  margin:
                                      EdgeInsets.fromLTRB(0, 0, width / 15, 0),
                                  child: Html(
                                    data: _anHtmlExample,
                                    style: {
                                      "html": Style.fromTextStyle(
                                        medstyles.Style.of(context)
                                            .font
                                            .normal
                                            .copyWith(
                                              fontSize: whenDevice(
                                                context,
                                                small: 15.0,
                                                large: 12.0,
                                                tablet: 25.0,
                                              ),
                                            ),
                                      )
                                    },
                                  ))
                              : ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxHeight: height * 0.15),
                                  child: Image.network(
                                      widget.flashCard.exampleImage),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Text(
                            FlutterI18n.translate(
                              context,
                              "flashcard_screen.confidence_interval",
                            ),
                            style: medstyles.Style.of(context)
                                .font
                                .medium
                                .copyWith(
                                  fontSize: whenDevice(
                                    context,
                                    large: 15,
                                    small: 12,
                                    tablet: 30,
                                  ),
                                ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: whenDevice(
                              context,
                              large: 5,
                              tablet: 15,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              _emoji(EmojiType.Negative, context),
                              _emoji(EmojiType.Neutral, context),
                              _emoji(EmojiType.Positive, context),
                            ],
                          ),
                        ],
                      ),
                    ),
                    FlashCardButton(
                      onPress: () => widget.nextFlashcard(),
                      text: FlutterI18n.translate(
                          context, "flashcard_screen.next"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _tapEmoji(EmojiType type) {
    widget.setFlashcardStatus(getFlahcardStatusEnum(
      type.toString().substring(10).toLowerCase(),
    ));

    _logMixPanelEvent(type);

    switch (type) {
      case EmojiType.Neutral:
        _neutralAnimationController.reverse();
        _positiveAnimationController.forward();
        _negativeAnimationController.forward();
        break;
      case EmojiType.Positive:
        _neutralAnimationController.forward();
        _positiveAnimationController.reverse();
        _negativeAnimationController.forward();
        break;
      case EmojiType.Negative:
        _neutralAnimationController.forward();
        _positiveAnimationController.forward();
        _negativeAnimationController.reverse();
        break;
    }
  }

  void _logMixPanelEvent(EmojiType type) {
    _mixPanel.track(Config.mixPanelFlashcardEvent, {
      "front": _anHtml,
      "id": widget.flashCard.id,
      "confidence": type.toString().substring(10).toLowerCase(),
    });
  }

  Widget _emoji(EmojiType type, BuildContext context) {
    String asset;
    double opacityValue = 0;
    switch (type) {
      case EmojiType.Neutral:
        asset = medstyles.Style.of(context).svgAsset.neutral;
        opacityValue = _neutralAnimation.value;
        break;
      case EmojiType.Positive:
        asset = medstyles.Style.of(context).svgAsset.positive;
        opacityValue = _positiveAnimation.value;
        break;
      case EmojiType.Negative:
        asset = medstyles.Style.of(context).svgAsset.negative;
        opacityValue = _negativeAnimation.value;
        break;
    }
    return GestureDetector(
      onTap: () => _tapEmoji(type),
      key: Key(type.toString()),
      child: Opacity(
        opacity: opacityValue,
        child: SvgPicture.asset(
          asset,
          width: whenDevice(
            context,
            small: 35,
            large: 40,
            tablet: 70,
          ),
          color: medstyles.Style.of(context).colors.content,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positiveAnimationController.dispose();
    _negativeAnimationController.dispose();
    _neutralAnimationController.dispose();
    super.dispose();
  }
}
