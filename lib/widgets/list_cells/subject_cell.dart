import 'package:Medschoolcoach/utils/api/models/setting.dart';
import 'package:Medschoolcoach/utils/extensions/color/hex_color.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubjectCell extends StatelessWidget {
  final String subjectName;
  final String itemsWithNumber;
  final Setting setting;
  final VoidCallback onTap;

  SubjectCell({
    @required this.subjectName,
    @required this.setting,
    @required this.onTap,
    this.itemsWithNumber = "",
  }) : super(key: Key(subjectName));

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(3),
      color: HexColor.fromHex(
        setting.backgroundColor,
      ),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: whenDevice(context, large: 100, tablet: 200),
                width: whenDevice(context, large: 100, tablet: 200),
                child: SvgPicture.network(
                  setting.backgroundIcon,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    subjectName,
                    textAlign: TextAlign.center,
                    style: Style.of(context).font.medium2.copyWith(
                          fontSize: whenDevice(
                            context,
                            large: 20,
                            tablet: 32,
                          ),
                        ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    itemsWithNumber,
                    textAlign: TextAlign.center,
                    style: normalResponsiveFont(
                      context,
                      fontColor: FontColor.Content2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
