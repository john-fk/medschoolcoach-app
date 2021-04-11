import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/repository/user_repository.dart';
// import 'package:Medschoolcoach/ui/register/number_input_fromatter.dart';
// import 'package:Medschoolcoach/ui/register/number_prefix_input_fromatter.dart';
import 'package:Medschoolcoach/utils/api/errors.dart';
import 'package:Medschoolcoach/utils/api/models/profile_user.dart';
import 'package:Medschoolcoach/utils/responsive_fonts.dart';
import 'package:Medschoolcoach/utils/sizes.dart';
import 'package:Medschoolcoach/utils/style_provider/style.dart';
import 'package:Medschoolcoach/utils/super_state/super_state.dart';
import 'package:Medschoolcoach/widgets/authentication_header/authentication_header.dart';
import 'package:Medschoolcoach/widgets/buttons/primary_button.dart';
import 'package:Medschoolcoach/widgets/dialog/custom_dialog.dart';
import 'package:Medschoolcoach/widgets/inputs/main_text_field.dart';
import 'package:Medschoolcoach/widgets/inputs/validators.dart';
import 'package:Medschoolcoach/widgets/progress_bar/progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:injector/injector.dart';
// import 'package:intl/intl.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserRepository _userRepository =
      Injector.appInstance.getDependency<UserRepository>();
  final AnalyticsProvider _analyticsProvider =
      Injector.appInstance.getDependency<AnalyticsProvider>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // final TextEditingController _phonePrefixController
  // = TextEditingController();
  // final TextEditingController _phoneNumberController
  //  = TextEditingController();
  // final TextEditingController _yearController = TextEditingController();
  // final TextEditingController _testDateController = TextEditingController();

  bool _loading = true;
  bool _buttonLoading = false;
  String _errorMessage = "";
  ProfileUser user;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _analyticsProvider.logScreenView(
        AnalyticsConstants.screenSettings, AnalyticsConstants.screenHome);
    _getProfileUser();
    // _phonePrefixController.text = "+1";
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
                headerText: "settings_screen.header",
              ),
              _loading
                  ? Center(
                      child: ProgressBar(),
                    )
                  : Padding(
                      padding: EdgeInsets.all(
                        whenDevice(
                          context,
                          large: 16.0,
                          tablet: 32.0,
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidate
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            _buildFirstNameTextField(),
                            const SizedBox(height: 8),
                            _buildLastNameTextField(),
                            const SizedBox(height: 8),
                            _isRegularLogin(user?.id)
                                ? _buildEmailTextField()
                                : SizedBox.shrink(),
                            _isRegularLogin(user?.id)
                                ? const SizedBox(height: 8)
                                : SizedBox.shrink(),
                            // _buildPhoneTextField(),
                            // const SizedBox(height: 8),
                            // _buildYearTextField(),
                            // const SizedBox(height: 8),
                            // _buildTestTextField(),
                            // const SizedBox(height: 8),
                            Text(
                              FlutterI18n.translate(
                                context,
                                "settings_screen.log_out_info",
                              ),
                              style: normalResponsiveFont(context),
                            ),
                            _buildErrorMessage(),
                            _buildUpdateButton()
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

  MainTextField _buildFirstNameTextField() {
    return MainTextField(
      key: const Key("first name"),
      controller: _firstNameController,
      labelText: FlutterI18n.translate(
        context,
        "text_field_labels.first_name",
      ),
      validators: [
        Validators.requiredValidator(context),
      ],
      keyboardType: TextInputType.text,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }

  MainTextField _buildLastNameTextField() {
    return MainTextField(
      key: const Key("last name"),
      controller: _lastNameController,
      labelText: FlutterI18n.translate(
        context,
        "text_field_labels.last_name",
      ),
      validators: [
        Validators.requiredValidator(context),
      ],
      keyboardType: TextInputType.text,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }

  MainTextField _buildEmailTextField() {
    return MainTextField(
      key: const Key("email"),
      controller: _emailController,
      labelText: FlutterI18n.translate(
        context,
        "text_field_labels.email_label",
      ),
      validators: [
        Validators.requiredValidator(context),
        Validators.emailValidator(context)
      ],
      keyboardType: TextInputType.emailAddress,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
    );
  }

  // Row _buildPhoneTextField() {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Container(
  //         child: MainTextField(
  //           controller: _phonePrefixController,
  //           labelText: FlutterI18n.translate(
  //             context,
  //             "text_field_labels.phone",
  //           ),
  //           keyboardType: TextInputType.phone,
  //           formatterList: [
  //             NumberPrefixInputFormatter(),
  //           ],
  //           onEditingComplete: () => FocusScope.of(context).nextFocus(),
  //         ),
  //         width: 100,
  //       ),
  //       SizedBox(
  //         width: 2,
  //       ),
  //       Expanded(
  //         child: MainTextField(
  //           key: const Key("phone number"),
  //           controller: _phoneNumberController,
  //           labelText: "",
  //           formatterList: [
  //             WhitelistingTextInputFormatter.digitsOnly,
  //             NumberInputFormatter(),
  //             LengthLimitingTextInputFormatter(14),
  //           ],
  //           keyboardType: TextInputType.phone,
  //           onEditingComplete: () => FocusScope.of(context).nextFocus(),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // void _showYearPickerDialog() {
  //   showDialog<DateTime>(
  //     context: context,
  //     useRootNavigator: true,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         // ignore: deprecated_member_use
  //         child: YearPicker(
  //           selectedDate: _yearController.text.isEmpty
  //               ? DateTime.now()
  //               : DateTime(int.parse(_yearController.text)),
  //           onChanged: (DateTime dateTime) {
  //             _yearController.text = dateTime.year.toString();
  //             FocusScope.of(context).unfocus();
  //             Navigator.pop(context);
  //           },
  //           firstDate: DateTime(1980),
  //           lastDate: DateTime(2040),
  //         ),
  //       );
  //     },
  //   );
  // }

  // MainTextField _buildYearTextField() {
  //   return MainTextField(
  //     key: const Key("year"),
  //     controller: _yearController,
  //     labelText: FlutterI18n.translate(
  //       context,
  //       "text_field_labels.graduation_year_label​",
  //     ),
  //     keyboardType: TextInputType.text,
  //     onEditingComplete: () => FocusScope.of(context).nextFocus(),
  //     onTap: _showYearPickerDialog,
  //   );
  // }

  // MainTextField _buildTestTextField() {
  //   return MainTextField(
  //     key: const Key("mcat test date"),
  //     controller: _testDateController,
  //     labelText: FlutterI18n.translate(
  //       context,
  //       "text_field_labels.test_date_label",
  //     ),
  //     keyboardType: TextInputType.text,
  //     onEditingComplete: () => FocusScope.of(context).unfocus(),
  //     onTap: () async {
  //       var selectedDate = await showDatePicker(
  //         context: context,
  //         firstDate: DateTime.now(),
  //         initialDate: DateTime.now(),
  //         lastDate: DateTime(2040),
  //       );
  //       _testDateController.text = DateFormat(
  //         Config.defaultDateFormat,
  //         Config.defaultLocale,
  //       ).format(selectedDate);
  //     },
  //     readOnly: true,
  //   );
  // }

  Padding _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: PrimaryButton(
        text: FlutterI18n.translate(
          context,
          "settings_screen.update",
        ),
        isLoading: _buttonLoading,
        onPressed: _updateUserProfile,
      ),
    );
  }

  Widget _buildErrorMessage() {
    return _errorMessage.isNotEmpty && _errorMessage != null
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

  Future<void> _getProfileUser() async {
    var response = await _userRepository.getProfileUser(
      forceApiRequest: true,
    );

    if (response is RepositorySuccessResult<ProfileUser>) {
      user = response.data;

      if (user.firstName != null && user.firstName.isNotEmpty) {
        _firstNameController.text = user.firstName;
      }
      if (user.lastName != null && user.lastName.isNotEmpty) {
        _lastNameController.text = user.lastName;
      }
      if (user.email != null && user.email.isNotEmpty) {
        _emailController.text = user.email;
      }

      setState(() {
        _loading = false;
      });
    } else {
      _loading = false;
    }
  }

  bool _isRegularLogin(String id) {
    bool isRegularLogin = false;
    if (id != null && id.isNotEmpty) {
      final idArray = id.split('|');
      if (idArray.length > 0 && idArray[0] != null && idArray[0].isNotEmpty) {
        isRegularLogin = id.contains(Config.REGULAR_AUTH_PREFIX);
      }
    }
    return isRegularLogin;
  }

  Future<void> _updateUserProfile() async {
    setState(() {
      _autoValidate = true;
      _buttonLoading = true;
    });
    String email;
    if (_isRegularLogin(user?.id)) {
      _emailController.text = _emailController.text.trim();
      email = _emailController.text;
    }
    _logAnalytics();
    if (!_formKey.currentState.validate()) {
      setState(() {
        _buttonLoading = false;
      });
      return;
    }
    final response = await _userRepository.updateUserProfile(
        userFirstName: _firstNameController.text,
        userLastName: _lastNameController.text,
        userEmail: email);

    if (response is RepositorySuccessResult) {
      setState(() {
        _buttonLoading = false;
      });
      SuperStateful.of(context).updateUserData();
      _getProfileUser();
      _showSuccessDialog();
    } else {
      setState(() {
        _buttonLoading = false;
        _errorMessage = _getErrorMessage(response as RepositoryErrorResult);
      });
    }
  }

  String _getErrorMessage(RepositoryErrorResult<void> loginResponse) {
    switch (loginResponse.error) {
      case ApiError.unavailableEmail:
        return FlutterI18n.translate(
          context,
          "errors.unavailable_email",
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

  void _logAnalytics() async {
    Map<String, String> getDict(
        String propertyName, String previousValue, String updatedValue) {
      return {
        "updated_property": previousValue,
        "previous_value": previousValue,
        "updated_value": updatedValue
      };
    }

    var userResponse = await _userRepository.getProfileUser();
    if (userResponse is RepositorySuccessResult<ProfileUser>) {
      var args = List<Map<String, String>>();
      ProfileUser user = userResponse.data;
      if (_firstNameController.text?.trim() != user.firstName?.trim()) {
        args.add(
            getDict("user_name", user.firstName, _firstNameController.text));
      }
      if (_lastNameController.text?.trim() != user.lastName?.trim()) {
        args.add(getDict("last_name", user.lastName, _lastNameController.text));
      }
      if (_emailController.text?.trim() != user.email?.trim()) {
        args.add(getDict("email_id", user.email, _emailController.text));
      }
      _analyticsProvider.logEvent(AnalyticsConstants.tapUpdateProfile,
          params: {"updated": args.toString()});
    }
  }

  void _showSuccessDialog() {
    showDialog<dynamic>(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: FlutterI18n.translate(
            context,
            "settings_screen.dialog_header",
          ),
          content: FlutterI18n.translate(
            context,
            "settings_screen.dialog_text",
          ),
          actions: <DialogActionData>[
            DialogActionData(
                text: FlutterI18n.translate(
                  context,
                  "general.continue",
                ),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }),
          ],
        );
      },
    );
  }
}
