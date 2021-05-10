import 'package:flutter/material.dart';

enum EmojiType {
  Neutral,
  Positive,
  Negative,
}

enum CardAction { Up, Left, Right, Down, Reset, Success }
enum FlashcardStatus { Positive, Negative, Neutral, Seen, New }

typedef nextFlashCard(
    {bool increase, String trigger, FlashcardStatus cardstatus});
typedef updateEmoji(CardAction event, double opacity);
typedef logEvent(String event, {dynamic additionalParams});

EmojiType enumFlashcardStatusToEmoji(FlashcardStatus status) {
  switch (status) {
    case FlashcardStatus.Negative:
      return EmojiType.Negative;
    case FlashcardStatus.Positive:
      return EmojiType.Positive;
    case FlashcardStatus.Neutral:
      return EmojiType.Neutral;
    case FlashcardStatus.Seen:
    case FlashcardStatus.New:
    default:
      return null;
  }
}

CardAction enumFlashcardStatusToCardAction(FlashcardStatus status) {
  switch (status) {
    case FlashcardStatus.Negative:
      return CardAction.Left;
    case FlashcardStatus.Positive:
      return CardAction.Right;
    case FlashcardStatus.Neutral:
      return CardAction.Down;
    case FlashcardStatus.Seen:
    case FlashcardStatus.New:
    default:
      return null;
  }
}

class EmojiColors {
  static Color none = Color(0xFFFFB84A);
  static Color neutral = Color(0xFFFFB84A);
  static Color positive = Color(0xFF0AD1A5);
  static Color negative = Color(0xFFFF8131);
}

class Durations {
  static const int emojiFade = 300;
  static const int emojiFadeGap = emojiFade + 100;
  static const int cardFade = 200;
  static const int cardFadeGap = cardFade + 100;
  static const int cardSwipeGone = 100;
}
