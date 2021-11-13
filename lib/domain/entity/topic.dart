import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
part 'topic.freezed.dart';

@freezed
class Topic with _$Topic {
  const factory Topic({
    required String id,
    required String text,
    required String? imageUrl,
    required int answeredTime,
    required DateTime createdAt,
    required User createdUser,
    required bool isOwn,
  }) = _Topic;
}
