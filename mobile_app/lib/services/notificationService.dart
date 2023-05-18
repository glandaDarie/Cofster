// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   FlutterLocalNotificationsPlugin notificationsPlugin;

//   NotificationService() {
//     notificationsPlugin = FlutterLocalNotificationsPlugin();
//     notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         .requestPermission();
//   }

//   Future<void> initNotification(String imgPath) async {
//     AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings(imgPath);

//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//             requestAlertPermission: true,
//             requestBadgePermission: true,
//             requestSoundPermission: true,
//             onDidReceiveLocalNotification:
//                 (int id, String title, String body, String payload) async {});

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//             android: initializationSettingsAndroid,
//             iOS: initializationSettingsIOS);
//     await notificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) async {});
//   }

//   NotificationDetails notificationDetails() {
//     return const NotificationDetails(
//         android: AndroidNotificationDetails("channel_id_1", "Channel 1",
//             importance: Importance.max),
//         iOS: DarwinNotificationDetails());
//   }

//   Future<dynamic> showNotification(
//       {int id = 0, String title, String body, String payLoad}) async {
//     return notificationsPlugin.show(
//         id, title, body, await notificationDetails());
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin notificationsPlugin;

  NotificationService() {
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .requestPermission();
  }

  Future<void> initNotification(String imgPath) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(imgPath);

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id_1',
      'Channel 1',
      importance: Importance.max,
    );
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        .createNotificationChannel(channel);

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: null,
    );
  }

  Future<dynamic> showNotification(
      {int id = 0, String title, String body, String payLoad}) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_1',
        'Channel 1',
        importance: Importance.max,
      ),
      iOS: null,
    );

    return notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}
