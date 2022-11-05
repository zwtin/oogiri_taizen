import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';

import 'answer_test.mocks.dart';

@GenerateMocks([Answers])
void main() {
  group('Entity Test', () {
    test('length Method', () {
      const emptyAnswers = Answers(list: []);
      final notEmptyAnswers = Answers(list: [MockAnswer()]);
      expect(emptyAnswers.length, 0);
      expect(notEmptyAnswers.length, 1);
    });

    test('isEmpty Method', () {
      const emptyAnswers = Answers(list: []);
      final notEmptyAnswers = Answers(list: [MockAnswer()]);
      expect(emptyAnswers.isEmpty, true);
      expect(notEmptyAnswers.isEmpty, false);
    });

    test('firstOrNull Method', () {
      const emptyAnswers = Answers(list: []);

      final answer1 = MockAnswer();
      when(answer1.id).thenReturn('answer1');
      final answer2 = MockAnswer();
      when(answer2.id).thenReturn('answer2');
      final answer3 = MockAnswer();
      when(answer3.id).thenReturn('answer3');
      final notEmptyAnswers = Answers(list: [
        answer1,
        answer2,
        answer3,
      ]);

      expect(emptyAnswers.firstOrNull?.id, null);
      expect(notEmptyAnswers.firstOrNull?.id, 'answer1');
    });

    test('lastOrNull Method', () {
      const emptyAnswers = Answers(list: []);

      final answer1 = MockAnswer();
      when(answer1.id).thenReturn('answer1');
      final answer2 = MockAnswer();
      when(answer2.id).thenReturn('answer2');
      final answer3 = MockAnswer();
      when(answer3.id).thenReturn('answer3');
      final notEmptyAnswers = Answers(list: [
        answer1,
        answer2,
        answer3,
      ]);

      expect(emptyAnswers.lastOrNull?.id, null);
      expect(notEmptyAnswers.lastOrNull?.id, 'answer3');
    });
  });
}
