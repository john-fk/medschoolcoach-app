import 'package:Medschoolcoach/ui/section/section_screen.dart';
import 'package:Medschoolcoach/utils/api/models/section.dart';
import 'package:Medschoolcoach/utils/extensions/color/hex_color.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryCell extends StatelessWidget {
  final Section section;

  CategoryCell({
    @required this.section,
  }) : super(key: Key(section.name));

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(3),
      color: HexColor.fromHex(
        section.setting.backgroundColor,
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.section,
            arguments: SectionScreenData(
              sectionId: section.id,
              sectionName: section.name,
              numberOfCourses: section.amountOfVideos,
            ),
          );
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  height: whenDevice(context, large: 100, tablet: 200),
                  width: whenDevice(context, large: 100, tablet: 200),
                  child: SvgPicture.network(
                    section.setting.backgroundIcon,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Style.of(context).colors.content2,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Text(
                          section.percentage.toString() + "%",
                          style: TextStyle(
                            color: HexColor.fromHex(
                              section.setting.backgroundColor,
                            ),
                            fontWeight: FontWeight.w500,
                            fontSize:
                                whenDevice(context, large: 13, tablet: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      section.name,
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
                      _getCellSubtitle(context),
                      textAlign: TextAlign.center,
                      style: normalResponsiveFont(
                        context,
                        fontColor: FontColor.Content2,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCellSubtitle(BuildContext context) {
    if (section.amountOfVideos == null) return "";
    return FlutterI18n.translate(
      context,
      "app_bar.section_subtitle",
      {
        "number": section.amountOfVideos.toString(),
      },
    );
  }
}
