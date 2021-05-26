import 'dart:async';
import 'package:Medschoolcoach/app.dart';
import 'package:Medschoolcoach/app_router.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/dependency_injection.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/crash_reporting.dart';
import 'package:Medschoolcoach/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_preview/device_preview.dart' as _dp;
import 'providers/analytics_constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin notifsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AnalyticsProvider _analyticsProvider = await AnalyticsProvider();

  await initNotifications(notifsPlugin, navigatorKey);
  await _analyticsProvider.initialize(Config.devMixPanelToken);
  _analyticsProvider.logEvent(AnalyticsConstants.eventAppOpen, params: null);

  initializeDependencyInjection(
    apiUrl: Config.devApiUrl,
    auth0Url: Config.devBaseAuth0Url,
    analyticsProvider: _analyticsProvider,
  );

  Config.showSwitch = false;
  final String initialRoute = await AppRouter.getInitialRoute();

  await CrashReporting.initialize();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  var enableDevicePreview = false;

  /// App supported orientations init
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
        (_) {
      runApp(_dp.DevicePreview(
        enabled: enableDevicePreview,
        builder: (context) => MyApp(initialRoute: initialRoute),
      ));
    },
  );
}
