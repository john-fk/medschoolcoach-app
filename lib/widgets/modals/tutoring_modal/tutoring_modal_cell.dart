import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';

class TutoringModalCell extends StatelessWidget {
  final String asset;
  final String title;
  final String description;

  const TutoringModalCell({
    Key key,
    this.asset,
    this.title,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              asset,
              fit: BoxFit.fill,
              width: whenDevice(context, large: 50, tablet: 80),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: normalResponsiveFont(
                      context,
                      fontColor: FontColor.Accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: Style.of(context).font.normal.copyWith(
                          fontSize: whenDevice(
                            context,
                            small: 12,
                            large: 14,
                            tablet: 18,
                          ),
                        ),
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: whenDevice(context, large: 15, tablet: 35),
        ),
      ],
    );
  }
}
