import 'package:freezed_annotation/freezed_annotation.dart';

part 'ot_exception.freezed.dart';

@freezed
abstract class OTException implements _$OTException {
  const factory OTException({
    required String title,
    required String text,
  }) = _OTException;
  const OTException._();
}
