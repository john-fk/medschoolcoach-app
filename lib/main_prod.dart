import 'dart:async';

import 'package:Medschoolcoach/app.dart';
import 'package:Medschoolcoach/app_router.dart';
import 'package:Medschoolcoach/providers/analytics_constants.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/dependency_injection.dart';
import 'package:Medschoolcoach/providers/analytics_provider.dart';
import 'package:Medschoolcoach/utils/crash_reporting.dart';
import 'package:Medschoolcoach/utils/notification_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'providers/analytics_constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AnalyticsProvider _analyticsProvider = await AnalyticsProvider();

  await initNotifications(notifsPlugin, navigatorKey);
  await _analyticsProvider.initialize(Config.prodMixPanelToken);
  _analyticsProvider.logEvent(AnalyticsConstants.eventAppOpen);

  initializeDependencyInjection(
    apiUrl: Config.prodApiUrl,
    auth0Url: Config.prodBaseAuth0Url,
    analyticsProvider: _analyticsProvider,
  );

  Config.showSwitch = false;
  final String initialRoute = await AppRouter.getInitialRoute();

  //region: Firebase
  await CrashReporting.initialize();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  //endregion

  //region :MixPanel
  messaging.getToken().then((token) {
    _analyticsProvider.fcmcode = token;
  });
  //endregion

  print('User granted permission: ${settings.authorizationStatus}');
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
