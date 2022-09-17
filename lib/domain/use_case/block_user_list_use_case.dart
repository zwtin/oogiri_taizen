import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/entity/users.dart';
import 'package:oogiri_taizen/domain/repository/block_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/block_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final blockUserListUseCaseProvider =
    Provider.autoDispose.family<BlockUserListUseCase, UniqueKey>(
  (ref, key) {
    return BlockUserListUseCase(
      key,
      ref.watch(userRepositoryProvider),
      ref.watch(blockRepositoryProvider),
    );
  },
);

class BlockUserListUseCase extends ChangeNotifier {
  BlockUserListUseCase(
    this._key,
    this._userRepository,
    this._blockRepository,
  ) {
    _blockUserIdsSubscription =
        _blockRepository.getBlockTopicIdsStream().listen(
      (ids) {
        _blockUserIds = ids;
      },
    );
  }

  final UserRepository _userRepository;
  final BlockRepository _blockRepository;

  final UniqueKey _key;
  final _logger = Logger();

  bool hasNext = true;
  bool _isConnecting = false;
  Users loadedUsers = const Users(list: []);

  List<String> _blockUserIds = [];
  StreamSubscription<List<String>>? _blockUserIdsSubscription;

  Future<Result<void>> resetBlockUsers() async {
    final clearLoadedUsersResult = await _clearLoadedUsers();
    if (clearLoadedUsersResult is Failure) {
      return clearLoadedUsersResult;
    }
    return fetchBlockUsers();
  }

  Future<Result<void>> _clearLoadedUsers() async {
    loadedUsers = const Users(list: []);
    hasNext = true;

    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> fetchBlockUsers() async {
    if (_isConnecting) {
      return const Result.success(null);
    }
    _isConnecting = true;
    notifyListeners();
    var willLoadUserIds = <String>[];
    if (_blockUserIds.isEmpty) {
      willLoadUserIds = _blockUserIds.take(10).toList();
    } else {
      willLoadUserIds = _blockUserIds
          .skipWhile((value) => value != loadedUsers.lastOrNull?.id)
          .take(10)
          .toList();
    }
    for (final blockUserId in willLoadUserIds) {
      final userResult = await _userRepository.getUser(id: blockUserId);

      if (userResult is Success<User>) {
        loadedUsers = loadedUsers.added(userResult.value);
      }
    }
    hasNext = _blockUserIds.length == loadedUsers.length;
    _isConnecting = false;
    notifyListeners();
    return const Result.success(null);
  }

  Future<Result<void>> removeBlockUser({required User user}) async {
    final result = await _blockRepository.removeBlockUserId(userId: user.id);
    if (result is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'ブロックユーザーの解除に失敗しました',
        ),
      );
    }
    loadedUsers = loadedUsers.removed(user);
    notifyListeners();
    return const Result.success(null);
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BlockUserListUseCase dispose $_key');

    _blockUserIdsSubscription?.cancel();
  }
}
