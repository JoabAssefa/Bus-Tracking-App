import '../pages/second_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notification =
      FlutterLocalNotificationsPlugin();

  void initialization() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) =>
                selectNotification(payload!));

    const DarwinInitializationSettings initializationSettingsMacOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await _notification.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {});
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await await Get.to(() => SecondPage(payload: payload));
  }

  static Future showNotification(
      {int id = 0, String? title, String? payload, String? body}) async {
    return _notification.show(id, title, body, await _notificationDetail(),
        payload: payload);
  }

  static Future _notificationDetail() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails("id", "name",
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  static Future showScheduleNotification(
      {int id = 0,
      String? title,
      String? payload,
      String? body,
      required DateTime dateTime}) async {
    tz.initializeTimeZones();

    return _notification.zonedSchedule(id, title, body,
        tz.TZDateTime.from(dateTime, tz.local), await _notificationDetail(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
