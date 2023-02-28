import 'package:calendar/common/utils/custom_date_utils.dart';
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
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> setNotification(ScheduleModel schedule) async {
    DateTime start = schedule.start;

    if(start.subtract(const Duration(minutes: 10)).isBefore(CustomDateUtils.getNow())){
      return;
    }

    DateTime notiDateTime = schedule.start.subtract(schedule.notificationInterval.toDuration());
    // 시간 기입 안 한 커맨드로 만들면 무조건 0시 시작에 1일 전 푸쉬 알림이니까
    // 0시에 푸쉬 알림 가면 괜히 잠깰 것 같다
    // 그래서 이런 경우엔 12시에 울리는 걸로~
    if(schedule.type == ScheduleType.allDay && notiDateTime.hour == 0){
      notiDateTime = notiDateTime.add(const Duration(hours: 12));
    }
    if(notiDateTime.isBefore(CustomDateUtils.getNow())){
      return;
    }
    var time = tz.TZDateTime.from(
      schedule.start.subtract(schedule.notificationInterval.toDuration()),
      tz.local,
    );
    print(time);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        _getNotificationId(schedule.id),
        schedule.title,
        '${start.year}.${start.month}.${start.day} ${start.hour}:${start.minute}',
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
