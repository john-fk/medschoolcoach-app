import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TickIcon extends StatelessWidget {
  final double customSize;
  final bool flipColor;

  const TickIcon({Key key, this.customSize, this.flipColor = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = customSize == null
        ? whenDevice(
            context,
            large: 20.0,
            tablet: 32.0,
          )
        : customSize;

    return Container(
        child: SvgPicture.asset(
      !flipColor
          ? Style.of(context).svgAsset.qbCorrect
          : Style.of(context).svgAsset.qbCorrectFlip,
      height: size,
      width: size,
    ));
  }
}
