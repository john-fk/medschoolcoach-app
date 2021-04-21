import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/login_response.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/widgets/authentication_header/authentication_header.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/buttons/text_button.dart';
import 'package:Medschoolcoach/widgets/inputs/main_text_field.dart';
import 'package:Medschoolcoach/widgets/inputs/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode _usernameInputFocusNode;
  FocusNode _passwordInputFocusNode;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = "";
  bool _autoValidate = false;

  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenLogin, AnalyticsConstants.screenWelcome);
    _usernameInputFocusNode = FocusNode();
    _passwordInputFocusNode = FocusNode();
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
                headerText: "login_screen.login_header",
              ),
              Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _errorMessage.isNotEmpty && _errorMessage != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                              ),
                              child: Center(
                                child: Text(_errorMessage,
                                    textAlign: TextAlign.center,
                                    style: Style.of(context).font.error),
                              ),
                            )
                          : Container(),
                      MainTextField(
                        key: const Key("email_form"),
                        controller: _usernameController,
                        labelText: FlutterI18n.translate(
                          context,
                          "text_field_labels.email_label",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validators: [
                          Validators.requiredValidator(context),
                          Validators.emailValidator(context)
                        ],
                        focusNode: _usernameInputFocusNode,
                        onEditingComplete: () =>
                            FocusScope.of(context).nextFocus(),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MainTextField(
                        key: const Key("password_form"),
                        controller: _passwordController,
                        labelText: FlutterI18n.translate(
                          context,
                          "login_screen.password_label",
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validators: [
                          Validators.requiredValidator(context),
                          Validators.passwordLengthValidator(context),
                        ],
                        showObscureTextIcon: true,
                        focusNode: _passwordInputFocusNode,
                        onEditingComplete: () =>
                            FocusScope.of(context).unfocus(),
                        textInputAction: TextInputAction.done,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(Routes.forgotPassword);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(
                                4.0,
                              ),
                              child: Text(
                                FlutterI18n.translate(
                                  context,
                                  "login_screen.forgot_password",
                                ),
                                style: smallResponsiveFont(
                                  context,
                                  fontColor: FontColor.Content3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: PrimaryButton(
                          key: const Key("login_button"),
                          text: FlutterI18n.translate(
                            context,
                            "login_screen.login_button_text",
                          ),
                          isLoading: _isLoading,
                          onPressed: _signIn,
                        ),
                      ),
                      Center(
                        child: MSCTextButton(
                          text: FlutterI18n.translate(
                            context,
                            "login_screen.need_an_account",
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed(Routes.register,
                                arguments: AnalyticsConstants.screenLogin);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameInputFocusNode.dispose();
    _passwordInputFocusNode.dispose();
    super.dispose();
  }

  void _signIn() async {
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

    final RepositoryResult<LoginResponse> loginResponse =
        await _userRepository.login(
      userEmail: _usernameController.text,
      password: _passwordController.text,
    );

    if (loginResponse is RepositorySuccessResult) {
      _setProgressBarVisibility(
        visible: false,
        errorMessage: "",
      );
      _analyticsProvider.logAccountManagementEvent(AnalyticsConstants.tapSignIn,
          _usernameController.text, true, null);
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home,
        (_) => false,
        arguments: AnalyticsConstants.screenLogin
      );
    } else {
      final errorMessage = _getErrorMessage(loginResponse);
      _analyticsProvider.logAccountManagementEvent(AnalyticsConstants.tapSignIn,
          _usernameController.text, false, errorMessage);
      _setProgressBarVisibility(
        visible: false,
        errorMessage: _getErrorMessage(loginResponse),
      );
      setState(() {
        _autoValidate = false;
      });
    }
  }

  String _getErrorMessage(RepositoryErrorResult<LoginResponse> loginResponse) {
    switch (loginResponse.error) {
      case ApiError.wrongCredentials:
        return FlutterI18n.translate(
          context,
          "errors.wrong_credentials",
        );
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
