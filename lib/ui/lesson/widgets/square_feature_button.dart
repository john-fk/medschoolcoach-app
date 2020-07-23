import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:flutter/material.dart';

class SquareFeatureButton extends StatelessWidget {
  final Color color;
  final String text;
  final Widget icon;
  final VoidCallback onTap;

  const SquareFeatureButton({
    @required this.color,
    @required this.text,
    @required this.icon,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: onTap,
        child: Padding(
          padding: EdgeInsets.all(whenDevice(
            context,
            small: 5,
            large: 10,
            tablet: 20,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(alignment: Alignment.centerRight, child: icon),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: normalResponsiveFont(
                    context,
                    fontWeight: FontWeight.w500,
                    fontColor: FontColor.Content2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
