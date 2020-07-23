import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangeVideoWidget extends StatelessWidget {
  final bool forward;
  final double size;
  final VoidCallback onTap;

  const ChangeVideoWidget({
    @required this.forward,
    @required this.size,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Style.of(context).colors.brightShadow,
        ),
        child: Center(
          child: Padding(
            padding: forward
                ? EdgeInsets.only(left: size / 10)
                : EdgeInsets.only(right: size / 10),
            child: SvgPicture.asset(
              forward
                  ? Style.of(context).svgAsset.nextVideo
                  : Style.of(context).svgAsset.previousVideo,
              width: size * 0.6,
            ),
          ),
        ),
      ),
    );
  }
}
