import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/progress_bar/button_progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;
  final EdgeInsets margin;
  final Color color;
  final bool isSmall;
  final Color fontColor;
  final double fontSize;

  PrimaryButton({
    @required this.text,
    @required this.onPressed,
    this.isLoading = false,
    this.margin,
    this.isSmall = false,
    this.color,
    this.fontColor,
    this.fontSize,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: double.infinity,
      height: whenDevice(
        context,
        large: isSmall ? 35 : 50,
        tablet: isSmall ? 65 : 80,
      ),
      child: ButtonTheme(
        child: RaisedButton(
          onPressed: isLoading ? () {} : onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              whenDevice(
                context,
                large: 25,
                tablet: 40,
              ),
            ),
          ),
          child: isLoading
              ? Center(
                  child: ButtonProgressBar(),
                )
              : AutoSizeText(
                  text,
                  maxLines:1,
                  minFontSize: 0,
                  stepGranularity: 0.1,
                  maxFontSize: fontSize ?? normalResponsiveFont(context).fontSize,
                  style:TextStyle(
                    fontWeight: FontWeight.w500,
                    color:fontColor ?? getFontColor(context,FontColor.Content2),
                    fontSize: fontSize ?? normalResponsiveFont(context).fontSize
                  ),
                  textAlign: TextAlign.center,
                  ),
          color: color ?? Style.of(context).colors.accent,
        ),
      ),
    );
  }
}
