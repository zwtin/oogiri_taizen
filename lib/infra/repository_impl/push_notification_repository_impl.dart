import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/push_notification_setting.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  @override
  Stream<PushNotificationSetting?> getPushNotificationSetting({
    required String userId,
  }) {
    final stream = _firestore
        .collection('push_notifications')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return null;
      }
      return PushNotificationSetting(
        whenLiked: data['when_liked'] as bool,
        whenFavored: data['when_favored'] as bool,
      );
    });
    return stream;
  }

  @override
  Future<Result<void>> setPushNotificationSetting({
    required String userId,
    required PushNotificationSetting setting,
  }) async {
    try {
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final ref = _firestore.collection('push_notifications').doc(userId);
          final doc = await transaction.get(ref);
          final data = doc.data();
          if (data == null) {
            throw OTException();
          }

          final map = {
            'id': userId,
            'updated_at': FieldValue.serverTimestamp(),
            'when_liked': setting.whenLiked,
            'when_favored': setting.whenFavored,
          };
          transaction.update(
            ref,
            map,
          );
        },
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
