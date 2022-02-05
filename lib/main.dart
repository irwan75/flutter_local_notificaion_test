import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
// import 'dart:ui';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/material.dart';
import 'local_notification.dart' as notify;

/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';

// /// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register the UI isolate's SendPort to allow for communication from the
  // background isolate.
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );

  notify.initNotifications();

  AndroidAlarmManager.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // // The background
  static SendPort uiSendPort;

  Future<void> showNotification(data) async {
    print(data);
    var rand = Random();
    var hash = rand.nextInt(100);
    DateTime now = DateTime.now().toUtc().add(Duration(seconds: 1));

    await notify.singleNotification(
      now,
      "Hello $hash",
      "This is hello message",
      hash,
    );
  }

  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');
    // // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send("hi");
  }

  @override
  void initState() {
    super.initState();

    port.listen((data) async => await showNotification(data));

    runAlarm();
  }

  void runAlarm() async {
    await AndroidAlarmManager.periodic(
      Duration(minutes: 1),
      0,
      callback,
      rescheduleOnReboot: true,
      exact: true,
      wakeup: true,
    );
    print("OK");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Notification here"),
      ),
    );
  }
}
