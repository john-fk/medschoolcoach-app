import 'package:Medschoolcoach/config.dart';
import 'package:Medschoolcoach/ui/question_of_the_day/question_of_the_day.dart';
import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/subjects.dart' as _rxsub;
import 'dart:io' show Platform;

class NotificationClass {
  final int id;
  final String title;
  final String body;
  final String payload;

  NotificationClass({this.id, this.body, this.payload, this.title});
}

final _rxsub.BehaviorSubject<NotificationClass>
    didReceiveLocalNotificationSubject =
_rxsub.BehaviorSubject<NotificationClass>();
final _rxsub.BehaviorSubject<String> selectNotificationSubject =
_rxsub.BehaviorSubject<String>();

Future<void> initNotifications(
    notifs.FlutterLocalNotificationsPlugin notifsPlugin,
        GlobalKey<NavigatorState> navigatorKey) async {

  var initializationSettingsAndroid =
      notifs.AndroidInitializationSettings('ic_notification');
  var initializationSettingsIOS = notifs.IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(NotificationClass(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = notifs.InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await notifsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    selectNotificationSubject.add(payload);
    final userManager = Injector.appInstance.getDependency<UserManager>();
    final isLoggedIn = await userManager.isUserLoggedIn();
    if (isLoggedIn) {
      await Navigator.push(
        navigatorKey.currentState.context,
        MaterialPageRoute<void>(builder: (context) =>
            QuestionOfTheDay(source: "notification")),
      );
    }
  });

  print("Notifications initialized successfully");
}

Future<void> markLaunchedFromNotificationIfApplicable(
    notifs.FlutterLocalNotificationsPlugin notifsPlugin,
    BuildContext context) async {
  final NotificationAppLaunchDetails notificationAppLaunchDetails =
      await notifsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails.didNotificationLaunchApp) {
    Config.enteredAppFromQOTDNotification = true;
  } else {
    Config.enteredAppFromQOTDNotification = false;
  }
}

Future<bool> requestPermissions(
    notifs.FlutterLocalNotificationsPlugin notifsPlugin) {
  if (Platform.isAndroid) {
    return Future.value(true);
  }

  return notifsPlugin
      .resolvePlatformSpecificImplementation<
          notifs.IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

Future<void> scheduleNotification(
    {notifs.FlutterLocalNotificationsPlugin notifsPlugin,
    int id,
    String title,
    String body,
    DateTime scheduledTime}) async {
  var androidSpecifics = notifs.AndroidNotificationDetails(
    id.toString(),
    title,
    body,
    playSound: true,
    importance: notifs.Importance.high,
  );
  var iOSSpecifics = notifs.IOSNotificationDetails();
  var platformChannelSpecifics =
      notifs.NotificationDetails(android: androidSpecifics, iOS: iOSSpecifics);
  // ignore: lines_longer_than_80_chars
  print("Scheduling local notification with ${title}, for time ${scheduledTime}");
  // ignore: deprecated_member_use
  await notifsPlugin.schedule(id, title,
      body, scheduledTime, platformChannelSpecifics);
}
