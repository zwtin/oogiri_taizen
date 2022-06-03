import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';

@GenerateMocks([Answer])
void main() {
  group('Entity Test', () {
    test('Answer Property', () {
      final answer = Answer(
        id: 'id',
        text: 'text',
        viewedCount: 0,
        isLike: false,
        likedCount: 0,
        isFavor: false,
        favoredCount: 0,
        popularPoint: 0,
        topicId: 'topicId',
        topic: null,
        createdUserId: 'createdUserId',
        createdUser: null,
        createdAt: DateTime(2022, 6, 3, 11, 15),
      );
      expect(answer.id, 'id');
      expect(answer.text, 'text');
      expect(answer.viewedCount, 0);
      expect(answer.isLike, false);
      expect(answer.likedCount, 0);
      expect(answer.isFavor, false);
      expect(answer.favoredCount, 0);
      expect(answer.popularPoint, 0);
      expect(answer.topicId, 'topicId');
      expect(answer.topic, null);
      expect(answer.createdUserId, 'createdUserId');
      expect(answer.createdUser, null);
      expect(answer.createdAt, DateTime(2022, 6, 3, 11, 15));
    });
  });
}
