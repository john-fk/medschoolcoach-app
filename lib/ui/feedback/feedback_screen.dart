 import 'package:universal_io/io.dart';

import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/repository_utils.dart';
import 'package:Medschoolcoach/utils/api/api_services.dart';
import 'package:Medschoolcoach/utils/api/network_response.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/app_bars/custom_app_bar.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/empty_state/empty_state.dart';
import 'package:Medschoolcoach/widgets/inputs/main_text_field.dart';
import 'package:Medschoolcoach/widgets/inputs/validators.dart';
import 'package:Medschoolcoach/widgets/navigation_bar/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  bool _autoValidate = false;
  bool _loading = false;
  RepositoryErrorResult _error;

  bool _bugCheckbox = false;
  bool _featureCheckbox = false;
  bool _questionCheckbox = false;
  bool _contentCheckbox = false;

  @override
  void initState() {
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenFeedback, AnalyticsConstants.screenSettings);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            CustomAppBar(padding: EdgeInsets.only(
                    top: whenDevice(context,
                    small: 5, medium: 8, large: 15, tablet: 30),
              ),
              title: FlutterI18n.translate(context, "feedback_screen.support"),
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        10,
        MediaQuery.of(context).padding.top,
        10,
        10,
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidateMode: _autoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  ..._buildCheckboxes(),
                  const SizedBox(height: 10),
                  _buildMessageField(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(height: 15),
            _error != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: EmptyState(repositoryResult: _error),
                  )
                : Container(),
            PrimaryButton(
              text: FlutterI18n.translate(context, "feedback_screen.button"),
              onPressed: _submit,
              isLoading: _loading,
              key: const Key("feedbackSubmit"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return MainTextField(
      key: const Key("feedbackField"),
      hintText: FlutterI18n.translate(context, "feedback_screen.hint"),
      controller: _messageController,
      labelText:
          FlutterI18n.translate(context, "feedback_screen.message_label"),
      keyboardType: TextInputType.multiline,
      onEditingComplete: _submit,
      linesCount: 10,
      validators: [
        Validators.requiredValidator(context),
      ],
    );
  }

  List<Widget> _buildCheckboxes() {
    return [
      Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
        ),
        child: Text(
          FlutterI18n.translate(context, "feedback_screen.request_type"),
          style: smallResponsiveFont(context, fontColor: FontColor.Content3),
        ),
      ),
      _buildCheckboxField(
        checkboxValue: _bugCheckbox,
        translateKey: "feedback_screen.bug",
        onChanged: (value) {
          setState(() {
            _bugCheckbox = value;
          });
        },
      ),
      _buildCheckboxField(
        checkboxValue: _featureCheckbox,
        translateKey: "feedback_screen.feature",
        onChanged: (value) {
          setState(() {
            _featureCheckbox = value;
          });
        },
      ),
      _buildCheckboxField(
        checkboxValue: _questionCheckbox,
        translateKey: "feedback_screen.question",
        onChanged: (value) {
          setState(() {
            _questionCheckbox = value;
          });
        },
      ),
      _buildCheckboxField(
        checkboxValue: _contentCheckbox,
        translateKey: "feedback_screen.content",
        onChanged: (value) {
          setState(() {
            _contentCheckbox = value;
          });
        },
      ),
      if (_autoValidate && !_validateCheckbox())
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            FlutterI18n.translate(context, "feedback_screen.tick"),
            style: Style.of(context).font.error.copyWith(
                  fontSize: whenDevice(
                    context,
                    large: 10,
                    tablet: 15,
                  ),
                ),
          ),
        ),
    ];
  }

  Widget _buildCheckboxField({
    @required bool checkboxValue,
    @required Function(bool) onChanged,
    @required String translateKey,
  }) {
    return Row(
      children: <Widget>[
        _autoValidate && !_validateCheckbox()
            ? Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Style.of(context).colors.error,
                ),
                child: Checkbox(
                  value: checkboxValue,
                  onChanged: onChanged,
                ),
              )
            : Checkbox(
                value: checkboxValue,
                onChanged: onChanged,
              ),
        Text(
          FlutterI18n.translate(context, translateKey),
          style: _autoValidate && !_validateCheckbox()
              ? normalResponsiveFont(
                  context,
                  fontColor: FontColor.Error,
                )
              : normalResponsiveFont(context),
          overflow: TextOverflow.clip,
        )
      ],
    );
  }

  bool _validateCheckbox() {
    bool result = false;
    if (_bugCheckbox) result = true;
    if (_contentCheckbox) result = true;
    if (_featureCheckbox) result = true;
    if (_questionCheckbox) result = true;

    return result;
  }

  List<String> _getCheckboxStrings() {
    final list = List<String>();
    if (_bugCheckbox)
      list.add(FlutterI18n.translate(context, "feedback_screen.bug"));
    if (_contentCheckbox)
      list.add(FlutterI18n.translate(context, "feedback_screen.content"));
    if (_featureCheckbox)
      list.add(FlutterI18n.translate(context, "feedback_screen.feature"));
    if (_questionCheckbox)
      list.add(FlutterI18n.translate(context, "feedback_screen.question"));
    return list;
  }

  void _submit() async {
    FocusScope.of(context).unfocus();

    if (_validateCheckbox() && _formKey.currentState.validate()) {
      setState(() {
        _loading = true;
        _autoValidate = false;
      });

      final NetworkResponse result =
          await Injector.appInstance.getDependency<ApiServices>().sendFeedback(
                message: _messageController.text,
                bugVsAccount: _getCheckboxStrings(),
                platform: Platform.operatingSystem,
              );

      if (result is SuccessResponse) {
        setState(() {
          _loading = false;
          _error = null;
        });
        await _showSuccessDialog();
        Navigator.of(context).pop();
       _logFeedbackAnalytics();
      } else {
        setState(() {
          _loading = false;
          _error = RepositoryUtils.handleRepositoryError<void>(result);
        });
      }
    } else {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _logFeedbackAnalytics() {
    if (_getCheckboxStrings() == null) return;
    String errorMessages = _getCheckboxStrings().join(",");
    _analyticsProvider.logEvent(AnalyticsConstants.tapSendFeedback, params: {
      AnalyticsConstants.keyType: errorMessages,
      AnalyticsConstants.keyError: _messageController.text
    });
  }

  Future _showSuccessDialog() {
    return showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "general.success",
          ),
          content: FlutterI18n.translate(
            context,
            "feedback_screen.success",
          ),
          actions: <DialogActionData>[
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "general.continue",
              ),
              onTap: () => {
                Navigator.pop(context),
              },
            ),
          ],
        );
      },
    );
  }
}
