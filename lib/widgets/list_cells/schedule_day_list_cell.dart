import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/others/tick_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class DayItemData {
  final int day;
  bool completed;
  bool selected;

  DayItemData({
    @required this.completed,
    @required this.day,
    @required this.selected,
  });
}

class ScheduleDayListCell extends StatelessWidget {
  final DayItemData itemData;
  final VoidCallback onTap;

  const ScheduleDayListCell({
    Key key,
    this.itemData,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: whenDevice(context, large: 54, tablet: 80),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: itemData.selected
                      ? Style.of(context).colors.content
                      : Colors.transparent,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        FlutterI18n.translate(
                          context,
                          "schedule_screen.day",
                        ),
                        style: smallResponsiveFont(
                          context,
                          fontWeight: FontWeight.w500,
                          fontColor: itemData.selected
                              ? FontColor.Content2
                              : FontColor.Content,
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        "${itemData.day}",
                        style: smallResponsiveFont(
                          context,
                          fontWeight: FontWeight.w500,
                          fontColor: itemData.selected
                              ? FontColor.Content2
                              : FontColor.Content,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            itemData.completed
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: TickIcon(
                      customSize: whenDevice(context, large: 14, tablet: 22),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
