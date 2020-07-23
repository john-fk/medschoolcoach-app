import 'dart:async';
import 'dart:io';

import 'package:Medschoolcoach/app.dart';
import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/dependency_injection.dart';
import 'package:Medschoolcoach/utils/navigation/routes.dart';
// import 'package:Medschoolcoach/utils/notifications_keys.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flushbar/flushbar.dart';
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
  Config.showSwitch = true;
  final String initialRoute = await _getInitialRoute();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _firebaseCloudMessagingListeners(
    _firebaseMessaging,
  );

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

void _firebaseCloudMessagingListeners(
  FirebaseMessaging firebaseMessaging,
) {
  if (Platform.isIOS) {
    firebaseMessaging.requestNotificationPermissions();
  }

  firebaseMessaging.getToken().then((token) {
    print("FCM token: $token");
  });

  firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
/*
      _handleNotification(message);
*/
    },
    onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
    },
  );
}

// Future<dynamic> _handleNotification(
//   Map<String, dynamic> message,
// ) async {
//   try {
//     String title =
//         message[NotificationsKeys.notificationKey]
// [NotificationsKeys.titleKey];
//     String body =
//         message[NotificationsKeys.notificationKey]
// [NotificationsKeys.bodyKey];

// /*    Map<dynamic, dynamic> data =
//         message[NotificationsKeys.dataKey] ?? message;*/

//     _showInAppNotification(
//       title: title,
//       body: body,
//     );
//   } catch (error) {
//     print("error: $error");
//   }
// }

// void _showInAppNotification({
//   @required String title,
//   @required String body,
// }) {
//   Flushbar<dynamic>(
//     title: title,
//     message: body,
//     /*backgroundColor: Style.of(context).colors.accent,*/
//     flushbarStyle: FlushbarStyle.FLOATING,
//     padding: EdgeInsets.all(8),
//     borderRadius: 8,
//     animationDuration: Duration(milliseconds: 600),
//     duration: Duration(seconds: 5),
//     flushbarPosition: FlushbarPosition.TOP,
//   ); /*..show();*/ //TODO get context
// }
