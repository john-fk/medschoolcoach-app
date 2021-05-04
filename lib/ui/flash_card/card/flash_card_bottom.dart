import 'dart:math';

import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/api/models/flashcard_model.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart' as medstyles;
import 'package:flutter/foundation.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:injector/injector.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'dart:async';

enum EmojiType {
  Neutral,
  Positive,
  Negative,
}

typedef nextFlashCard({bool increase, String trigger, String cardstatus});

class FlashCardBottom extends StatefulWidget {
  final String status;
  final nextFlashCard nextCard;
  final VoidCallback animateCard;
  final bool updatedOption;
  FlashCardBottom(
      {this.status,
      this.updatedOption = false,
      this.nextCard,
      this.animateCard,
      Key key})
      : super(key: key);

  @override
  FlashCardBottomState createState() => FlashCardBottomState();
}

class FlashCardBottomState extends State<FlashCardBottom>
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
  String definition = "";
  String example = "";
  String front = "";
  String _anHtml = "";
  String _anHtmlDefinition = "";
  String _anHtmlExample = "";
  bool _updatedOption = false;
  EmojiType selectedEmoji;
  bool _externalUpdate;
  double _externalOpacity;
  String _externalEmoji;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _anHtmlDefinition = definition;
    _anHtmlDefinition = _anHtmlDefinition.replaceAll("<sup>", "&#8288<sup>");
    _anHtmlDefinition = _anHtmlDefinition.replaceAll("<sub>", "&#8288<sub>");

    _anHtmlExample = example;
    _anHtmlExample = _anHtmlExample.replaceAll("<sup>", "&#8288<sup>");
    _anHtmlExample = _anHtmlExample.replaceAll("<sub>", "&#8288<sub>");

    _anHtml = front;
    _anHtml = _anHtml.replaceAll("<sup>", "&#8288<sup>");
    _anHtml = _anHtml.replaceAll("<sub>", "&#8288<sub>");
    _externalUpdate = false;
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
    if (widget.updatedOption && !_externalUpdate) {
      selectedEmoji = null;
      _updatedOption = false;

      Future.delayed(const Duration(milliseconds: 500), () {
        selectedEmoji = null;
        _updatedOption = false;
      });
    }

    if (_updatedOption || selectedEmoji == null || _externalUpdate) {
      _neutralAnimationController.reverse();
      _positiveAnimationController.reverse();
      _negativeAnimationController.reverse();
      String confidence = widget.status;
      if (_externalUpdate)
        confidence = _externalEmoji;
      else if (_updatedOption && selectedEmoji != null)
        confidence = selectedEmoji.toString().split(".")[1];

      switch (confidence) {
        case "Negative":
          selectedEmoji = EmojiType.Negative;
          _positiveAnimationController.forward();
          _neutralAnimationController.forward();
          break;
        case "Positive":
          selectedEmoji = EmojiType.Positive;
          _neutralAnimationController.forward();
          _negativeAnimationController.forward();
          break;
        case "Neutral":
          selectedEmoji = EmojiType.Neutral;
          _positiveAnimationController.forward();
          _negativeAnimationController.forward();
          break;
        default:
          selectedEmoji = null;
      }
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                FlutterI18n.translate(
                  context,
                  "flashcard_screen.confidence_interval",
                ),
                style: medstyles.Style.of(context).font.medium.copyWith(
                    fontSize: whenDevice(
                      context,
                      small: 10,
                      large: 13,
                      tablet: 20,
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
                  SizedBox(width: MediaQuery.of(context).size.width / 15),
                  _emoji(EmojiType.Neutral, context),
                  SizedBox(width: MediaQuery.of(context).size.width / 15),
                  _emoji(EmojiType.Positive, context),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        )
      ],
    );
  }

  void cancelUpdate() {
    setState(() {
      _externalUpdate = false;
      _externalOpacity = 1;
      _externalEmoji = "";
      selectedEmoji = null;
      _updatedOption = true;
    });
  }

  void cancelExternal() {
    _externalUpdate = false;
    selectedEmoji = null;
  }

  void externalUpdate(String text, double opacity) {
    setState(() {
      _externalUpdate = true;
      _externalOpacity = opacity;
      _externalEmoji = text;
    });
  }

  void swipeEmoji(String status) {
    //_tapEmoji(EnumToString.fromString(EmojiType.values, status),false);
  }

  void _tapEmoji(EmojiType type, bool isTap) {
    setState(() {
      selectedEmoji = type;
      _updatedOption = true;
      _externalUpdate = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      selectedEmoji = null;
      _updatedOption = false;
      widget.nextCard(
          increase: true,
          trigger: "bottom_navigation",
          cardstatus: type.toString().substring(10));
    });
  }

  Widget _emoji(EmojiType type, BuildContext context) {
    String asset;
    double opacityValue = 0;
    switch (type) {
      case EmojiType.Neutral:
        asset = medstyles.Style.of(context).svgAsset.neutral;
        opacityValue = _externalUpdate
            ? (selectedEmoji == type ? _externalOpacity : 0.3)
            : _neutralAnimation.value;
        break;
      case EmojiType.Positive:
        asset = medstyles.Style.of(context).svgAsset.positive;
        opacityValue = _externalUpdate
            ? (selectedEmoji == type ? _externalOpacity : 0.3)
            : _positiveAnimation.value;
        break;
      case EmojiType.Negative:
        asset = medstyles.Style.of(context).svgAsset.negative;
        opacityValue = _externalUpdate
            ? (selectedEmoji == type ? _externalOpacity : 0.3)
            : _negativeAnimation.value;
        break;
    }
    return GestureDetector(
      onTap: () => _tapEmoji(type, true),
      key: Key(type.toString()),
      child: Opacity(
        opacity: opacityValue,
        child: SvgPicture.asset(
          asset,
          fit: BoxFit.fitHeight,
          color: selectedEmoji == type
              ? selectedEmoji == EmojiType.Neutral
                  ? Color(0xFFFFB84A)
                  : selectedEmoji == EmojiType.Positive
                      ? Color(0xFF0AD1A5)
                      : Color(0xFFFF8131)
              : Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
