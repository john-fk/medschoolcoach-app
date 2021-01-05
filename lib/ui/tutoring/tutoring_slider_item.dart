import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class TutoringSliderItem extends StatelessWidget {
  final TutoringSlider sliderModel;

  const TutoringSliderItem({this.sliderModel});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                width: size.width / 1.2,
                height: size.height / 2.47,
                child: SvgPicture.asset(
                  sliderModel.image,
                )),
            Padding(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 5, left: 10, right: 10),
              child: _getHeader(sliderModel.header, context),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 23, right: 23),
              child: _getDescription(sliderModel.description, context),
            ),
          ],
        ),
      ),
    );
  }

  Text _getHeader(String text, BuildContext context) {
    return Text(
      _getText(text, context),
      style: bigResponsiveFont(context,
          fontWeight: FontWeight.bold, fontColor: FontColor.Accent),
    );
  }

  Text _getDescription(String text, BuildContext context) {
    return Text(
      _getText(text, context),
      style: mediumResponsiveFont(context).copyWith(color: Colors.black),
      textAlign: TextAlign.center,
    );
  }

  String _getText(String text, BuildContext context) {
    return FlutterI18n.translate(context, text);
  }
}
