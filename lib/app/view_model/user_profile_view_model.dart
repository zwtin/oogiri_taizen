import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/answer_detail_view.dart';
import 'package:oogiri_taizen/app/view_data/user_profile_view_data.dart';
import 'package:oogiri_taizen/domain/use_case/user_profile_use_case.dart';
import 'package:tuple/tuple.dart';

final userProfileViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<UserProfileViewModel, Tuple2<UniqueKey, String>>(
  (ref, tuple) {
    return UserProfileViewModel(
      tuple.item1,
      tuple.item2,
      ref.read,
      ref.watch(userProfileUseCaseProvider(tuple)),
    );
  },
);

class UserProfileViewModel extends ChangeNotifier {
  UserProfileViewModel(
    this._key,
    this._userId,
    this._reader,
    this._userProfileUseCase,
  );

  final UniqueKey _key;
  final String _userId;
  final Reader _reader;
  final _logger = Logger();

  final UserProfileUseCase _userProfileUseCase;

  UserProfileViewData? get viewData {
    final user = _userProfileUseCase.user;
    if (user == null) {
      return null;
    }
    return UserProfileViewData(
      id: user.id,
      name: user.name,
      imageUrl: user.imageUrl,
      introduction: user.introduction,
    );
  }

  Future<void> transitionToAnswerDetail({required String id}) async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: AnswerDetailView(
            answerId: id,
          ),
        );
  }

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

  @override
  void dispose() {
    super.dispose();
    _logger.d('UserProfileViewModel dispose $_key');
  }
}
