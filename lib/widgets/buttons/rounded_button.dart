import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;

  RoundedButton(
      {this.onPressed,
      this.color,
      this.text});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        onPressed: onPressed,
        color: color?? Style.of(context).colors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Text(
          text,
          style: bigResponsiveFont(context,
              fontColor: FontColor.Content2, fontWeight: FontWeight.w500),
        ));
  }
}
