import 'package:freezed_annotation/freezed_annotation.dart';
part 'alert_view_data.freezed.dart';

@freezed
class AlertViewData with _$AlertViewData {
  const factory AlertViewData({
    required String title,
    required String message,
    required String? okButtonTitle,
    required void Function()? okButtonAction,
    required String? cancelButtonTitle,
    required void Function()? cancelButtonAction,
  }) = _AlertViewData;
}
