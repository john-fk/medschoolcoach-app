import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/modals/tutoring_modal/tutoring_modal_cell.dart';
import 'package:Medschoolcoach/widgets/progrss_bar/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
import 'package:url_launcher/url_launcher.dart';

class TutoringModal extends StatefulWidget {
  const TutoringModal({
    Key key,
  }) : super(key: key);

  @override
  _TutoringModalState createState() => _TutoringModalState();
}

class _TutoringModalState extends State<TutoringModal> {
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  bool _loading = false;
  static const _anotherTimeSuccessCode = "412";
  static const _supportPhoneNumber = "8883819509";

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          15,
          20,
          15,
          MediaQuery.of(context).padding.bottom + 20,
        ),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TutoringModalCell(
                  asset: Style.of(context).pngAsset.tutoringModalPercentile,
                  title: FlutterI18n.translate(
                    context,
                    "tutoring_modal.percentile_title",
                  ),
                  description: FlutterI18n.translate(
                    context,
                    "tutoring_modal.percentile_description",
                  ),
                ),
                TutoringModalCell(
                  asset: Style.of(context).pngAsset.tutoringModalTeachers,
                  title: FlutterI18n.translate(
                    context,
                    "tutoring_modal.teachers_title",
                  ),
                  description: FlutterI18n.translate(
                    context,
                    "tutoring_modal.teachers_description",
                  ),
                ),
                TutoringModalCell(
                  asset: Style.of(context).pngAsset.tutoringModalMcat,
                  title: FlutterI18n.translate(
                    context,
                    "tutoring_modal.mcat_title",
                  ),
                  description: FlutterI18n.translate(
                    context,
                    "tutoring_modal.mcat_description",
                  ),
                ),
                TutoringModalCell(
                  asset: Style.of(context).pngAsset.tutoringModalPersonalized,
                  title: FlutterI18n.translate(
                    context,
                    "tutoring_modal.personalized_title",
                  ),
                  description: FlutterI18n.translate(
                    context,
                    "tutoring_modal.personalized_description",
                  ),
                ),
                _buildButton(context),
              ],
            ),
            if (_loading)
              Positioned.fill(
                child: Container(
                  height: 300,
                  child: Center(
                    child: ProgressBar(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Container(
      key: const Key("request info"),
      width: double.infinity,
      height: whenDevice(context, large: 40, tablet: 60),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            whenDevice(
              context,
              large: 25,
              tablet: 35,
            ),
          ),
        ),
        color: Style.of(context).colors.premium,
        onPressed: () async {
          _analyticsProvider.logEvent(AnalyticsConstants.tapRequestInfo,
              params: {
                AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring
              });
          _sendRequestInfo();
        },
        child: Text(
          FlutterI18n.translate(context, "tutoring_modal.button"),
          style: normalResponsiveFont(
            context,
            fontColor: FontColor.Content2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future _sendRequestInfo() async {
    setState(() {
      _loading = true;
    });

    final NetworkResponse result = await Injector.appInstance
        .getDependency<ApiServices>()
        .requestTutoringInfo();

    setState(() {
      _loading = false;
    });

    if (result is SuccessResponse<String>) {
      await _showSuccessDialog(result.body);
      Navigator.of(context).pop();
    } else {
      if (result is ErrorResponse &&
          result.error is ApiException &&
          (result.error as ApiException).code == 412) {
        await _showSuccessDialog(_anotherTimeSuccessCode);
      } else {
        await _showErrorDialog();
      }
    }
  }

  Future _showSuccessDialog(String result) {
    return showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "tutoring_modal.request_dialog_header",
          ),
          content: FlutterI18n.translate(
            context,
            "tutoring_modal.request_dialog_message",
          ),
          actions: <DialogActionData>[
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "tutoring_modal.request_dialog_button",
              ),
              onTap: _openPhoneNumber,
            ),
          ],
        );
      },
    );
  }

  void _openPhoneNumber() {
    launch("tel://$_supportPhoneNumber");
    _analyticsProvider.logEvent(AnalyticsConstants.tapRequestInfoCallUs,
        params: {AnalyticsConstants.keySource: AnalyticsConstants.screenTutoring});
  }

  Future _showErrorDialog() {
    return showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "general.error",
          ),
          content: FlutterI18n.translate(
            context,
            "tutoring_modal.request_dialog_error_message",
          ),
        );
      },
    );
  }
}

// void openTutoringModal(BuildContext context, String source) {
//   final AnalyticsProvider analyticsProvider =
//       Injector.appInstance.getDependency<AnalyticsProvider>();
//   analyticsProvider.logScreenView(AnalyticsConstants.screenTutoring, source);
//
//   showModalBottomSheet<void>(
//     isScrollControlled: true,
//     context: context,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(
//         top: Radius.circular(25.0),
//       ),
//     ),
//     builder: (context) {
//       return TutoringModal();
//     },
//   );
// }
