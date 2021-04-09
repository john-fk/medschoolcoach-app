import 'dart:ui';

import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/material.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  Style.of(context).pngAsset.emptyState,
                  width: 250,
                  height: 250,
                ),
                Text(title,
                  style: bigResponsiveFont(context,fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(message,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: Config.fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).primaryColor),
                    child: Text(ctaText,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}