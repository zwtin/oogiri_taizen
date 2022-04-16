import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_setting.freezed.dart';

@freezed
abstract class PushNotificationSetting implements _$PushNotificationSetting {
  const factory PushNotificationSetting({
    required bool whenLiked,
    required bool whenFavored,
  }) = _PushNotificationSetting;
  const PushNotificationSetting._();
}
