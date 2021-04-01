import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatefulWidget {
  final DateRangePickerController dateController;
  final VoidCallback onDateConfirm;

  DatePicker({@required this.dateController, @required this.onDateConfirm});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  bool showWarning = false;

  @override
  void initState() {
    super.initState();
    widget.dateController.addPropertyChangedListener((property) {
      if (property == "selectedDate")
        setState(() {
          DateTime selectedDate = widget?.dateController?.selectedDate;

          if (selectedDate != null &&
              selectedDate.difference(DateTime.now()) < Duration(days: 15))
            showWarning = true;
          else
            showWarning = false;
        });
    });
  }

  @override
  void dispose() {
    widget.dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FlutterI18n.translate(
                context, "onboarding_scheduling.select_test_date"),
            style: biggerResponsiveFont(context,
                fontColor: FontColor.Accent, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 10,
          ),
          _getCustomizedDatePicker(context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.dateController.selectedDate = null;
                    },
                    child: Text(
                      FlutterI18n.translate(context, "general.cancel"),
                      style: smallResponsiveFont(context,
                          fontColor: FontColor.Content,
                          fontWeight: FontWeight.w700),
                    )),
              ),
              Flexible(
                child: PrimaryButton(
                    isSmall: true,
                    color: Style.of(context).colors.accent4,
                    text: FlutterI18n.translate(context, "general.confirm"),
                    onPressed: widget.dateController.selectedDate != null
                        ? () {
                            Navigator.of(context).pop();
                            widget.onDateConfirm();
                          }
                        : null),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          AnimatedCrossFade(
            sizeCurve: Curves.easeInOutQuart,
            duration: Duration(milliseconds: 300),
            crossFadeState: showWarning
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Style.of(context).colors.questions.withOpacity(0.7),
                  size: 18,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  FlutterI18n.translate(context, "calendar.error_msg"),
                  style: smallerResponsiveFont(context,
                      fontColor: FontColor.Questions,
                      fontWeight: FontWeight.w500,
                      opacity: 0.7),
                ))
              ],
            ),
            secondChild: Container(),
          )
        ],
      ),
    );
  }

  SfDateRangePicker _getCustomizedDatePicker(BuildContext context) {
    Color highlightColor = Style.of(context).colors.accent;
    Color cellTextColor = Style.of(context).colors.content;

    if (widget.dateController.selectedDate != null &&
        widget.dateController.selectedDate.difference(DateTime.now()) <
            Duration(days: 15))
      showWarning = true;
    else
      showWarning = false;

    if (showWarning) highlightColor = Style.of(context).colors.questions;

    return SfDateRangePicker(
      selectionShape: DateRangePickerSelectionShape.rectangle,
      selectionColor: highlightColor,
      selectionTextStyle: TextStyle(color: Colors.white, fontSize: 14),
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 500)),
      headerStyle: DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(
            fontSize: 18,
            color: cellTextColor,
          )),
      yearCellStyle: DateRangePickerYearCellStyle(
        // todayTextStyle: TextStyle(color: highlightColor, fontSize: 14),
        textStyle: TextStyle(color: cellTextColor, fontSize: 14),
        disabledDatesTextStyle:
            TextStyle(color: Style.of(context).colors.content.withOpacity(0.8)),
        leadingDatesTextStyle:
            TextStyle(color: cellTextColor.withOpacity(0.5), fontSize: 14),
      ),
      showNavigationArrow: true,
      // todayHighlightColor: highlightColor,
      monthViewSettings: DateRangePickerMonthViewSettings(
        firstDayOfWeek: 1,
        viewHeaderStyle: DateRangePickerViewHeaderStyle(
            textStyle: smallerResponsiveFont(context,
                fontWeight: FontWeight.w500, fontColor: FontColor.Accent)),
        dayFormat: 'E',
        showTrailingAndLeadingDates: false,
      ),
      controller: widget.dateController,
    );
  }
}
