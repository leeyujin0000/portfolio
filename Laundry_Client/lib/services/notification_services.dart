import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laundry/firebase_options.dart';
import 'package:laundry/services/server_domain.dart';
import 'package:http/http.dart' as http;

class NotificationServices {

  // background 푸시 알림 수신
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  Future<void> fcmSetting() async {

    // firebase core 기능 사용을 위한 initializing
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );

    // background 푸시 알림 수신
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    // FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 알림 전송 권한 요청
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: false,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    // foreground 푸시 알림 표시를 위한 알림 중요도 설정
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'laundry_notification',
        'laundry_notification',
        description: '티끌모아빨래 알림',
        importance: Importance.max
    );

    // foreground 푸시 알림 표시를 위한 local notification 설정
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );

    // foreground 푸시 알림 수신
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print('Got a message in the foreground');
      print('Message data: ${message!.data}');

      if (message.notification != null && message.notification?.android != null) {
        print('Message also contained a notification: ${message.notification}');
        flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.notification?.title,
            message.notification?.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@mipmap/ic_launcher',
                )
            )
        );
      }
    });

    // foreground 알림 푸시 클릭
    // const InitializationSettings initializationSettings = InitializationSettings(
    //   android: AndroidInitializationSettings('@mipmap/ic_launcher')
    // );
    // flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (detail) {
    //   if (detail.payload != null) {
    //
    //   }
    // });
  }
  
  // Future<void> setupInteractedMessage() async {
  //   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  //   if (initialMessage != null) {
  //     Navigator.push(context, MaterialPageRoute(builder: builder))
  //   }
  // }

  Future<void> saveToken(String email) async {
    final token = await FirebaseMessaging.instance.getToken();
    print('token = $token');
    String url = '${Server().domain}notification/saveToken';
    Map<String, dynamic> body = {
      "email": email,
      "token": token
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      print('saveTokenSuccess');
    } else {
      print('saveTokenFailed');
    }
  }

  Future<void> sendNotification(String email, String title, String body) async {
    String url = '${Server().domain}notification/notice';
    Map<String, dynamic> body0 = {
      "email": email,
      "title": title,
      "body": body
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body0));
    if (response.statusCode == 200) {
      print('sendNotificationSuccess');
    } else {
      print('sendNotificationFailed');
    }
  }

  Future<void> deleteToken(String email) async {
    String url = '${Server().domain}notification/deleteToken?email=$email';
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode == 200) {
      FirebaseMessaging.instance.deleteToken();
      print('deleteTokenSuccess');
    } else {
      print('deleteTokenFailed');
    }
  }
}