import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/answer_detail_view.dart';
import 'package:oogiri_taizen/app/view/profile_view.dart';

final answerListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<AnswerListViewModel, UniqueKey>(
  (ref, key) {
    return AnswerListViewModel(
      key,
      ref.read,
    );
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this._key,
    this._reader,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  Future<void> transitionToImageDetail({
    required String imageUrl,
    required String imageTag,
  }) async {
    if (imageUrl.isEmpty) {
      return;
    }
    await _reader.call(routerNotiferProvider(_key)).presentImage(
          imageUrl: imageUrl,
          imageTag: imageTag,
        );
  }

  Future<void> transitionToAnswerDetail({required String id}) async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: AnswerDetailView(
            answerId: id,
          ),
        );
  }

  Future<void> transitionToProfile({
    required String id,
  }) async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: ProfileView(userId: id),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('AnswerListViewModel dispose $_key');
  }
}
