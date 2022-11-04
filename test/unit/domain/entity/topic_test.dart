import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';

import 'user_test.mocks.dart';

@GenerateMocks([Topic])
void main() {
  group('Entity Test', () {
    test('Topic Property', () {
      final hasImageTopic = Topic(
        id: 'id',
        text: 'text',
        imageUrl: 'imageUrl',
        answeredCount: 1,
        createdUser: MockUser(),
        createdAt: DateTime(2022, 6, 3, 11, 15),
      );
      final noImageTopic = Topic(
        id: 'id',
        text: 'text',
        imageUrl: null,
        answeredCount: 0,
        createdUser: MockUser(),
        createdAt: DateTime(2022, 6, 3, 11, 15),
      );
      expect(hasImageTopic.id, 'id');
      expect(hasImageTopic.text, 'text');
      expect(hasImageTopic.imageUrl, 'imageUrl');
      expect(hasImageTopic.answeredCount, 1);
      expect(hasImageTopic.createdUser, MockUser());
      expect(hasImageTopic.createdAt, DateTime(2022, 6, 3, 11, 15));
      expect(noImageTopic.id, 'id');
      expect(noImageTopic.text, 'text');
      expect(noImageTopic.imageUrl, null);
      expect(noImageTopic.answeredCount, 0);
      expect(noImageTopic.createdUser, MockUser());
      expect(noImageTopic.createdAt, DateTime(2022, 6, 3, 11, 15));
    });
  });
}
