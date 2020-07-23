import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PopBackButton extends StatelessWidget {
  final VoidCallback customPop;

  const PopBackButton({Key key, this.customPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key("app_bar_back_button"),
      onTap: customPop ?? () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SvgPicture.asset(
          Style.of(context).svgAsset.backArrowDark,
          color: Style.of(context).colors.content2,
          width: whenDevice(context, large: 25, tablet: 40),
        ),
      ),
    );
  }
}
