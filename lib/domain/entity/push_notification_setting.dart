import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_setting.freezed.dart';

@freezed
abstract class PushNotificationSetting implements _$PushNotificationSetting {
  const factory PushNotificationSetting({
    required String id,
    required String userId,
    required bool whenLiked,
    required bool whenFavored,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PushNotificationSetting;
  const PushNotificationSetting._();
}
