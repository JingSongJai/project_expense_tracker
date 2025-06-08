import 'dart:io';
import 'package:expanse_tracker/model/recure_model.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> requestPermission() async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      } else if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      } else if (Platform.isMacOS) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      }
    }
  }

  static Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    final WindowsInitializationSettings initializationSettingsWindows =
        WindowsInitializationSettings(
          appName: 'Expense Tracker',
          appUserModelId: 'com.ant.expanse_tracker',
          guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb',
          iconPath: 'assets/ico/app_icon.ico',
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux,
          windows: initializationSettingsWindows,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  static void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    WindowsNotificationDetails windowsNotificationDetails =
        WindowsNotificationDetails(duration: WindowsNotificationDuration.long);

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      windows: windowsNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Expense Tracker',
      'Your daily reminder!',
      notificationDetails,
      payload: 'reminder',
    );
    debugPrint('Click');
  }

  static Future<void> setScheduledNotification(
    int id,
    String category,
    String body,
    tz.TZDateTime tzDateTime,
  ) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    WindowsNotificationDetails windowsNotificationDetails =
        WindowsNotificationDetails();

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Remind - $category',
      body,
      tzDateTime,
      NotificationDetails(
        android: androidNotificationDetails,
        windows: windowsNotificationDetails,
        iOS: iosNotificationDetails,
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: category,
    );
  }

  static Future<void> getPendingNotification() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    int i = 1;
    for (var value in pendingNotificationRequests) {
      print('${i++} : ${value.id}');
    }
  }

  static Future<void> cancelNotification(int id, int amount) async {
    for (int i = 0; i < amount; i++) {
      await flutterLocalNotificationsPlugin.cancel(id + i);
    }
    await flutterLocalNotificationsPlugin.cancel(1);
    // await flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> setMultiScheduledNotification(RecureModel recure) async {
    tz.TZDateTime tzDateTime = tz.TZDateTime.now(
      tz.local,
    ).add(Helper.getDuration(recure.frequency, recure.startDate));

    for (int i = 0; i < Helper.getAmountOfScheduledNotification(recure); i++) {
      NotificationController.setScheduledNotification(
        recure.uuid + i,
        recure.category,
        '\$ ${recure.amount} has been added to transaction!',
        tzDateTime,
      );
      tzDateTime = tzDateTime.add(
        Helper.getDuration(recure.frequency, recure.startDate),
      );
    }
  }
}
