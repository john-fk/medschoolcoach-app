import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
        child: SvgPicture.asset(
      !flipColor
          ? Style.of(context).svgAsset.qbIncorrect
          : Style.of(context).svgAsset.qbIncorrectFlip,
      height: size,
      width: size,
    ));
  }
}
