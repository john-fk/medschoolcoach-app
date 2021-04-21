import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/external_navigation_utils.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/authentication_header/authentication_header.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/inputs/main_text_field.dart';
import 'package:Medschoolcoach/widgets/inputs/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = "";
  bool _autoValidate = false;

  @override
  void initState() {
    //TODO: Can we pull the email ID from login screen if they entered anything?
    _analyticsProvider.logScreenView(AnalyticsConstants.screenForgotPassword,
        AnalyticsConstants.screenForgotPassword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AuthenticationHeader(
                headerText: "forgot_password_screen.forgot_password_header",
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: whenDevice(
                    context,
                    large: 16.0,
                    tablet: 32.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        FlutterI18n.translate(
                          context,
                          "forgot_password_screen.forgot_password_description",
                        ),
                        style: Style.of(context).font.normal.copyWith(
                              fontSize:
                                  whenDevice(context, large: 15, tablet: 25),
                            ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _errorMessage.isNotEmpty && _errorMessage != null
                        ? Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                              bottom: 16.0,
                            ),
                            child: Center(
                              child: Text(
                                _errorMessage,
                                textAlign: TextAlign.center,
                                style: Style.of(context).font.error,
                              ),
                            ),
                          )
                        : Container(),
                    Form(
                      key: _formKey,
                      autovalidateMode: _autoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                      child: MainTextField(
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        textInputAction: TextInputAction.done,
                        controller: _emailController,
                        labelText: FlutterI18n.translate(
                          context,
                          "text_field_labels.email_label",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validators: [
                          Validators.requiredValidator(context),
                          Validators.emailValidator(context)
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: PrimaryButton(
                        text: FlutterI18n.translate(
                          context,
                          "forgot_password_screen.forgot_password_button_text",
                        ),
                        isLoading: _isLoading,
                        onPressed: _resetPassword,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(
                          8.0,
                        ),
                        child: RichText(
                          text: _buildText(context),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _buildText(BuildContext context) {
    return TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: FlutterI18n.translate(
            context,
            "forgot_password_screen.forgot_password_resend",
          ),
          style: normalResponsiveFont(context),
        ),
        TextSpan(
          text: FlutterI18n.translate(context, Config.supportEmail),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              ExternalNavigationUtils.sendEmail(Config.supportEmail);
            },
          style: Style.of(context).font.underlineNormal.copyWith(
                fontSize: whenDevice(
                  context,
                  large: 15,
                  tablet: 25,
                ),
              ),
        ),
      ],
    );
  }

  void _resetPassword() async {
    _setProgressBarVisibility(
      visible: true,
      errorMessage: "",
    );
    setState(() {
      _autoValidate = true;
    });
    if (!_formKey.currentState.validate()) {
      _setProgressBarVisibility(
        visible: false,
        errorMessage: "",
      );
      return;
    }

    final dynamic response = await _userRepository.resetPassword(
      userEmail: _emailController.text,
    );

    _setProgressBarVisibility(
      visible: false,
      errorMessage: "",
    );

    if (response is RepositorySuccessResult == true) {
      _analyticsProvider.logAccountManagementEvent(
          AnalyticsConstants.tapForgotPassword,
          _emailController.text,
          true,
          null);
      _showSuccessDialog();
    } else {
      setState(() {
        _autoValidate = false;
      });
      final errorMessage = _getErrorMessage(response);
      _setProgressBarVisibility(visible: false, errorMessage: errorMessage);
      _analyticsProvider.logAccountManagementEvent(
          AnalyticsConstants.tapForgotPassword,
          _emailController.text,
          false,
          errorMessage);
    }
  }

  String _getErrorMessage(RepositoryErrorResult response) {
    switch (response.error) {
      case ApiError.networkError:
        return FlutterI18n.translate(
          context,
          "errors.no_internet_no_refresh",
        );
      default:
        return FlutterI18n.translate(
          context,
          "errors.global_api_error",
        );
    }
  }

  void _showSuccessDialog() {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "forgot_password_screen.dialog_title",
          ),
          content: FlutterI18n.translate(
            context,
            "forgot_password_screen.dialog_message",
          ),
          actions: <DialogActionData>[
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "general.continue",
              ),
              onTap: () => {
                Navigator.pop(context),
                Navigator.pop(context),
              },
            ),
          ],
        );
      },
    );
  }

  void _setProgressBarVisibility({
    bool visible,
    String errorMessage,
  }) {
    setState(() {
      _isLoading = visible;
      _errorMessage = errorMessage;
    });
  }
}
