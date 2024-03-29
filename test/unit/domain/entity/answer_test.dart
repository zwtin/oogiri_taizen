import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';

import 'topic_test.mocks.dart';
import 'user_test.mocks.dart';

@GenerateMocks([Answer])
void main() {
  group('Entity Test', () {
    test('Answer Property', () {
      final mockTopic = MockTopic();
      when(mockTopic.id).thenReturn('MockTopic');

      final mockUser = MockUser();
      when(mockUser.id).thenReturn('MockUser');

      final answer = Answer(
        id: 'id',
        text: 'text',
        viewedCount: 0,
        isLike: false,
        likedCount: 0,
        isFavor: false,
        favoredCount: 0,
        popularPoint: 0,
        topic: mockTopic,
        createdUser: mockUser,
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
      expect(answer.topic.id, 'MockTopic');
      expect(answer.createdUser.id, 'MockUser');
      expect(answer.createdAt, DateTime(2022, 6, 3, 11, 15));
    });
  });
}
