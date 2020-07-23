import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:flutter/material.dart';

class CancelWidget extends StatelessWidget {
  final VoidCallback onTap;
  static const size = 25.0;

  const CancelWidget({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellObject(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Stack(children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Style.of(context).colors.brightShadow,
          ),
        ),
        Positioned.fill(
            child: Center(
          child: Icon(
            Icons.close,
            color: Style.of(context).colors.content2,
            size: size * 0.7,
          ),
        ))
      ]),
    );
  }
}
