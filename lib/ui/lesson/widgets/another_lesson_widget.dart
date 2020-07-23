import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:flutter/material.dart';

class AnotherLessonWidget extends StatelessWidget {
  final List<Widget> children;
  final double contentWidth;
  final VoidCallback onTap;

  AnotherLessonWidget({
    @required this.children,
    @required this.contentWidth,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anotherLessonWidgetHeight = whenDevice(
      context,
      small: 56.0,
      large: 75.0,
      tablet: 130.0,
    );

    final borderRadius = BorderRadius.circular(
      whenDevice(
        context,
        large: 50,
        tablet: 80,
      ),
    );

    return InkWellObject(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        height: anotherLessonWidgetHeight,
        width: contentWidth * 0.48,
        decoration: BoxDecoration(
          color: Style.of(context).colors.accent,
          borderRadius: borderRadius,
        ),
        padding: EdgeInsets.symmetric(
            // vertical: 15,
            // horizontal: 20,
            ),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
