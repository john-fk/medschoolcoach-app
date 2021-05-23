import 'package:Medschoolcoach/config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

typedef Validator = String Function(String);

abstract class Validators {
  static Validator passwordLengthValidator(BuildContext context) =>
      (String value) {
        if (!hasMinLength(value)) {
          return FlutterI18n.translate(
            context,
            "validator_errors.lenght",
            translationParams: {
              "number": Config.requiredPasswordLength.toString(),
            },
          );
        }
        return null;
      };

  static Validator requiredValidator(BuildContext context) => (String value) {
        if (!isNotEmpty(value)) {
          return FlutterI18n.translate(
            context,
            "validator_errors.required",
          );
        }
        return null;
      };

  static Validator emailValidator(BuildContext context) => (String value) {
        if (!isEmailValid(value)) {
          return FlutterI18n.translate(
            context,
            "validator_errors.email",
          );
        }
        return null;
      };

  static Validator passwordValidator(BuildContext context) => (String value) {
        if (!isPasswordValid(value) || !hasMinLength(value)) {
          return FlutterI18n.translate(
            context,
            "validator_errors.password",
          );
        }
        return null;
      };

  static Validator countryCodeValidator(BuildContext context) =>
      (String value) {
        if (!isCountryCodeValid(value)) {
          return FlutterI18n.translate(
            context,
            "validator_errors.country_code",
          );
        }
        return null;
      };

  static Validator optionalPhoneValidator(BuildContext context) =>
          (String value) {
        if (value.length > 0 && value.length < 14) {
          return FlutterI18n.translate(
            context,
            "validator_errors.phone_too_short",
          );
        }
        return null;
      };

  static bool hasMinLength(
    String value, {
    int minLength = Config.requiredPasswordLength,
  }) =>
      value.length >= minLength;

  static bool isNotEmpty(String value) => value != null && value.isNotEmpty;

  static bool isEmailValid(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool hasLowerCaseLetter(String value) {
    Pattern pattern = '(?=.*[a-z])';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool hasUpperCaseLetter(String value) {
    Pattern pattern = '(?=.*[A-Z])';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool hasDigit(String value) {
    Pattern pattern = '(?=.*[0-9])';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool hasSpecialSign(String value) {
    Pattern pattern = '[!@#\$%^&*(),./?":{}|<>]';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool isCountryCodeValid(String value) {
    Pattern pattern = r'^(\+)([0-9]{0,4})$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool isPasswordValid(String value) {
    int result = (hasLowerCaseLetter(value) ? 1 : 0) +
        (hasUpperCaseLetter(value) ? 1 : 0) +
        (hasDigit(value) ? 1 : 0) +
        (hasSpecialSign(value) ? 1 : 0);
    return result > 1;
  }
}
