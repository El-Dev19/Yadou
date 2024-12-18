import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/main.dart';

class NotificationService {
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'reservation_channel',
      'Réservations',
      channelDescription: 'Notifications des réservations',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Identifiant unique de la notification
      title,
      body,
      platformChannelSpecifics,
      payload: 'Réservation confirmée',
    );
  }
}