import 'dart:async';
import 'dart:io';

import 'package:Medschoolcoach/app.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/dependency_injection.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart';
import 'package:native_mixpanel/native_mixpanel.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Mixpanel _mixPanel = await Mixpanel(
    shouldLogEvents: true,
    isOptedOut: false,
  );

  await _mixPanel.initialize(Config.mixPanelToken);
  _mixPanel.track(Config.mixPanelAppOpenEvent);

  initializeDependencyInjection(
    apiUrl: Config.devApiUrl,
    auth0Url: Config.devBaseAuth0Url,
    mixPanel: _mixPanel,
  );
  Config.showSwitch = false;
  final String initialRoute = await _getInitialRoute();

  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  /// App supported orientations init
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(MyApp(
        initialRoute: initialRoute,
      ));
    },
  );
}

Future<String> _getInitialRoute() async {
  final userManager = Injector.appInstance.getDependency<UserManager>();
  final isLoggedIn = await userManager.isUserLoggedIn();

  if (isLoggedIn) {
    return Routes.home;
  } else {
    return Routes.welcome;
  }
}