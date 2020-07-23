import 'package:Medschoolcoach/ui/register/password_checkbox.dart';
import 'package:Medschoolcoach/widgets/inputs/validators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class PasswordRequirements extends StatefulWidget {
  final TextEditingController passwordController;
  final bool autoValidate;

  const PasswordRequirements({
    Key key,
    @required this.passwordController,
    @required this.autoValidate,
  }) : super(key: key);

  @override
  _PasswordRequirementsState createState() => _PasswordRequirementsState();
}

class _PasswordRequirementsState extends State<PasswordRequirements> {
  String _password = "";
  bool _hasMinLength = false;
  bool _isPasswordValid = false;
  bool _hasLowerCase = false;
  bool _hasUpperCase = false;
  bool _hasDigit = false;
  bool _hasSpecialCharacter = false;

  @override
  void initState() {
    widget.passwordController.addListener(() {
      setState(
        () {
          _password = widget.passwordController.text;
          _hasMinLength = Validators.hasMinLength(
            _password,
          );
          _isPasswordValid = Validators.isPasswordValid(
            _password,
          );
          _hasLowerCase = Validators.hasLowerCaseLetter(
            _password,
          );
          _hasUpperCase = Validators.hasUpperCaseLetter(
            _password,
          );
          _hasDigit = Validators.hasDigit(
            _password,
          );
          _hasSpecialCharacter = Validators.hasSpecialSign(
            _password,
          );
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PasswordCheckbox(
          text: FlutterI18n.translate(
            context,
            "password_requirments.length",
          ),
          isChecked: _hasMinLength,
          showError: widget.autoValidate && !_hasMinLength,
        ),
        PasswordCheckbox(
          text: FlutterI18n.translate(
            context,
            "password_requirments.requirements",
          ),
          isChecked: _isPasswordValid,
          showError: widget.autoValidate && !_isPasswordValid,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: PasswordCheckbox(
            text: FlutterI18n.translate(
              context,
              "password_requirments.lower_case",
            ),
            isChecked: _hasLowerCase,
            showError:
                widget.autoValidate && !_isPasswordValid && !_hasLowerCase,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: PasswordCheckbox(
            text: FlutterI18n.translate(
              context,
              "password_requirments.uper_case",
            ),
            isChecked: _hasUpperCase,
            showError:
                widget.autoValidate && !_isPasswordValid && !_hasUpperCase,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: PasswordCheckbox(
            text: FlutterI18n.translate(
              context,
              "password_requirments.number",
            ),
            isChecked: _hasDigit,
            showError: widget.autoValidate && !_isPasswordValid && !_hasDigit,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: PasswordCheckbox(
            text: FlutterI18n.translate(
              context,
              "password_requirments.special",
            ),
            isChecked: _hasSpecialCharacter,
            showError: widget.autoValidate &&
                !_isPasswordValid &&
                !_hasSpecialCharacter,
          ),
        ),
      ],
    );
  }
}
