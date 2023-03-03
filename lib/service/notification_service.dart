import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@singleton
class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @factoryMethod
  static Future<NotificationService> create() async {
    var service = NotificationService();

    return service;
  }

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    //Initialization Settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  int _id = 0;
  final channelId = const Uuid().v1();
  final channelName = const Uuid().v1();

  void push(String title, String body, {String? payload}) {
// #2
    final androidDetail = AndroidNotificationDetails(
        channelId, // channel Id
        channelName // channel Name
        );

    const iosDetail = DarwinNotificationDetails();

    final noticeDetail = NotificationDetails(
      iOS: iosDetail,
      android: androidDetail,
    );

    _flutterLocalNotificationsPlugin.show(++_id, title, body, noticeDetail,
        payload: payload);
  }

  Future<NotificationAppLaunchDetails?> getDetails() async {
    var notificationAppLaunchDetails = await _flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    return notificationAppLaunchDetails;
  }
}
