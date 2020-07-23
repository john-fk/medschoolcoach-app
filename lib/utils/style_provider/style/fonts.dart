part of '../style.dart';

class _AppFonts {
  static const smallFontSize = 13.0;
  static const regularFontSize = 15.0;
  static const bigFontSize = 18.0;
  static const greatFontSize = 25.0;

  final TextStyle normal;
  final TextStyle normalBig;
  final TextStyle underlineNormal;
  final TextStyle underlineError;
  final TextStyle medium;
  final TextStyle mediumSmall;
  final TextStyle bold;
  final TextStyle boldGreat;
  final TextStyle normal2;
  final TextStyle normal2Small;
  final TextStyle normal2SmallW500;
  final TextStyle normal2w500size20;
  final TextStyle normal2BoldSize20;
  final TextStyle normal2Semi;
  final TextStyle normal2Big;
  final TextStyle normal2Great;
  final TextStyle medium2;
  final TextStyle bold2;
  final TextStyle bold2Big;
  final TextStyle bold2Great;
  final TextStyle normal3;
  final TextStyle normal3Small;
  final TextStyle error3Small;
  final TextStyle error;
  final TextStyle smallW500Accent;
  final TextStyle bold3;
  final TextStyle normalAccent;
  final TextStyle mediumAccent;
  final TextStyle mediumAccent2;
  final TextStyle boldAccent;
  final TextStyle normalAccent2;
  final TextStyle boldAccent2;
  final TextStyle premium;
  final TextStyle continueWatchingButton;

  _AppFonts(AppColors colors)
      : normal = TextStyle(
          color: colors.content,
          fontWeight: FontWeight.normal,
          fontSize: regularFontSize,
        ),
        normalBig = TextStyle(
          color: colors.content,
          fontWeight: FontWeight.normal,
          fontSize: bigFontSize,
        ),
        underlineNormal = TextStyle(
          color: colors.content,
          fontWeight: FontWeight.normal,
          fontSize: regularFontSize,
          decoration: TextDecoration.underline,
        ),
        underlineError = TextStyle(
          color: colors.error,
          fontWeight: FontWeight.normal,
          fontSize: regularFontSize,
          decoration: TextDecoration.underline,
        ),
        medium = TextStyle(
          color: colors.content,
          fontWeight: FontWeight.w500,
          fontSize: regularFontSize,
        ),
        mediumSmall = TextStyle(
          color: colors.content,
          fontWeight: FontWeight.w500,
          fontSize: smallFontSize,
        ),
        bold = TextStyle(
          color: colors.content,
          fontWeight: FontWeight.bold,
          fontSize: regularFontSize,
        ),
        boldGreat = TextStyle(
          color: colors.content,
          fontWeight: FontWeight.bold,
          fontSize: greatFontSize,
        ),
        normal2 = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.normal,
          fontSize: regularFontSize,
        ),
        normal2Small = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.normal,
          fontSize: smallFontSize,
        ),
        normal2SmallW500 = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.w500,
          fontSize: smallFontSize,
        ),
        normal2Semi = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        normal2w500size20 = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        normal2BoldSize20 = TextStyle(
            color: colors.content2,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            height: 1.5),
        normal2Great = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.normal,
          fontSize: greatFontSize,
        ),
        normal2Big = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.normal,
          fontSize: bigFontSize,
        ),
        bold2 = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.bold,
          fontSize: regularFontSize,
        ),
        bold2Great = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.bold,
          fontSize: greatFontSize,
        ),
        bold2Big = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.bold,
          fontSize: bigFontSize,
        ),
        medium2 = TextStyle(
          color: colors.content2,
          fontWeight: FontWeight.w500,
          fontSize: regularFontSize,
        ),
        normal3 = TextStyle(
          color: colors.content3,
          fontWeight: FontWeight.normal,
          fontSize: regularFontSize,
        ),
        normal3Small = TextStyle(
          color: colors.content3,
          fontWeight: FontWeight.normal,
          fontSize: smallFontSize,
        ),
        error3Small = TextStyle(
          color: colors.error,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        error = TextStyle(
          color: colors.error,
          fontWeight: FontWeight.normal,
          fontSize: regularFontSize,
        ),
        bold3 = TextStyle(
          color: colors.content3,
          fontWeight: FontWeight.bold,
          fontSize: regularFontSize,
        ),
        smallW500Accent = TextStyle(
          color: colors.accent,
          fontWeight: FontWeight.w500,
          fontSize: smallFontSize,
        ),
        normalAccent = TextStyle(
          color: colors.accent,
          fontWeight: FontWeight.normal,
          fontSize: regularFontSize,
        ),
        mediumAccent = TextStyle(
          color: colors.accent,
          fontWeight: FontWeight.w500,
          fontSize: regularFontSize,
        ),
        mediumAccent2 = TextStyle(
          color: colors.accent2,
          fontWeight: FontWeight.w500,
          fontSize: regularFontSize,
        ),
        boldAccent = TextStyle(
          color: colors.accent,
          fontWeight: FontWeight.bold,
          fontSize: regularFontSize,
        ),
        normalAccent2 = TextStyle(
          color: colors.accent2,
          fontWeight: FontWeight.normal,
          fontSize: regularFontSize,
        ),
        boldAccent2 = TextStyle(
          color: colors.accent2,
          fontWeight: FontWeight.bold,
          fontSize: regularFontSize,
        ),
        premium = TextStyle(
          color: colors.premium,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        continueWatchingButton = TextStyle(
            color: colors.accent, fontWeight: FontWeight.bold, fontSize: 10);
}
