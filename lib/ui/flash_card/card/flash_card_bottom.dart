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
import 'flash.dart';

class FlashCardBottom extends StatefulWidget {
  final EmojiType status;
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
  final animationDuration = Duration(milliseconds: Durations.emojiFade);
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
  EmojiType _externalEmoji;
  bool preventClick = false;

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
      EmojiType confidence = widget.status;
      if (_externalUpdate)
        confidence = _externalEmoji;
      else if (_updatedOption && selectedEmoji != null)
        confidence = selectedEmoji;

      selectedEmoji = confidence;

      switch (selectedEmoji) {
        case EmojiType.Negative:
          _positiveAnimationController.forward();
          _neutralAnimationController.forward();
          break;
        case EmojiType.Positive:
          _neutralAnimationController.forward();
          _negativeAnimationController.forward();
          break;
        case EmojiType.Neutral:
          _positiveAnimationController.forward();
          _negativeAnimationController.forward();
          break;
        default:
          selectedEmoji = null;
      }
    }
    return SafeArea(
        minimum: EdgeInsets.all(whenDevice(
          context,
          large: 15,
          tablet: 30,
        )),
        child: Row(
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
                          small: 13,
                          large: 15,
                          tablet: 25,
                        ),
                        color: Color(0x7AFFFFFF)),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: whenDevice(
                      context,
                      large: 15,
                      tablet: 30,
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
                ],
              ),
            )
          ],
        ));
  }

  void cancelUpdate() {
    setState(() {
      _externalUpdate = false;
      _externalOpacity = 1;
      _externalEmoji = null;
      selectedEmoji = null;
      _updatedOption = true;
    });
  }

  void cancelExternal() {
    _externalUpdate = false;
    selectedEmoji = null;
  }

  void externalUpdate(EmojiType emoji, double opacity) {
    setState(() {
      _externalUpdate = true;
      _externalOpacity = opacity;
      _externalEmoji = emoji;
    });
  }

  void _tapEmoji(EmojiType type) {
    if (preventClick) return;
    preventClick = true;
    setState(() {
      selectedEmoji = type;
      _updatedOption = true;
      _externalUpdate = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _updatedOption = false;
      widget.nextCard(
          increase: true,
          trigger: "bottom_navigation",
          cardstatus: getFlashcardStatusEnum(
              EnumToString.convertToString(selectedEmoji)));
      selectedEmoji = null;
    });
  }

  Widget _emoji(EmojiType type, BuildContext context) {
    String asset;
    double opacityValue = 0;
    switch (type) {
      case EmojiType.Neutral:
        asset = medstyles.Style.of(context).pngAsset.eNeutral;
        opacityValue = _externalUpdate
            ? (selectedEmoji == type ? _externalOpacity : 0.3)
            : _neutralAnimation.value;
        break;
      case EmojiType.Positive:
        asset = medstyles.Style.of(context).pngAsset.ePositive;
        opacityValue = _externalUpdate
            ? (selectedEmoji == type ? _externalOpacity : 0.3)
            : _positiveAnimation.value;
        break;
      case EmojiType.Negative:
        asset = medstyles.Style.of(context).pngAsset.eNegative;
        opacityValue = _externalUpdate
            ? (selectedEmoji == type ? _externalOpacity : 0.3)
            : _negativeAnimation.value;
        break;
    }
    return GestureDetector(
      onTap: () => _tapEmoji(type),
      key: Key(type.toString()),
      child: Opacity(
        opacity: opacityValue,
        child: Image(
          image: AssetImage(asset),
          height: whenDevice(
            context,
            large: 30,
            tablet: 60,
          ),
          color: selectedEmoji == type
              ? selectedEmoji == EmojiType.Neutral
                  ? EmojiColors.neutral
                  : selectedEmoji == EmojiType.Positive
                      ? EmojiColors.positive
                      : EmojiColors.negative
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
