import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';
import 'package:tuple/tuple.dart';

final userProfileUseCaseProvider =
    Provider.autoDispose.family<UserProfileUseCase, Tuple2<UniqueKey, String>>(
  (ref, tuple) {
    return UserProfileUseCase(
      tuple.item1,
      tuple.item2,
      ref.watch(userRepositoryProvider),
    );
  },
);

class UserProfileUseCase extends ChangeNotifier {
  UserProfileUseCase(
    this._key,
    this._userId,
    this._userRepository,
  ) {
    Future(() async {
      final userResult = await _userRepository.getUser(id: _userId);
      if (userResult is Success<User>) {
        user = userResult.value;
        notifyListeners();
      }
    });
  }

  final UserRepository _userRepository;

  final UniqueKey _key;
  final String _userId;
  final _logger = Logger();

  User? user;

  @override
  void dispose() {
    super.dispose();
    _logger.d('UserProfileUseCase dispose $_key');
  }
}
