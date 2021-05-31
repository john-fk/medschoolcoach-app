import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class NoProgressCard extends StatelessWidget {
  final String title;
  final String image;
  final String text;
  final String buttonText;
  final VoidCallback onTapButton;

  NoProgressCard(
      {this.title = "",
      this.image,
      this.text,
      this.buttonText,
      this.onTapButton});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTapButton,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(
                image:  AssetImage(image),
                height: 90
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                FlutterI18n.translate(context, text),
                style: normalResponsiveFont(
                    context, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: RoundedButton(
                  text: FlutterI18n.translate(context, buttonText),
                  size: smallerResponsiveFont(context).fontSize,
                  color: Style.of(context).colors.accent,
                  onPressed: onTapButton,
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
