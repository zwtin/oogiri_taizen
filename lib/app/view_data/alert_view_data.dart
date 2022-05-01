import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_view_data.freezed.dart';

@freezed
class AlertViewData with _$AlertViewData {
  const factory AlertViewData({
    required String title,
    required String message,
    String? okButtonTitle,
    void Function()? okButtonAction,
    String? cancelButtonTitle,
    void Function()? cancelButtonAction,
  }) = _AlertViewData;
}
