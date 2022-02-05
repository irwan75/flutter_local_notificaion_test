import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // final BehaviourSubject<ReceivedNotification> didReceivedNotification =
  //     BehaviourSubject<ReceivedNotification>();

  NotificationServices._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestPermission();
    }
    initializePlatformSpesific();
  }

  initializePlatformSpesific() {
    var initializeSettingsAndroid =
        AndroidInitializationSettings('app_notif_icon');
    var initializeSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotification receivedNotification = new ReceivedNotification(
            id: id,
            title: title,
            body: body,
            payload: payload,
          );
          // didReceivedNotification.add(receivedNotification);
        });
  }

  _requestPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }
}

class ReceivedNotification {
  int id;
  String title;
  String body;
  String payload;
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });
}
