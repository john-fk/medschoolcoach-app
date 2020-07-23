import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:flutter/material.dart';

class GlobalProgressWidgetCell extends StatelessWidget {
  final String name;
  final String progress;
  final Widget icon;
  final Color color;
  final VoidCallback onTap;

  const GlobalProgressWidgetCell({
    @required this.name,
    @required this.progress,
    @required this.icon,
    @required this.color,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWellObject(
      key: Key(name),
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: whenDevice(
            context,
            large: 15,
            small: 5,
            tablet: width * 0.05,
          ),
          vertical: whenDevice(
            context,
            large: 30,
            small: 20,
            tablet: width * 0.1,
          ),
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            icon,
            Column(
              children: <Widget>[
                Text(
                  name,
                  style: normalResponsiveFont(
                    context,
                    fontColor: FontColor.Content2,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  progress,
                  style: normalResponsiveFont(
                    context,
                    fontColor: FontColor.Content2,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
