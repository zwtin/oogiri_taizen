import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

@GenerateMocks([User])
void main() {
  group('Entity Test', () {
    test('User Property', () {
      const hasImageUser = User(
        id: 'id',
        name: 'name',
        imageUrl: 'imageUrl',
        introduction: 'introduction',
      );
      const noImageUser = User(
        id: 'id',
        name: 'name',
        imageUrl: null,
        introduction: 'introduction',
      );
      expect(hasImageUser.id, 'id');
      expect(hasImageUser.name, 'name');
      expect(hasImageUser.imageUrl, 'imageUrl');
      expect(hasImageUser.introduction, 'introduction');
      expect(noImageUser.id, 'id');
      expect(noImageUser.name, 'name');
      expect(noImageUser.imageUrl, null);
      expect(noImageUser.introduction, 'introduction');
    });
  });
}
