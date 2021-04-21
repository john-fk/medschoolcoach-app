import 'dart:ui';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class EmptyStateView extends StatelessWidget {

  final String title;
  final String message;
  final String ctaText;
  final Image image;
  final Function onTap;

  const EmptyStateView({
    Key key,
    this.title,
    this.message,
    this.ctaText,
    this.image,
    this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: isTablet(context) ? 40 : 20),
            Image.asset(
              Style.of(context).pngAsset.emptyState,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            SizedBox(height: isTablet(context) ? 40 : 20),
            Column(
              children: [
                SizedBox(height: isTablet(context) ? 40 : 20),
                Text(title,
                  style: greatResponsiveFont(context,
                      fontWeight: FontWeight.bold,
                      fontColor: FontColor.Content),
                ),
                SizedBox(height: isTablet(context) ? 40 : 20),
                Text(message,
                  style: mediumResponsiveFont(context,
                      fontWeight: FontWeight.normal,
                      fontColor: FontColor.Content3),
                  textAlign: TextAlign.center,
                ),
            SizedBox(height: isTablet(context) ? 40 : 20),
                PrimaryButton(
                    text: FlutterI18n.translate(
                      context,
                      "empty_state.button",
                    ),
                    onPressed: onTap),
                SizedBox(height: isTablet(context) ? 40 : 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}