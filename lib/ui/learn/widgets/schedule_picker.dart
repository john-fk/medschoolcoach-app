import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_svg/svg.dart';

typedef StartSchedule(int days);

class SchedulePickerWidget extends StatelessWidget {
  final bool pickingSchedule;
  final StartSchedule startSchedule;
  final int currentScheduleLength;
  final AnalyticsProvider analyticsProvider;

  const SchedulePickerWidget({
    @required this.pickingSchedule,
    @required this.startSchedule,
    @required this.analyticsProvider,
    this.currentScheduleLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            bottom: 10,
            top: 6,
          ),
          child: Text(
            pickingSchedule
                ? FlutterI18n.translate(
                    context,
                    "schedule_screen.pick_schedule",
                  )
                : FlutterI18n.translate(
                    context,
                    "schedule_screen.update_schedule",
                  ),
            style: normalResponsiveFont(context, fontWeight: FontWeight.bold),
          ),
        ),
        PrimaryButton(
          onPressed: () {
            analyticsProvider
                .logEvent(AnalyticsConstants.tapPickScheduleLength, params: {
              AnalyticsConstants.keySource: AnalyticsConstants.screenLearn
            });
            showDialog<dynamic>(
              context: context,
              builder: (context) {
                return Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 32.0,
                          bottom: 16.0,
                          left: 16.0,
                          right: 16.0,
                        ),
                        child: SvgPicture.asset(
                          Style.of(context).svgAsset.pickSchedule,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Text(
                          pickingSchedule
                              ? FlutterI18n.translate(
                                  context,
                                  "schedule_screen.pick_schedule",
                                )
                              : FlutterI18n.translate(
                                  context,
                                  "schedule_screen.update_schedule",
                                ),
                          style: normalResponsiveFont(
                            context,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (pickingSchedule || currentScheduleLength != 30)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: PrimaryButton(
                            text: FlutterI18n.translate(
                              context,
                              "schedule_screen.schedule_days",
                              {
                                "number": "30",
                              },
                            ),
                            onPressed: () => startSchedule(30),
                          ),
                        ),
                      if (pickingSchedule || currentScheduleLength != 60)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 4,
                            bottom: 32.0,
                          ),
                          child: PrimaryButton(
                            text: FlutterI18n.translate(
                              context,
                              "schedule_screen.schedule_days",
                              {
                                "number": "60",
                              },
                            ),
                            onPressed: () => startSchedule(60),
                          ),
                        )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                );
              },
            );
          },
          text: FlutterI18n.translate(
            context,
            "schedule_screen.pick_schedule_length",
          ),
        )
      ],
    );
  }
}
