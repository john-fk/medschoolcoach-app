import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorIcon extends StatelessWidget {
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
        color: Style.of(context).colors.questions,
      ),
      child: Icon(
        Icons.clear,
        size: size * 0.66,
        color: Style.of(context).colors.content2,
      ),
      width: size,
      height: size,
    );
  }
}
