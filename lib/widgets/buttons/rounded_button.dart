import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;
  double size;

  RoundedButton(
      {this.onPressed,
      this.color,
      this.text,
      this.size});

  @override
  Widget build(BuildContext context) {
    size = size ?? bigResponsiveFont(context).fontSize;
    return FlatButton(
        minWidth:  size * 12,
        onPressed: onPressed,
        color: color?? Style.of(context).colors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
              fontSize:size,
              color: getFontColor(context, FontColor.Content2),
              fontWeight: FontWeight.w500)
        ));
  }
}
