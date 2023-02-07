import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';

@freezed
abstract class Topic implements _$Topic {
  const factory Topic({
    required String id,
    required String text,
    required String? imageUrl,
    required int answeredCount,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<TopicAnswer> answers,
  }) = _Topic;
  const Topic._();
}

@freezed
abstract class TopicAnswer implements _$TopicAnswer {
  const factory TopicAnswer({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TopicAnswer;
  const TopicAnswer._();
}
