import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/push_notification_repository.dart';

final pushNotificationRepositoryProvider =
    Provider.autoDispose<PushNotificationRepository>(
  (ref) {
    final pushNotificationRepository = PushNotificationRepositoryImpl();
    ref.onDispose(pushNotificationRepository.disposed);
    return pushNotificationRepository;
  },
);

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  Future<Result<void>> requestPermission() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  Future<void> disposed() async {
    debugPrint('PushNotificationRepository disposed');
  }
}
