import 'dart:math';

import 'package:Medschoolcoach/utils/notification_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class QuestionOfTheDayNotification {
  final String title;
  final String content;

  QuestionOfTheDayNotification(this.title, this.content);

  static final FlutterLocalNotificationsPlugin notifsPlugin =
      FlutterLocalNotificationsPlugin();

  static final List<QuestionOfTheDayNotification> _notifications = [
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification("This one will stump you 🚀",
        "Can you solve these questions of the day?"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification("Practice makes perfect 🥇",
        "Practice now with these questions of the day"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification("Your dream are a few steps away 🚴‍",
        "This question may help you get there faster"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification("Hey, wanna try cracking this nut? 🌰",
        "It only takes you few seconds"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "Did you miss something? 📦", "Here is a new question!"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "Today's challenge is here! 🌟", "Beware, it's real challenge"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification("This will be just a piece of cake! 🍰",
        "Try answering today's question now"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "Let's rock today's question 🏋️‍", "Don't worry, it's easy "),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "Another challenge for you ⛳️", "Can you solve it?"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "Hello, future doctor 🩺", "Wanna try a harder question today?"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "How is the practice going? 🧗", "Add this question to your progress"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "One more practice ☀️", "Answer today's question"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "Maybe this question is familiar 🙌", "Answer it like a pro"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification("You're getting there 🚣‍",
        "Try this question to take one more step further"),
    // ignore: lines_longer_than_80_chars
    QuestionOfTheDayNotification(
        "How is your day? 🙋", "Maybe a little practice can help")
  ];

  static List<QuestionOfTheDayNotification> shuffledNotifications() {
    // iOS Limit
    var numberOfScheduledDays = 64;
    var currentNotifications = _notifications.length;
    // ignore: lines_longer_than_80_chars
    int numberOfIterations = numberOfScheduledDays ~/ currentNotifications;
    var aggregateList = _notifications.toList();
    aggregateList.shuffle();
    for (var i = 0; i < numberOfIterations - 1; i++) {
      var newList = _notifications.toList();
      newList.shuffle();
      aggregateList.addAll(newList);
    }
    ;
    return aggregateList;
  }

  static Future<void> scheduleNotifications(
      DateTime initialScheduleTime) async {
    await cancelNotifications();
    var notifications = shuffledNotifications();
    var scheduledTime = initialScheduleTime;
    var random = Random();
    const timeOffset = const Duration(days: 1);
    notifications.forEach((notification) {
      if (scheduledTime.isAfter(DateTime.now())) {
        scheduleNotification(
            notifsPlugin: notifsPlugin,
            id: random.nextInt(10000),
            title: notification.title,
            body: notification.content,
            scheduledTime: scheduledTime);
      }
      scheduledTime = scheduledTime.add(timeOffset);
    });
  }

  static Future<void> cancelNotifications() async {
    print("Cancelling all notifications");
    return notifsPlugin.cancelAll();
  }
}
