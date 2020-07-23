import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'register_keys.dart';

void registerTest(FlutterDriver driver, String email, String password) {
  group("Register test group", () {
    test("Go to register screen test", () async {
      await driver.waitFor(goRegisterButton);
      await driver.waitFor(goLoginButton);
      await driver.tap(goRegisterButton);
    });

    test("Fill all fields and proceed", () async {
      await driver.waitFor(firstName);
      await driver.tap(firstName);
      await driver.enterText("TestName");
      await driver.tap(lastName);
      await driver.enterText("LastName");
      await driver.tap(emailField);
      await driver.enterText(email);
      await driver.tap(passwordField);
      await driver.enterText(password);
      await driver.scroll(
          registerScroll, 0, -1000, const Duration(milliseconds: 300));
      await driver.tap(registerButton);
      await driver.waitFor(find.text("Continue"));
      await driver.tap(find.text("Continue"));
    });

    test("Check get started", () async {
      await driver.waitFor(find.byValueKey("get_started"));
      await driver.tap(find.byValueKey("get_started"));
      await driver.waitFor(find.text("Set your schedule length"));
      await driver.tap(find.text("Pick your schedule length"));
      await driver.waitFor(find.text("30 days"));
      await driver.tap(find.text("30 days"));
      await driver.waitFor(find.text("Lesson 1"));
    });

    test("Log out", () async {
      await driver.waitFor(more);
      await driver.tap(more);
      await driver.waitFor(logout);
      await driver.tap(logout);
      await driver.waitFor(logoutConfirm);
      await driver.tap(logoutConfirm);
    });
  });
}
