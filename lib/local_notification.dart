import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  var initializeAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializeIOS = IOSInitializationSettings();
  var initializationSettings =
      InitializationSettings(initializeAndroid, initializeIOS);

  await localNotificationsPlugin.initialize(initializationSettings);
}

Future singleNotification(
    DateTime scheduledDate, String title, String body, int hashCode,
    {String sound}) async {
  var androidChannel = AndroidNotificationDetails(
    'channel-id',
    'channel-name',
    'channel-description',
    importance: Importance.Max,
    priority: Priority.Max,
  );

  var iosChannel = IOSNotificationDetails();
  var platformChannel = NotificationDetails(androidChannel, iosChannel);

  localNotificationsPlugin.schedule(
      hashCode, title, body, scheduledDate, platformChannel,
      payload: hashCode.toString());
}
