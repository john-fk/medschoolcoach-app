import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

class WideFeatureButton extends StatelessWidget {
  final Color color;
  final String text;
  final Widget icon;
  final VoidCallback onTap;
  final EdgeInsets padding;

  const WideFeatureButton({
    @required this.color,
    @required this.text,
    @required this.icon,
    @required this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key(text),
      height: whenDevice(
        context,
        large: 70,
        tablet: 110,
      ),
      padding: padding,
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: color,
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: Style.of(context).font.bold2.copyWith(
                    fontSize: whenDevice(
                      context,
                      large: 18,
                      small: 16,
                      tablet: 30,
                    ),
                  ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
