import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';

import 'answer_test.mocks.dart';

@GenerateMocks([Answers])
void main() {
  group('Entity Test', () {
    test('isEmpty Method', () {
      const emptyAnswers = Answers(list: []);
      final notEmptyAnswers = Answers(list: [MockAnswer()]);
      expect(emptyAnswers.isEmpty, true);
      expect(notEmptyAnswers.isEmpty, false);
    });
  });
}
