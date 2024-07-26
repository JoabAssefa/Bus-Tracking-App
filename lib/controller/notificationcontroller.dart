import '/Services/notification_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    NotificationService().initialization();
  }

  static Future showNotificationController(
      {int id = 0, String? title, String? payload, String? body}) async {
    await NotificationService.showNotification(
        title: title, body: body, payload: payload);
  }

  static Future scheduleNotificationController(
      {int id = 0,
      String? title,
      String? payload,
      String? body,
      required DateTime dateTime}) async {
    await NotificationService.showScheduleNotification(
        dateTime: dateTime, title: title, payload: payload, body: body);
  }
}