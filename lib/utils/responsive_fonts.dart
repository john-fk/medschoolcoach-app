import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

enum FontColor {
  Content,
  Content2,
  Content3,
  Content4,
  Error,
  Accent,
  DividerColor,
  Accent2,
  Accent3,
  Accent4,
  Questions,
  QualifyingText,
  Premium,
  Unselected,
  BannerOrange,
  HalfWhite,
  White
}

Color _getFontColor(BuildContext context, FontColor fontColor) {
  switch (fontColor) {
    case FontColor.Content2:
      return Style.of(context).colors.content2;
    case FontColor.Content3:
      return Style.of(context).colors.content3;
    case FontColor.Content4:
      return Style.of(context).colors.content4;
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
    case FontColor.Accent4:
      return Style.of(context).colors.accent4;
    case FontColor.QualifyingText:
      return Style.of(context).colors.qualifyingText;
    case FontColor.Premium:
      return Style.of(context).colors.premium;
    case FontColor.BannerOrange:
      return Color(0xFFFE7B5D);
    case FontColor.Unselected:
      return Color(0xff757575);
    case FontColor.HalfWhite:
      return Color(0x7AFFFFFF);
    case FontColor.White:
      return Color(0xFFFFFFFF);
    case FontColor.Content:
    default:
      return Style.of(context).colors.content;
  }
}

TextStyle normalResponsiveFont(BuildContext context,
    {FontWeight fontWeight = FontWeight.normal,
    FontColor fontColor = FontColor.Content,
    double opacity = 1,
    TextStyle style}) {
  assert(opacity >= 0 && opacity <= 1);
  var textStyle = TextStyle(
    color: _getFontColor(context, fontColor).withOpacity(opacity),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 15, tablet: 25),
  );

  if (style != null) return textStyle.merge(style);
  return textStyle;
}

TextStyle mediumResponsiveFont(BuildContext context,
    {FontWeight fontWeight = FontWeight.normal,
    FontColor fontColor = FontColor.Content,
    double opacity = 1,
    TextStyle style}) {
  assert(opacity >= 0 && opacity <= 1);
  TextStyle textStyle = TextStyle(
    color: _getFontColor(context, fontColor).withOpacity(opacity),
    fontWeight: fontWeight,
    fontSize:
        whenDevice(context, small: 11, medium: 13, large: 15.5, tablet: 17),
  );

  if (style != null) return textStyle.merge(style);
  return textStyle;
}

TextStyle smallerResponsiveFont(BuildContext context,
    {FontWeight fontWeight = FontWeight.normal,
    FontColor fontColor = FontColor.Content,
    double opacity = 1}) {
  assert(opacity >= 0 && opacity <= 1);
  return TextStyle(
    color: _getFontColor(context, fontColor).withOpacity(opacity),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 10, tablet: 16),
  );
}

TextStyle smallResponsiveFont(BuildContext context,
    {FontWeight fontWeight = FontWeight.normal,
    FontColor fontColor = FontColor.Content,
    double opacity = 1}) {
  assert(opacity >= 0 && opacity <= 1);
  return TextStyle(
    color: _getFontColor(context, fontColor).withOpacity(opacity),
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
    fontSize: whenDevice(context, small: 14, medium: 15, large: 16, tablet: 23),
  );
}

TextStyle biggerResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
  double opacity = 1,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor).withOpacity(opacity),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, medium: 15, large: 20, tablet: 32),
  );
}

TextStyle greatResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
  double opacity = 1,
}) {
  return TextStyle(
    color: _getFontColor(context, fontColor).withOpacity(opacity),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 25, tablet: 40),
  );
}

TextStyle greatestResponsiveFont(
  BuildContext context, {
  FontWeight fontWeight = FontWeight.normal,
  FontColor fontColor = FontColor.Content,
  double opacity = 1,
}) {
  assert(opacity >= 0 && opacity <= 1);
  return TextStyle(
    color: _getFontColor(context, fontColor).withOpacity(opacity),
    fontWeight: fontWeight,
    fontSize: whenDevice(context, large: 40, tablet: 55),
  );
}
