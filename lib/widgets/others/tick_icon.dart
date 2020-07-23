import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TickIcon extends StatelessWidget {
  final double customSize;

  const TickIcon({Key key, this.customSize}) : super(key: key);

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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          size / 2,
        ),
        color: Style.of(context).colors.accent2,
      ),
      child: Icon(
        Icons.done,
        size: size * 0.66,
        color: Style.of(context).colors.content2,
      ),
      width: size,
      height: size,
    );
  }
}
