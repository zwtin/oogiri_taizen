import 'package:oogiri_taizen/domain/entity/push_notification_setting.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class PushNotificationRepository {
  Future<Result<void>> requestPermission();
  Stream<PushNotificationSetting?> getPushNotificationSetting({
    required String userId,
  });
  Future<Result<void>> setPushNotificationSetting({
    required String userId,
    required PushNotificationSetting setting,
  });
}
