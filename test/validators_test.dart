import 'package:Medschoolcoach/widgets/inputs/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Validators tests',
    () {
      test(
        'Default minLength validator success test',
        () {
          String testString = "String with more than 8 Characters";

          bool validatorResult = Validators.hasMinLength(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'Default minLength validator test with equal string',
        () {
          String testString = "Stringgg";

          bool validatorResult = Validators.hasMinLength(testString);

          expect(validatorResult, true);
        },
      );
      
      test(
        'Default minLength validator error test',
            () {
          String testString = "Str";

          bool validatorResult = Validators.hasMinLength(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'Custom minLength validator success test',
        () {
          String testString = "Str";

          bool validatorResult =
              Validators.hasMinLength(testString, minLength: 3);

          expect(validatorResult, true);
        },
      );

      test(
        'Custom minLength validator error test',
        () {
          String testString = "String";

          bool validatorResult =
              Validators.hasMinLength(testString, minLength: 7);

          expect(validatorResult, false);
        },
      );

      test(
        'IsNotEmpty validator success test',
        () {
          String testString = "Str";

          bool validatorResult = Validators.isNotEmpty(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'IsNotEmpty validator error test',
        () {
          String testString = "";

          bool validatorResult = Validators.isNotEmpty(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'isEmailValid validator error test',
        () {
          String testString = "aaaaxxxdd";

          bool validatorResult = Validators.isEmailValid(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'isEmailValid validator success test',
        () {
          String testString = "test@gmail.com";

          bool validatorResult = Validators.isEmailValid(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'hasLowerCaseLetter validator error test',
        () {
          String testString = "12212QQQ/";

          bool validatorResult = Validators.hasLowerCaseLetter(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'hasLowerCaseLetter validator success test',
        () {
          String testString = "test@gmail.com";

          bool validatorResult = Validators.hasLowerCaseLetter(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'hasUpperCaseLetter validator error test',
        () {
          String testString = "1221211qqq/";

          bool validatorResult = Validators.hasUpperCaseLetter(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'hasUpperCaseLetter validator success test',
        () {
          String testString = "Test";

          bool validatorResult = Validators.hasUpperCaseLetter(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'hasDigit validator error test',
        () {
          String testString = "QQQqqq/";

          bool validatorResult = Validators.hasDigit(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'hasDigit validator success test',
        () {
          String testString = "Te2st";

          bool validatorResult = Validators.hasDigit(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'hasSpecialSign validator error test',
        () {
          String testString = "QQQqqq111";

          bool validatorResult = Validators.hasSpecialSign(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'hasSpecialSign validator success test',
        () {
          String testString = "Te2s/t";

          bool validatorResult = Validators.hasSpecialSign(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'isCountryCodeValid validator error test',
        () {
          String testString = "q3333";

          bool validatorResult = Validators.isCountryCodeValid(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'isCountryCodeValid validator success test',
        () {
          String testString = "+1";

          bool validatorResult = Validators.isCountryCodeValid(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'isCountryCodeValid validator error test',
        () {
          String testString = "q3333";

          bool validatorResult = Validators.isCountryCodeValid(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'isCountryCodeValid validator success test',
        () {
          String testString = "+1";

          bool validatorResult = Validators.isCountryCodeValid(testString);

          expect(validatorResult, true);
        },
      );

      test(
        'isPasswordValid validator only lower case error test',
        () {
          String testString = "qqqqq";

          bool validatorResult = Validators.isPasswordValid(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'isPasswordValid validator only upper case error test',
        () {
          String testString = "QQ";

          bool validatorResult = Validators.isPasswordValid(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'isPasswordValid validator only digits error test',
        () {
          String testString = "222";

          bool validatorResult = Validators.isPasswordValid(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'isPasswordValid validator only special signs error test',
        () {
          String testString = "/{|";

          bool validatorResult = Validators.isPasswordValid(testString);

          expect(validatorResult, false);
        },
      );

      test(
        'isPasswordValid validator success test',
        () {
          String testString = "Qwerty";

          bool validatorResult = Validators.isPasswordValid(testString);

          expect(validatorResult, true);
        },
      );
    },
  );
}
