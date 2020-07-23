import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:flutter/material.dart';

class FlashCardButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;

  FlashCardButton({
    @required this.text,
    @required this.onPress,
  }) : super(key: Key(text));

  @override
  Widget build(BuildContext context) {
    return InkWellObject(
      borderRadius: BorderRadius.circular(
        whenDevice(
          context,
          large: 25.0,
          tablet: 50,
        ),
      ),
      onTap: onPress,
      child: Container(
        alignment: Alignment.center,
        width: whenDevice(
          context,
          large: 70,
          small: 60,
          tablet: 130,
        ),
        padding: whenDevice(
          context,
          small: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          large: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          tablet: const EdgeInsets.symmetric(
            vertical: 15,
          ),
        ),
        decoration: BoxDecoration(
          color: Style.of(context).colors.accent,
          borderRadius: BorderRadius.circular(
            whenDevice(
              context,
              large: 25.0,
              tablet: 50,
            ),
          ),
        ),
        child: Text(text,
            style: whenDevice(context,
                large: Style.of(context).font.normal2,
                tablet: Style.of(context).font.normal2.copyWith(fontSize: 30))),
      ),
    );
  }
}
