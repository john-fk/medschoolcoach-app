import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isLoading;
  final EdgeInsets margin;

  SecondaryButton({
    @required this.text,
    @required this.onPressed,
    this.isLoading = false,
    this.margin,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Style(
      colors: AppColors(
        accent: Style.of(context).colors.content2,
        accent2: Style.of(context).colors.accent2,
        accent3: Style.of(context).colors.accent3,
        accent4: Style.of(context).colors.accent4,
        background: Style.of(context).colors.background,
        background2: Style.of(context).colors.background2,
        background3: Style.of(context).colors.background3,
        content: Style.of(context).colors.content,
        content2: Style.of(context).colors.accent,
        content3: Style.of(context).colors.content3,
        content4: Style.of(context).colors.content4,
        inputBackground: Style.of(context).colors.inputBackground,
        shadow: Style.of(context).colors.shadow,
        shadow2: Style.of(context).colors.shadow2,
        brightShadow: Style.of(context).colors.brightShadow,
        error: Style.of(context).colors.error,
        premium: Style.of(context).colors.premium,
        separator: Style.of(context).colors.separator,
        divider: Style.of(context).colors.divider,
        questions: Style.of(context).colors.questions,
        qualifyingText: Style.of(context).colors.qualifyingText,
        border: Style.of(context).colors.border,
        qbIncorrect: Style.of(context).colors.qbIncorrect,
        qbCorrect: Style.of(context).colors.qbCorrect,
        bottomSlider: Style.of(context).colors.bottomSlider,
      ),
      child: PrimaryButton(
        onPressed: onPressed,
        text: text,
        isLoading: isLoading,
        margin: margin,
      ),
    );
  }
}
