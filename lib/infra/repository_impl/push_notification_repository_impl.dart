import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/push_notification_setting.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/push_notification_repository.dart';

final pushNotificationRepositoryProvider =
    Provider.autoDispose<PushNotificationRepository>(
  (ref) {
    final pushNotificationRepository = PushNotificationRepositoryImpl();
    ref.onDispose(pushNotificationRepository.dispose);
    return pushNotificationRepository;
  },
);

class PushNotificationRepositoryImpl implements PushNotificationRepository {
  final _logger = Logger();
  final _messaging = FirebaseMessaging.instance;
  final _firestore = FirebaseFirestore.instance;

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
  Stream<PushNotificationSetting> getPushNotificationSetting({
    required String userId,
  }) {
    final stream = _firestore
        .collection('push_notifications')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return const PushNotificationSetting(
          whenLiked: false,
          whenFavored: false,
        );
      }
      return PushNotificationSetting(
        whenLiked: data['when_liked'] as bool,
        whenFavored: data['when_favored'] as bool,
      );
    });
    return stream;
  }

  @override
  Future<Result<void>> createPushNotificationSetting({
    required String userId,
  }) async {
    try {
      final ref = _firestore.collection('push_notifications').doc(userId);
      final data = {
        'id': userId,
        'updated_at': FieldValue.serverTimestamp(),
        'when_liked': true,
        'when_favored': true,
      };
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          transaction.set(
            ref,
            data,
          );
        },
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> updatePushNotificationSetting({
    required String userId,
    required PushNotificationSetting setting,
  }) async {
    try {
      final ref = _firestore.collection('push_notifications').doc(userId);
      final data = {
        'id': userId,
        'updated_at': FieldValue.serverTimestamp(),
        'when_liked': setting.whenLiked,
        'when_favored': setting.whenFavored,
      };
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          transaction.update(
            ref,
            data,
          );
        },
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('PushNotificationRepository dispose');
  }
}
