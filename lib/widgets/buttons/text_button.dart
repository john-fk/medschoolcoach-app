import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class TextButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Alignment alignment;
  final EdgeInsets margin;
  final bool secondaryButton;

  const TextButton({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.margin,
    this.alignment,
    this.secondaryButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: Text(text,
              style: secondaryButton
                  ? normalResponsiveFont(context, fontColor: FontColor.Content2)
                  : normalResponsiveFont(context)),
        ),
      );
}
