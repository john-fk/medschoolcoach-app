import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/repository/repository_result.dart';
import 'package:Medschoolcoach/widgets/app_bars/home_app_bar.dart';
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
                            SizedBox.shrink(),
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

      setState(() {
        _loading = false;
      });

    } else {
      _loading = false;
    }
  }

  Future<void> _updateUserProfile() async {
    setState(() {
      _autoValidate = true;
      _buttonLoading = true;
    });

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
        userEmail: user.email);

    if (response is RepositorySuccessResult) {
      setState(() {
        _buttonLoading = false;
      });
      SuperStateful.of(context).updateUserData(forceApiRequest: true);
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
                  Navigator.pop(context);
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}
