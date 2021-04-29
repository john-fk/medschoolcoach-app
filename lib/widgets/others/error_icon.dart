import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorIcon extends StatelessWidget {
  final double customSize;
  final bool flipColor;

  const ErrorIcon({Key key, this.customSize, this.flipColor = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = whenDevice(
      context,
      large: 20.0,
      tablet: 32.0,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          whenDevice(context, large: 10, tablet: 20),
        ),
        color: flipColor
            ? Style.of(context).colors.questions
            : Style.of(context).colors.content2,
      ),
      child: Icon(
        Icons.clear,
        size: size * 0.66,
        color: flipColor
            ? Style.of(context).colors.content2
            : Style.of(context).colors.questions,
      ),
      width: size,
      height: size,
    );
  }
}
