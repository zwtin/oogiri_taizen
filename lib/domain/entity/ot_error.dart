import 'package:freezed_annotation/freezed_annotation.dart';

part 'ot_error.freezed.dart';

@freezed
abstract class OTError implements _$OTError {
  const factory OTError({
    required String title,
    required String text,
  }) = _OTError;
  const OTError._();
}
