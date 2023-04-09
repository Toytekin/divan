import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//zaman uyum pakettleri

class NotificationServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  Future<void> initializationSettings() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> anindaBildirimGonder(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  // Belli aralıklarala bildirim gelmesini sağlama
  Future<void> gunlukBildirimGonder(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      title,
      body,
      // 1 dk da bir
      RepeatInterval.everyMinute,
      notificationDetails,
    );
  }

  Future<void> deneme(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high);
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
  }

  //Bildirimleri kapatma
  void stopNotification() {
    _flutterLocalNotificationsPlugin.cancelAll();
  }

  //
  //
}

//ic_launcher.png
