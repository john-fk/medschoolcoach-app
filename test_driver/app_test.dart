import 'package:Medschoolcoach/config.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'lessons_test/lessons_test.dart';
import 'login_test/login_test.dart';
import 'navigation_test/navigation_test.dart';
import 'register_test/register_test.dart';

void main() async {
  FlutterDriver driver = await FlutterDriver.connect();

  final email = _generateEmail();
  final password = "Password1!";

  Config.auth0ClientId = Config.testAuth0ClientId;
  registerTest(driver, email, password);
  Config.auth0ClientId = Config.prodAuth0ClientId;
  loginTest(driver);
  lessonsTest(driver);
  navigationTest(driver, email);

  tearDownAll(() {
    driver.close();
  });
}

String _generateEmail() {
  final emailTextArray = DateTime.now()
      .toIso8601String()
      .replaceAll("-", ".")
      .replaceAll(":", ".")
      .replaceAll("T", "_")
      .split(".");
  String emailText = emailTextArray.take(emailTextArray.length - 1).join(".");
  emailText = "${emailText}@testmail.com";

  return emailText;
}
