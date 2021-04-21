import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class MorePageListCell extends StatelessWidget {
  final String iconAssetName;
  final String cellText;
  final String trailing;
  final VoidCallback onTap;
  final bool intend;
  final bool svgAsset;
  double iconSize;
  final double trailingOpacity;

  MorePageListCell({
    @required this.iconAssetName,
    @required this.cellText,
    @required this.onTap,
    this.trailing = "",
    this.intend = false,
    this.svgAsset = true,
    this.iconSize,
    this.trailingOpacity = 1.0
  });

  @override
  Widget build(BuildContext context) {
    if(iconSize == null) {
      iconSize  = whenDevice(
        context,
        large: 23.0,
        tablet: 28.0,
      );
    }

    return InkWell(
      key: Key(cellText),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 27.0,
          vertical: whenDevice(context, large: 24, tablet: 38),
        ),
        child: Row(
          children: <Widget>[
            if (intend)
              const SizedBox(
                width: 30,
              ),
            svgAsset
                ? SvgPicture.asset(
                    iconAssetName,
                    width: iconSize,
                    height: iconSize
                  )
                : Image.asset(
                    iconAssetName,
                    width: iconSize,
                    height: iconSize
                  ),
            const SizedBox(
              width: 20,
            ),
            Text(
              cellText,
              style: normalResponsiveFont(context),
            ),
            Spacer(),
            Text(
              trailing,
              style: normalResponsiveFont(context,
                  fontColor: FontColor.Accent4,
                  fontWeight: FontWeight.w500, opacity: trailingOpacity),
            )
          ],
        ),
      ),
    );
  }
}
