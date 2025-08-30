part of 'helpers.dart';

// class _FCMService {
//   // final _firebaseMessaging = FirebaseMessaging.instance;
//   final _onMessageStream = StreamController<NotificationData?>.broadcast();
//   final _onLaunceStream = StreamController<NotificationData?>.broadcast();
//   String _token = "";
//   // final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   Stream<NotificationData?> get onMessage => _onMessageStream.stream;
//   Stream<NotificationData?> get onLaunch => _onLaunceStream.stream;

//   _FCMService() {
//     // Initialize FCM and set up listeners

//     getToken();
//     _firebaseMessaging.onTokenRefresh.listen((fcmToken) {
//       _token = fcmToken;
//     }).onError((err) {});

//     // Listen for messages when the app is in the foreground
//     FirebaseMessaging.onMessage.listen((message) async {
//       log('Foreground message received: ${message.data}');
//       if (message.data.isNotEmpty) {
//         Map<String, dynamic> json = message.data;
//         json.update(
//           'isUser',
//           (value) => "0",
//         );
//         // navigatorKey.currentContext!
//         //     .read<ChatCubit>()
//         //     .addMessage(ChatListDataModel.fromJson(json));
//       }
//       // Extract notification data
//       if (message.notification != null) {
//         NotificationData notificationData =
//             NotificationData.fromJson(message.data);

//         // Show notification using the flutter_local_notifications plugin
//         showNotification(
//           title: message.notification?.title ?? notificationData.title,
//           body: message.notification?.body ?? notificationData.body,
//           hashCode: message.hashCode,
//           payload: notificationData.toJson().toString(),
//         );

//         // Add to stream for listeners
//         _onMessageStream.sink.add(notificationData);
//       }
//     });

//     // Listen for messages when the app is opened via notification
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       log("Message opened: ${message.data}");
//       _onLaunch(message.data);
//     });
//   }

//   Future<void> initializeFcmService() async {
//     if (Platform.isAndroid) {
//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'high_importance_channel',
//         'High Importance Notifications',
//         description: 'This channel is used for important notifications.',
//         importance: Importance.high,
//         playSound: true,
//       );

//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//     }

//     await requestNotificationPermissions();
//   }

//   // Method to  display in app message

//   Future<dynamic> _onLaunch(Map<String, dynamic> message) async {
//     _onLaunceStream.sink.add(NotificationData.fromJson(message));
//   }

//   Future<dynamic> getInitialMessage(context) async {
//     _firebaseMessaging.getInitialMessage().then((value) {
//       if (value != null) {
//         _onLaunch(value.data);
//       }
//     });
//   }

//   Future<bool> requestNotificationPermissions() {
//     return _firebaseMessaging.requestPermission().then((value) => true);
//   }

//   Future<String?> getToken() async {
//     _token = await _firebaseMessaging.getToken() ?? "";
//     log("fcmToken ==> $_token");
//     return Future(() => _token);
//   }

//   String getfcmToken() {
//     return _token;
//   }

//   Future<void> deleteToken() {
//     return _firebaseMessaging.deleteToken();
//   }

//   void dispose() {
//     _onMessageStream.close();
//     _onLaunceStream.close();
//   }

//   // Show notification using flutter_local_notifications
//   void showNotification({
//     required String title,
//     required String body,
//     required int hashCode,
//     String? payload,
//   }) {
//     // Define Android-specific notification details
//     const androidDetails = AndroidNotificationDetails(
//       'high_importance_channel', // id
//       'High Importance Notifications',
//       playSound: true,
//       importance: Importance.max,
//       priority: Priority.high,
//       icon: '@mipmap/ic_launcher',
//     );

//     // Define iOS-specific notification details (if needed)
//     // const iosDetails = DarwinNotificationDetails(
//     //   presentAlert: true,
//     //   presentBadge: true,
//     //   presentSound: true,
//     // );

//     // Combine platform-specific details into a unified structure
//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//       // iOS: iosDetails,
//     );

//     // Show the notification using flutter_local_notifications
//     flutterLocalNotificationsPlugin.show(
//       hashCode, // Unique ID for the notification
//       title, // Title of the notification
//       body, // Body of the notification
//       notificationDetails, // Notification details
//       payload: payload, // Optional payload to handle notification taps
//     );
//   }
// }

// class NotificationData {
//   final String title;
//   final String body;
//   final Map<String, dynamic> data;

//   NotificationData({
//     required this.title,
//     required this.body,
//     required this.data,
//   });

//   // Factory constructor for creating a new NotificationData instance from a map.
//   factory NotificationData.fromJson(Map<String, dynamic> json) {
//     return NotificationData(
//       title: json['title'] ?? '',
//       body: json['body'] ?? '',
//       data: json['data'] ?? {},
//     );
//   }

//   // Method to convert NotificationData instance into a map.
//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'body': body,
//       'data': data,
//     };
//   }
// }

// var firebaseOptions = FirebaseOptions(
//   apiKey: Platform.isIOS
//       ? 'AIzaSyBdheKnhe435bGqE_hbSiX7wRYELV99YzY'
//       : 'AIzaSyBcAViKDq3qqriYYfaShBC-HUsaTo0d4LQ',
//   appId: Platform.isIOS
//       ? '1:901693518949:ios:01965e42ee987b6867c28c'
//       : '1:320229964882:android:171166d54a6a2bd06cf38b',
//   messagingSenderId: '320229964882',
//   projectId: 'foxisland-bf0f6',
//   storageBucket: 'foxisland-bf0f6.firebasestorage.app',
// );

// final fcmService = _FCMService();
