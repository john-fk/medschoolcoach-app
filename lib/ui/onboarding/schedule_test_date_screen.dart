import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/toasts.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:Medschoolcoach/widgets/app_bars/transparent_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/date_picker/date_picker.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
import 'package:Medschoolcoach/utils/format_date.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SchedulingTestDateScreen extends StatefulWidget {
  final String source;

  SchedulingTestDateScreen({this.source = ""});

  @override
  _SchedulingTestDateScreenState createState() =>
      _SchedulingTestDateScreenState();
}

class _SchedulingTestDateScreenState extends State<SchedulingTestDateScreen> {
  Size size;
  DateRangePickerController dateController;
  DateTime scheduleDate;
  bool isLoading = false;
  bool isEditingTestDate = false;
  final userManager = Injector.appInstance.getDependency<UserManager>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(Routes.scheduleTestDate, widget.source);
    dateController = DateRangePickerController();
    userManager.getTestDate().then((value) {
      setState(() {
        isEditingTestDate = value != null;
        dateController.selectedDate = scheduleDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.source == Routes.profile_screen
            ? TransparentAppBar(
                leading: BackButton(
                  color: Colors.black,
                ),
              )
            : null,
        body: SafeArea(child: _buildBody()));
  }

  Widget _buildBody() {
    size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.source != Routes.profile_screen)
              SizedBox(
                height: size.height * 0.05,
              ),
            Image(
              image: AssetImage("assets/png/test_date_picker.png"),
              height: size.height * 0.25,
              fit: BoxFit.contain,
            ),
            Spacer(),
            _heading(),
            SizedBox(
              height: size.height * 0.03,
            ),
            _subheading(),
            Spacer(),
            _showTestDate(),
            Spacer(),
            PrimaryButton(
              text: FlutterI18n.translate(context, _getPrimaryButtonLabel())
                  .toUpperCase(),
              onPressed: showCustomDatePicker,
              color: Style.of(context).colors.accent4,
            ),
            if (scheduleDate == null) SizedBox(height: 45),
            if (widget.source != Routes.profile_screen || scheduleDate != null)
              TextButton(
                  onPressed: _onPressSecondaryButton,
                  child: Text(
                    FlutterI18n.translate(
                        context,
                        scheduleDate == null
                            ? "onboarding_scheduling.i_dont_have_test_date"
                            : "onboarding_scheduling.remove_test_date"),
                    style: mediumResponsiveFont(context,
                        fontColor: FontColor.Content4,
                        opacity: 0.6,
                        style: TextStyle(decoration: TextDecoration.underline)),
                  )),
            Spacer()
          ],
        ),
      ),
    );
  }

  String _getPrimaryButtonLabel() {
    if (scheduleDate == null)
      return "onboarding_scheduling.select_test_date";
    else
      return "onboarding_scheduling.edit_test_date";
  }

  void _onPressSecondaryButton() {
    if (scheduleDate == null) {
      _analyticsProvider.logEvent("tap_test_date_skip", params: null);
      Navigator.pushNamed(context, Routes.timePerDay,
          arguments: Routes.onboarding);
    } else {
      _showRemoveTestDateDialog();
    }
  }

  void showCustomDatePicker() {
    if (scheduleDate != null) dateController.selectedDate = scheduleDate;
    showDialog<Dialog>(
        context: context,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: DatePicker(
                dateController: dateController,
                onDateConfirm: () {
                  _updateTestDate();
                },
              ),
            ));
  }

  Future<void> _updateTestDate() async {
    userManager.updateTestDate(dateController.selectedDate);
    setState(() {
      isLoading = true;
    });
    final result = await Injector.appInstance
        .getDependency<ApiServices>()
        .setTestDate(dateController.selectedDate);

    if (result is ErrorResponse) {
      showToast(
          text: FlutterI18n.translate(context, "general.net_error"),
          context: context,
          color: Style.of(context).colors.error);
    } else {
      scheduleDate = dateController.selectedDate;
      _analyticsProvider.logEvent(
          isEditingTestDate ? "tap_test_date_update" : "tap_test_date_confirm",
          params: null);
      if (widget.source != Routes.profile_screen) {
        Navigator.pushNamed(context, Routes.timePerDay,
            arguments: Routes.onboarding);
      } else {
        Navigator.pop(context);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _heading() {
    String heading = "onboarding_scheduling.heading";
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Text(
        FlutterI18n.translate(context, heading),
        style: biggerResponsiveFont(context,
            fontWeight: FontWeight.w500, fontColor: FontColor.Accent3),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _subheading() {
    String subheading = "onboarding_scheduling.subheading";
    return Text(
      FlutterI18n.translate(context, subheading),
      style: bigResponsiveFont(context,
          fontWeight: FontWeight.w400, fontColor: FontColor.Content),
      textAlign: TextAlign.center,
    );
  }

  Widget _showTestDate() {
    String date = "";
    double opacity = 1;
    if (widget.source == Routes.profile_screen) {
      date = "No Test Date";
      opacity = 0.3;
    }
    if (scheduleDate != null) {
      date = formatDate(scheduleDate, 'MM/dd/yyyy');
      opacity = 1;
    }

    return isLoading
        ? ProgressBar()
        : Text(
            date,
            style: greatResponsiveFont(context,
                fontColor: FontColor.Accent4,
                fontWeight: FontWeight.w400,
                opacity: opacity),
          );
  }

  void _showRemoveTestDateDialog() {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "onboarding_scheduling.are_you_sure",
          ),
          content: FlutterI18n.translate(
            context,
            "onboarding_scheduling.remove_date_dialog_content",
          ),
          actions: <DialogActionData>[
            DialogActionData(
                text: FlutterI18n.translate(
                  context,
                  "general.cancel",
                ),
                onTap: () => {
                      Navigator.pop(context),
                    }),
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "general.remove",
              ),
              onTap: () async {
                _analyticsProvider.logEvent("tap_test_date_remove",
                    params: null);
                Navigator.pop(context);

                dateController.selectedDate = null;
                setState(() {
                  scheduleDate = null;
                  userManager.removeTestDate();
                });
                await Injector.appInstance
                    .getDependency<ApiServices>()
                    .setTestDate(dateController.selectedDate);
              },
            ),
          ],
        );
      },
    );
  }
}
