import 'package:oogiri_taizen/domain/entity/push_notification_setting.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class PushNotificationUseCase {
  Stream<PushNotificationSetting?> getStream();
  Future<Result<void>> setPushNotificationSetting({
    required PushNotificationSetting setting,
  });
  Future<Result<void>> requestPermission();
}
