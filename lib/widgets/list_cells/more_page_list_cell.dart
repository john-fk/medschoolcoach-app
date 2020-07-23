import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MorePageListCell extends StatelessWidget {
  final String iconAssetName;
  final String cellText;
  final VoidCallback onTap;
  final bool intend;
  final bool svgAsset;

  const MorePageListCell({
    @required this.iconAssetName,
    @required this.cellText,
    @required this.onTap,
    this.intend = false,
    this.svgAsset = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = whenDevice(
      context,
      large: 17.0,
      tablet: 28.0,
    );
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
                width: 20,
              ),
            svgAsset
                ? SvgPicture.asset(
                    iconAssetName,
                    width: iconSize,
                  )
                : Image.asset(
                    iconAssetName,
                    width: iconSize,
                  ),
            const SizedBox(
              width: 20,
            ),
            Text(
              cellText,
              style: normalResponsiveFont(context),
            )
          ],
        ),
      ),
    );
  }
}
