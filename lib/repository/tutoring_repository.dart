import 'package:Medschoolcoach/repository/repository.dart';
import 'package:Medschoolcoach/utils/api/models/tutoring_slider.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';

class TutoringRepository implements Repository{
  List<TutoringSlider> fetchSliders(BuildContext context) {
    final List<TutoringSlider> sliders = [
      TutoringSlider(
          image:  Style.of(context).svgAsset.slider99percentileTutors,
          header: 'tutoring_sliders.slider_one_header',
          description: 'tutoring_sliders.slider_one_description'),
      TutoringSlider(
          image: Style.of(context).svgAsset.sliderIncredibleTeachers,
          header: 'tutoring_sliders.slider_two_header',
          description: 'tutoring_sliders.slider_two_description'),
      TutoringSlider(
          image: Style.of(context).svgAsset.sliderNewMCAT,
          header: 'tutoring_sliders.slider_three_header',
          description: 'tutoring_sliders.slider_three_description'),
      TutoringSlider(
          image: Style.of(context).svgAsset.sliderCompletelyPersonalized,
          header: 'tutoring_sliders.slider_four_header',
          description: 'tutoring_sliders.slider_four_description'),
    ];
    return sliders;
  }

  @override
  void clearCache() {
  }
}
