import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';

class TutoringRepository implements Repository {
  List<TutoringSlider> fetchSliders(BuildContext context) {
    final List<TutoringSlider> sliders = [
      TutoringSlider(
          image: Style.of(context).svgAsset.tutoringSliderOne,
          header: 'tutoring_sliders.slider_one_header',
          description: 'tutoring_sliders.slider_one_description'),
      TutoringSlider(
          image: Style.of(context).svgAsset.tutoringSliderTwo,
          header: 'tutoring_sliders.slider_two_header',
          description: 'tutoring_sliders.slider_two_description'),
      TutoringSlider(
          image: Style.of(context).svgAsset.tutoringSliderThree,
          header: 'tutoring_sliders.slider_three_header',
          description: 'tutoring_sliders.slider_three_description')
    ];
    return sliders;
  }

  @override
  void clearCache() {}
}
