import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

class WhiteBorderButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  WhiteBorderButton({
    @required this.text,
    @required this.onPressed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: whenDevice(
        context,
        large: 50,
        tablet: 80,
      ),
      child: ButtonTheme(
        child: OutlineButton(
          borderSide: BorderSide(color: Style.of(context).colors.content2),
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              whenDevice(
                context,
                large: 25,
                tablet: 50,
              ),
            ),
          ),
          child: Text(
            text,
            style: normalResponsiveFont(context,
                fontColor: FontColor.Content2, fontWeight: FontWeight.w500),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}
