import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

class PopBackQuestions extends StatelessWidget {
  final VoidCallback customPop;

  const PopBackQuestions({Key key, this.customPop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key("app_bar_back_button"),
      onTap: customPop ?? () => Navigator.of(context).pop(),
      child: Icon(Icons.arrow_back_ios_rounded,
          color: Style.of(context).colors.content2,
          size: whenDevice(context, large: 28, tablet: 44)),
    );
  }
}
