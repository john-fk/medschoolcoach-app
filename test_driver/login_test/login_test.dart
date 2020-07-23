import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'login_keys.dart';

void loginTest(FlutterDriver driver) {
  group("Login test group", () {
    test("Go to login screen test", () async {
      await driver.waitFor(goRegisterButton);
      await driver.waitFor(goLoginButton);
      await driver.tap(goLoginButton);
    });

    test("Fill login credentials", () async {
      await driver.waitFor(emailField);
      await driver.tap(emailField);
      await driver.enterText("driver@test.com");
      await driver.tap(passwordField);
      await driver.enterText("Password1!");
      await driver.tap(loginButton);
    });
  });
}
