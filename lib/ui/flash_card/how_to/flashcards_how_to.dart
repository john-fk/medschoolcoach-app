import 'package:Medschoolcoach/ui/flash_card/how_to/how_to_back.dart';
import 'package:Medschoolcoach/ui/flash_card/how_to/how_to_front.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/inkwell_image/inkwell_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class FlashcardsHowTo extends StatelessWidget {
  final bool front;
  final VoidCallback gotIt;

  const FlashcardsHowTo({
    @required this.front,
    @required this.gotIt,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Color.fromRGBO(0, 0, 0, 0.8),
        ),
        front ? HowToFrontWidget(gotIt) : HowToBackWidget(gotIt),
      ],
    );
  }

  static Widget buildGotItButton(BuildContext context, VoidCallback onTap) {
    return InkWellObject(
      key: const Key("tapToContinue"),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: whenDevice(context, large: 10, tablet: 15),
          horizontal: whenDevice(
            context,
            large: 20,
            tablet: 40,
          ),
        ),
        decoration: BoxDecoration(
          color: Style.of(context).colors.accent2,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          FlutterI18n.translate(context, "flashcards_how_to.got_it"),
          style: Style.of(context).font.medium2.copyWith(
                fontSize: whenDevice(
                  context,
                  large: 15,
                  tablet: 25,
                ),
              ),
          textAlign: TextAlign.center,
        ),
      ),
      onTap: onTap,
    );
  }

  static Widget buildIconWithText({
    @required BuildContext context,
    @required String translateKey,
    @required String iconAsset,
    double spaceBetween = 0,
  }) {
    final height = MediaQuery.of(context).size.height;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              iconAsset,
              height: whenDevice(
                context,
                large: 40,
                tablet: 80,
              ),
              color: Style.of(context).colors.content2,
            ),
            SizedBox(
              width: spaceBetween,
            ),
            Text(
              FlutterI18n.translate(context, translateKey),
              style: Style.of(context).font.medium2.copyWith(
                    fontSize: whenDevice(
                      context,
                      large: 15,
                      tablet: 25,
                    ),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        SizedBox(
          height: height * 0.05,
        ),
      ],
    );
  }
}
