import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

enum FontColor {
  Content,
  Content2,
  Content3,
  Error,
  Accent,
  DividerColor,
  Accent2,
  Accent3,
  Questions,
  QualifyingText,
}

Color _getFontColor(BuildContext context, FontColor fontColor) {
  switch (fontColor) {
    case FontColor.Content2:
      return Style.of(context).colors.content2;
    case FontColor.Content3:
      return Style.of(context).colors.content3;
    case FontColor.Error:
      return Style.of(context).colors.error;
    case FontColor.Accent:
      return Style.of(context).colors.accent;
    case FontColor.Accent2:
      return Style.of(context).colors.accent2;
    case FontColor.Questions:
      return Style.of(context).colors.questions;
    case FontColor.DividerColor:
      return Style.of(context).colors.separator;
    case FontColor.Accent3:
      return Style.of(context).colors.accent3;
    case FontColor.QualifyingText:
      return Style.of(context).colors.qualifyingText;
    case FontColor.Content:
    default:
      return Style.of(context).colors.content;
  }
}

TextStyle normalResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 15, tablet: 25),
  );
}

TextStyle mediumResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, small: 11, large: 15.5, tablet: 20),
  );
}

TextStyle smallerResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 10, tablet: 16),
  );
}

TextStyle smallResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 13, tablet: 20),
  );
}

TextStyle bigResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 18, tablet: 28),
  );
}

TextStyle biggerResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 20, tablet: 32),
  );
}

TextStyle greatResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 25, tablet: 40),
  );
}
