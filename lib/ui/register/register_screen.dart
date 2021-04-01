import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
import 'package:Medschoolcoach/ui/register/password_requirements.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/external_navigation_utils.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
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
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';

class RegisterScreen extends StatefulWidget {
  final String source;

  const RegisterScreen(this.source);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

/*  final TextEditingController _phonePrefixController = 
  TextEditingController();
  final TextEditingController _phoneNumberController = 
  TextEditingController();*/
  final TextEditingController _passwordController = TextEditingController();

/*  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _testDateController = TextEditingController();*/
  FocusNode _firstNameInputFocusNode;
  FocusNode _lastNameInputFocusNode;
  FocusNode _emailInputFocusNode;

/*  FocusNode _phonePrefixFocusNode;
  FocusNode _phoneNumberFocusNode;*/
  FocusNode _passwordInputFocusNode;

/*  FocusNode _schoolInputFocusNode;
  FocusNode _yearInputFocusNode;
  FocusNode _testDateInputFocusNode;*/

  final _formKey = GlobalKey<FormState>();
//  final autoCompleteKey = GlobalKey<AutoCompleteTextFieldState<String>>();

  bool _isLoading = false;
  String _errorMessage = "";
  bool _autoValidate = false;
  bool _checkboxValue = true;
  bool _checkboxError = false;

  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();

  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  @override
  void initState() {
    _analyticsProvider.logScreenView(AnalyticsConstants.screenRegister,
        widget.source);
    _firstNameInputFocusNode = FocusNode();
    _lastNameInputFocusNode = FocusNode();
    _emailInputFocusNode = FocusNode();
/*    _phonePrefixFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();*/
    _passwordInputFocusNode = FocusNode();
/*    _schoolInputFocusNode = FocusNode();
    _yearInputFocusNode = FocusNode();
    _testDateInputFocusNode = FocusNode();

    _phonePrefixController.text = "+1";*/

/*    _yearInputFocusNode
      ..addListener(
        () {
          if (_yearInputFocusNode.hasFocus) {
            FocusScope.of(context).unfocus();
            _showYearPickerDialog();
          }
        },
      );*/

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
                headerText: "register_screen.register_header",
              ),
              Padding(
                padding: EdgeInsets.all(
                  whenDevice(
                    context,
                    large: 16.0,
                    tablet: 32.0,
                  ),
                ),
                child: SingleChildScrollView(
                  key: const Key("register scroll"),
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        autovalidateMode: _autoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            _buildFirstNameTextField(context),
                            const SizedBox(height: 8),
                            _buildLastNameTextField(context),
                            const SizedBox(height: 8),
                            _buildEmailTextField(context),
                            /*const SizedBox(height: 8),
                            _buildPhoneTextField(context),*/
                            const SizedBox(height: 8),
                            _buildPasswordTextField(context),
                            const SizedBox(height: 8),
                            PasswordRequirements(
                              passwordController: _passwordController,
                              autoValidate: _autoValidate,
                            ),
                            /*const SizedBox(height: 8),
                            _buildSchoolTextField(context),
                            const SizedBox(height: 8),
                            _buildYearTextField(context),
                            const SizedBox(height: 8),
                            MainTextField(
                              key: const Key("mcat test date"),
                              controller: _testDateController,
                              labelText: FlutterI18n.translate(
                                context,
                                "text_field_labels.test_date_label",
                              ),
                              keyboardType: TextInputType.text,
                              validators: [
                                Validators.requiredValidator(context),
                              ],
                              focusNode: _testDateInputFocusNode,
                              onEditingComplete: () =>
                                  FocusScope.of(context).unfocus(),
                              onTap: () async {
                                var selectedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2040),
                                );
                                _testDateController.text = DateFormat(
                                        Config.defaultDateFormat,
                                        Config.defaultLocale)
                                    .format(selectedDate);
                              },
                              readOnly: true,
                            ),*/
                            const SizedBox(height: 8),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  _checkboxError
                                      ? Theme(
                                          data: Theme.of(context).copyWith(
                                            unselectedWidgetColor:
                                                Style.of(context).colors.error,
                                          ),
                                          child: _buildCheckbox(),
                                        )
                                      : _buildCheckbox(),
                                  _buildRichText(context),
                                ],
                              ),
                            ),
                            _buildErrorMessage(context),
                            _buildRegisterButton(context),
                          ],
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

  Checkbox _buildCheckbox() {
    return Checkbox(
      key: const Key("checkbox"),
      value: _checkboxValue,
      onChanged: (bool newValue) {
        setState(() {
          _checkboxValue = newValue;
          _checkboxError = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _firstNameInputFocusNode.dispose();
    _lastNameInputFocusNode.dispose();
    _emailInputFocusNode.dispose();
/*    _phonePrefixFocusNode.dispose();
    _phoneNumberFocusNode.dispose();*/
    _passwordInputFocusNode.dispose();
/*    _schoolInputFocusNode.dispose();
    _yearInputFocusNode.dispose();
    _testDateInputFocusNode.dispose();*/
    super.dispose();
  }

  MainTextField _buildFirstNameTextField(BuildContext context) {
    return MainTextField(
      key: const Key("first name"),
      controller: _firstNameController,
      labelText: FlutterI18n.translate(
        context,
        "text_field_labels.first_name",
      ),
      keyboardType: TextInputType.text,
      validators: [
        Validators.requiredValidator(context),
      ],
      focusNode: _firstNameInputFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_lastNameInputFocusNode),
    );
  }

  MainTextField _buildLastNameTextField(BuildContext context) {
    return MainTextField(
      key: const Key("last name"),
      controller: _lastNameController,
      labelText: FlutterI18n.translate(
        context,
        "text_field_labels.last_name",
      ),
      keyboardType: TextInputType.text,
      validators: [
        Validators.requiredValidator(context),
      ],
      focusNode: _lastNameInputFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_emailInputFocusNode),
    );
  }

  MainTextField _buildEmailTextField(BuildContext context) {
    return MainTextField(
      key: const Key("email"),
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
      focusNode: _emailInputFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_passwordInputFocusNode),
    );
  }

/*  Row _buildPhoneTextField(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: MainTextField(
            controller: _phonePrefixController,
            labelText: FlutterI18n.translate(
              context,
              "text_field_labels.phone",
            ),
            keyboardType: TextInputType.phone,
            validators: [
              Validators.countryCodeValidator(context),
            ],
            formatterList: [
              NumberPrefixInputFormatter(),
            ],
            focusNode: _phonePrefixFocusNode,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
          ),
          width: 100,
        ),
        SizedBox(
          width: 2,
        ),
        Expanded(
          child: MainTextField(
            key: const Key("phone number"),
            controller: _phoneNumberController,
            labelText: "",
            validators: [Validators.requiredValidator(context)],
            formatterList: [
              WhitelistingTextInputFormatter.digitsOnly,
              NumberInputFormatter(),
              LengthLimitingTextInputFormatter(14),
            ],
            keyboardType: TextInputType.phone,
            focusNode: _phoneNumberFocusNode,
            onEditingComplete: () => FocusScope.of(context).requestFocus(
              _passwordInputFocusNode,
            ),
          ),
        ),
      ],
    );
  }*/

  MainTextField _buildPasswordTextField(BuildContext context) {
    return MainTextField(
        key: const Key("password"),
        controller: _passwordController,
        labelText: FlutterI18n.translate(
          context,
          "text_field_labels.password_label",
        ),
        keyboardType: TextInputType.visiblePassword,
        validators: [Validators.passwordValidator(context)],
        showObscureTextIcon: true,
        focusNode: _passwordInputFocusNode,
        onEditingComplete: () => FocusScope.of(context).unfocus());
  }

/*  Column _buildSchoolTextField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            bottom: 2,
          ),
          child: Text(
            FlutterI18n.translate(
              context,
              "text_field_labels.school_label",
            ),
            style: Style.of(context).font.normal3Small,
          ),
        ),
        Container(
          key: const Key("undergraduate school"),
          child: AutoCompleteTextField<String>(
            key: autoCompleteKey,
            suggestionsAmount: 100,
            style: Style.of(context).font.normal,
            clearOnSubmit: false,
            suggestions: suggestions,
            keyboardType: TextInputType.text,
            focusNode: _schoolInputFocusNode,
            validators: [
              Validators.requiredValidator(context),
            ],
            controller: _schoolController,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Color(0xffECF4FA),
            ),
            itemFilter: (suggestion, String query) {
              return suggestion.toLowerCase().contains(
                    query.toLowerCase(),
                  );
            },
            itemSorter: (a, b) {
              return a.compareTo(b);
            },
            itemSubmitted: (data) {
              setState(() {
                _schoolController.text = data;
              });
            },
            itemBuilder: (
              BuildContext context,
              suggestion,
            ) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        suggestion,
                        key: Key(suggestion),
                        style: Style.of(context).font.normal,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }*/

/*
  MainTextField _buildYearTextField(BuildContext context) {
    return MainTextField(
      key: const Key("year"),
      controller: _yearController,
      labelText: FlutterI18n.translate(
        context,
        "text_field_labels.graduation_year_label​",
      ),
      keyboardType: TextInputType.text,
      validators: [
        Validators.requiredValidator(context),
      ],
      focusNode: _yearInputFocusNode,
      onEditingComplete: () =>
          FocusScope.of(context).requestFocus(_testDateInputFocusNode),
    );
  }
*/

  Widget _buildErrorMessage(BuildContext context) {
    return _errorMessage != null && _errorMessage.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 8),
            child: Center(
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: Style.of(context).font.error,
              ),
            ),
          )
        : Container();
  }

  Padding _buildRegisterButton(BuildContext context) {
    return Padding(
      key: const Key("register"),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: PrimaryButton(
        text: FlutterI18n.translate(
          context,
          "register_screen.register_button_text",
        ),
        isLoading: _isLoading,
        onPressed: _signUp,
      ),
    );
  }

  Expanded _buildRichText(BuildContext context) {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.left,
        text: _buildText(context),
      ),
    );
  }

  TextSpan _buildText(BuildContext context) {
    return TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: FlutterI18n.translate(
            context,
            "register_screen.terms_of_service_intro",
          ),
          style: _checkboxError
              ? normalResponsiveFont(context, fontColor: FontColor.Error)
              : normalResponsiveFont(context),
        ),
        TextSpan(
          text: FlutterI18n.translate(
            context,
            "register_screen.terms_of_service",
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _analyticsProvider
                  .logEvent(AnalyticsConstants.tapTermsAndConditions, params: {
                AnalyticsConstants.keySource: AnalyticsConstants.screenRegister
              });
              ExternalNavigationUtils.openWebsite(
                Config.termsOfUseUrl,
              );
            },
          style: _checkboxError
              ? normalResponsiveFont(context, fontColor: FontColor.Error)
                  .copyWith(decoration: TextDecoration.underline)
              : normalResponsiveFont(context)
                  .copyWith(decoration: TextDecoration.underline),
        ),
        TextSpan(
          text: FlutterI18n.translate(
            context,
            "register_screen.terms_of_service_and",
          ),
          style: _checkboxError
              ? normalResponsiveFont(context, fontColor: FontColor.Error)
              : normalResponsiveFont(context),
        ),
        TextSpan(
          text: FlutterI18n.translate(
            context,
            "register_screen.privacy_policy",
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => ExternalNavigationUtils.openWebsite(
                  Config.privacyPolicyUrl,
                ),
          style: _checkboxError
              ? normalResponsiveFont(context, fontColor: FontColor.Error)
                  .copyWith(decoration: TextDecoration.underline)
              : normalResponsiveFont(context)
                  .copyWith(decoration: TextDecoration.underline),
        ),
      ],
    );
  }

  void _setProgressBarVisibility({
    bool visible,
    String errorMessage,
    bool checkboxError = false,
  }) {
    setState(() {
      _isLoading = visible;
      _errorMessage = errorMessage;
      _checkboxError = checkboxError;
    });
  }

  void _signUp() async {
    _setProgressBarVisibility(
      visible: true,
      errorMessage: "",
    );

    _emailController.text = _emailController.text.trim();

    setState(() {
      _autoValidate = true;
    });

    if (!_formKey.currentState.validate() || !_checkboxValue) {
      _setProgressBarVisibility(
          visible: false, errorMessage: "", checkboxError: !_checkboxValue);
      return;
    }

    var response = await _userRepository.register(
      userEmail: _emailController.text,
      password: _passwordController.text,
      userFirstName: _firstNameController.text,
      userLastName: _lastNameController.text,
    );
/*        phoneNumber: _phonePrefixController.text +
            _phoneNumberController.text
                .replaceAll(" ", "")
                .replaceAll("(", "")
                .replaceAll("-", "")
                .replaceAll(")", ""),
        undergraduateSchool: _schoolController.text,
        graduationYear: _yearController.text,
        testDate: _testDateController.text);*/

    if (response is RepositorySuccessResult) {
      _analyticsProvider.logAccountManagementEvent(AnalyticsConstants.tapSignUp,
          _emailController.text, true, null);
      _setProgressBarVisibility(
        visible: false,
        errorMessage: "",
      );
      _showSuccessDialog();
    } else {
      //TODO: errorData is null in response -
      // (Tried to sign up with existing user's emailId)
      final errorMessage = _getErrorMessage(response);
      _analyticsProvider.logAccountManagementEvent(AnalyticsConstants.tapSignUp,
          _emailController.text, false, errorMessage);
      _setProgressBarVisibility(
        visible: false,
        errorMessage: errorMessage,
      );
    }
  }

  String _getErrorMessage(RepositoryResult errorResult) {
    if (errorResult is RepositoryErrorResult &&
        errorResult.error == ApiError.networkError) {
      return FlutterI18n.translate(
        context,
        "errors.no_internet_no_refresh",
      );
    }
    if (errorResult is RepositoryErrorResultAuth0) {
      return errorResult.errorData.description;
    }
    return FlutterI18n.translate(
      context,
      "errors.global_api_error",
    );
  }

  void _showSuccessDialog() {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "register_screen.dialog_title",
          ),
          content: FlutterI18n.translate(
            context,
            "register_screen.dialog_message",
          ),
          actions: <DialogActionData>[
            DialogActionData(
              text: FlutterI18n.translate(
                context,
                "general.continue",
              ),
              onTap: () => {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  Routes.home,
                  (_) => false,
                  arguments: AnalyticsConstants.screenRegister
                )
              },
            ),
          ],
        );
      },
    );
  }

/*  void _showYearPickerDialog() {
    showDialog<DateTime>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Dialog(
          child: YearPicker(
            selectedDate: _yearController.text.isEmpty
                ? DateTime.now()
                : DateTime(int.parse(_yearController.text)),
            onChanged: (DateTime dateTime) {
              _yearController.text = dateTime.year.toString();
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            firstDate: DateTime(1980),
            lastDate: DateTime(2040),
          ),
        );
      },
    );
  }*/
}
