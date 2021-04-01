import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

class TimeBanner extends StatelessWidget {
  final int daysLeft;
  final bool isSchedule;

  TimeBanner({this.daysLeft, this.isSchedule});

  @override
  Widget build(BuildContext context) {
    if (daysLeft <= 0) return Container();

    int bannerNumber;
    FontColor fontColor;
    String leadingIcon;

    if (daysLeft > 20) {
      bannerNumber = 1;
      fontColor = FontColor.Accent4;
      leadingIcon = "star1.svg";
    } else if (daysLeft > 10) {
      bannerNumber = 2;
      fontColor = FontColor.Premium;
      leadingIcon = "rocket.svg";
    } else if (daysLeft > 0) {
      bannerNumber = 3;
      fontColor = FontColor.BannerOrange;
      leadingIcon = "alarmclock.svg";
    }

    return Container(
      width: isSchedule ? MediaQuery.of(context).size.width * 0.88
          : MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/png/banner$bannerNumber.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/svg/$leadingIcon",
              height: 14,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "$daysLeft " + (isSchedule ?
              // ignore: lines_longer_than_80_chars
              FlutterI18n.translate(context, daysLeft == 1 ? "schedule_screen.day_left_schedule" : "schedule_screen.days_left_schedule") :
                  // ignore: lines_longer_than_80_chars
                  FlutterI18n.translate(context, daysLeft == 1 ? "schedule_screen.day_left" : "schedule_screen.days_left")),
              style: smallResponsiveFont(context,
                  fontColor: fontColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      )),
    );
  }
}
