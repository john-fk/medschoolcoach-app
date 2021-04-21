import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class TutoringSliderItem extends StatelessWidget {
  final TutoringSlider sliderModel;

  const TutoringSliderItem({this.sliderModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
                width: size.width / 1.2,
                height: size.height * 0.32,
                child: Image(image: AssetImage(sliderModel.image),
                )),
            Container(
              height: size.height * 0.17,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 2, left: 10, right: 10),
                    child: _getHeader(sliderModel.header, context),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 5, left: 23, right: 23),
                    child: _getDescription(sliderModel.description, context),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  AutoSizeText _getHeader(String text, BuildContext context) {
    return AutoSizeText(
      _getText(text, context),
      maxLines: 1,
      style: bigResponsiveFont(context,
          fontWeight: FontWeight.bold, fontColor: FontColor.Accent3),
      textAlign: TextAlign.center,
    );
  }

  AutoSizeText _getDescription(String text, BuildContext context) {
    return AutoSizeText(
      _getText(text, context),
      maxLines: 3,
      style: mediumResponsiveFont(context).copyWith(color: Colors.black),
      textAlign: TextAlign.center,
    );
  }

  String _getText(String text, BuildContext context) {
    return FlutterI18n.translate(context, text);
  }
}
