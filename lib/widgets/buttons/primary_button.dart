import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/progress_bar/button_progress_bar.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;
  final EdgeInsets margin;
  final Color color;
  final bool isSmall;

  PrimaryButton({
    @required this.text,
    @required this.onPressed,
    this.isLoading = false,
    this.margin,
    this.isSmall = false,
    this.color,
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
              : Text(
                  text,
                  style: normalResponsiveFont(
                    context,
                    fontColor: FontColor.Content2,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
          color: color ?? Style.of(context).colors.accent,
        ),
      ),
    );
  }
}
