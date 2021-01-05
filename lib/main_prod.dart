import 'dart:async';

import 'package:Medschoolcoach/app.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/dependency_injection.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart';

import 'providers/analytics_constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AnalyticsProvider _analyticsProvider = await AnalyticsProvider();

  await _analyticsProvider.initialize(Config.prodMixPanelToken);
  _analyticsProvider.logEvent(AnalyticsConstants.eventAppOpen);

  initializeDependencyInjection(
    apiUrl: Config.prodApiUrl,
    auth0Url: Config.prodBaseAuth0Url,
    analyticsProvider: _analyticsProvider,
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
