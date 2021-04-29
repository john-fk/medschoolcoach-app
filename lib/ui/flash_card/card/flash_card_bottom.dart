import 'dart:math';

import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/ui/flash_card/widgets/flash_card_button.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';
import 'dart:async';

enum EmojiType {
  Neutral,
  Positive,
  Negative,
}

typedef SetFlashcardStatus(FlashcardStatus status);

class FlashCardBottom extends StatefulWidget {
  final VoidCallback nextFlashcard;
  final FlashcardModel flashCard;
  final String progress;
  final FlashcardStatus flashcardStatus;
  final SetFlashcardStatus setFlashcardStatus;
  final VoidCallback flip;

  const FlashCardBottom({
    Key key,
    @required this.nextFlashcard,
    @required this.flashCard,
    @required this.progress,
    @required this.flashcardStatus,
    @required this.setFlashcardStatus,
    @required this.flip,
  }) : super(key: key);

  @override
  _FlashCardBottomState createState() => _FlashCardBottomState();
}

class _FlashCardBottomState extends State<FlashCardBottom>
    with TickerProviderStateMixin {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

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
  Timer _timer;

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
    return Row(
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
                style: medstyles.Style.of(context).font.medium.copyWith(
                    fontSize: whenDevice(
                      context,
                      large: 15,
                      small: 12,
                      tablet: 30,
                    ),
                    color: Color(0x7AFFFFFF)),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _emoji(EmojiType.Negative, context),
                  SizedBox(width: 10),
                  _emoji(EmojiType.Neutral, context),
                  SizedBox(width: 10),
                  _emoji(EmojiType.Positive, context),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void _tapEmoji(EmojiType type) {
    widget.setFlashcardStatus(getFlahcardStatusEnum(
      type.toString().substring(10).toLowerCase(),
    ));

    _logAnalyticsEvent(type);

    switch (type) {
      case EmojiType.Neutral:
        break;
      case EmojiType.Positive:
        break;
      case EmojiType.Negative:
        break;
    }

    _timer = Timer(const Duration(milliseconds: 400), () {
      widget.nextFlashcard();
    });
  }

  void _logAnalyticsEvent(EmojiType type) {
    _analyticsProvider
        .logEvent(AnalyticsConstants.tapFlashcardConfidence, params: {
      "id": widget.flashCard.id,
      "front": _anHtml,
      "confidence": describeEnum(type).toLowerCase()
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
          height: whenDevice(
            context,
            small: 15,
            large: 25,
            tablet: 35,
          ),
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
