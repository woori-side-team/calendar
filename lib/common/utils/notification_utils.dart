import 'package:calendar/domain/models/schedule_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationUtils {
  static final NotificationUtils _instance = NotificationUtils._internal();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings initializationSettingsDarwin =
      const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'));

  factory NotificationUtils() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    return _instance;
  }

  NotificationUtils._internal();

  int _getNotificationId(String id) {
    return id.hashCode;
  }

  Future<void> init() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showNotification({required int id, required String title, required String body}) async {
    await flutterLocalNotificationsPlugin.show(
        id, title, body, notificationDetails,
        payload: 'item x');
  }

  /// [interval]이 30분이면 스케줄 30분 전에 푸쉬알림이 뜬다.
  Future<void> setNotification(ScheduleModel schedule, Duration interval) async {
    var time = tz.TZDateTime.from(
      schedule.start.subtract(interval),
      tz.local,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        _getNotificationId(schedule.id),
        schedule.title,
        schedule.content,
        time,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> removeNotification(String id) async {
    await flutterLocalNotificationsPlugin.cancel(_getNotificationId(id));
  }
}
