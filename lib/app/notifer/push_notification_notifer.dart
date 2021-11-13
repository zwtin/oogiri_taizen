import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final pushNotificationNotiferProvider =
    ChangeNotifierProvider.autoDispose<PushNotificationNotifer>(
  (ref) {
    return PushNotificationNotifer();
  },
);

// notiferに置いていいものかは検討（repositoryとかじゃね？）
class PushNotificationNotifer extends ChangeNotifier {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> requestPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
}
