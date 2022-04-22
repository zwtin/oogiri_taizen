import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

part 'topic.freezed.dart';

@freezed
abstract class Topic implements _$Topic {
  const factory Topic({
    required String id,
    required String text,
    required String? imageUrl,
    required int answeredCount,
    required String createdUserId,
    User? createdUser,
    required DateTime createdAt,
  }) = _Topic;
  const Topic._();
}
