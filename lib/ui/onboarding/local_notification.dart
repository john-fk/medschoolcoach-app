import 'package:Medschoolcoach/utils/user_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Medschoolcoach/ui/onboarding/qotd_notifications.dart';
import 'package:Medschoolcoach/utils/notification_helper.dart';
class LocalNotification
{
  Future<void> setReminder(String time,UserManager userManager) async{
    userManager.markOnboardingComplete();
    if (time.length>2) time = time.substring(0,time.length-4);
    userManager.updateQuestionOfTheDayTime(int.parse(time));
    final FlutterLocalNotificationsPlugin notifsPlugin =
    FlutterLocalNotificationsPlugin();
    var success = await requestPermissions(notifsPlugin);
    if (success) {
      QuestionOfTheDayNotification.
      scheduleNotifications(initialSchedulingDate(int.parse(time)));
    }
  }

  DateTime initialSchedulingDate(int currentValue) {
    if (currentValue == 24) {
      currentValue = 0;
    }
    var newHour = currentValue;
    var time = DateTime.now().toLocal();
    // ignore: lines_longer_than_80_chars
    var scheduledTime = DateTime(time.year, time.month, time.day, newHour, 0, 0, 0, 0);
    return scheduledTime;
  }
}