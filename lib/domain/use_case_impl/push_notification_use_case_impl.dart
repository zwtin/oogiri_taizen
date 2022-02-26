import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/push_notification_setting.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/push_notification_repository.dart';
import 'package:oogiri_taizen/domain/use_case/push_notification_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/push_notification_repository_impl.dart';

final pushNotificationUseCaseProvider =
    Provider.autoDispose<PushNotificationUseCase>(
  (ref) {
    final pushNotificationUseCase = PushNotificationUseCaseImpl(
      ref.watch(authenticationRepositoryProvider),
      ref.watch(pushNotificationRepositoryProvider),
    );
    ref.onDispose(pushNotificationUseCase.disposed);
    return pushNotificationUseCase;
  },
);

class PushNotificationUseCaseImpl implements PushNotificationUseCase {
  PushNotificationUseCaseImpl(
    this._authenticationRepository,
    this._pushNotificationRepository,
  ) {
    _authenticationRepository.getLoginUserStream().listen(
      (loginUser) async {
        _userId = loginUser?.id;
        await _resetSetting();
      },
    );
    _userId = _authenticationRepository.getLoginUser()?.id;
    _resetSetting();
  }

  final AuthenticationRepository _authenticationRepository;
  final PushNotificationRepository _pushNotificationRepository;

  String? _userId;
  PushNotificationSetting? _setting;

  final _streamController = StreamController<PushNotificationSetting?>();
  StreamSubscription<PushNotificationSetting?>? _streamSubscription;

  void _setPushNotificationSetting({
    required PushNotificationSetting? setting,
  }) {
    if (!_streamController.isClosed) {
      _setting = setting;
      _streamController.sink.add(setting);
    }
  }

  @override
  Stream<PushNotificationSetting?> getStream() {
    return _streamController.stream;
  }

  Future<Result<void>> _resetSetting() async {
    await _clearSetting();
    final result = await _fetchSetting();
    if (result is Failure<OTException>) {
      return result;
    } else if (result is Failure) {
      return Result.failure(OTException(alertMessage: '通信エラーが発生しました'));
    }
    return const Result.success(null);
  }

  Future<void> _clearSetting() async {
    _setPushNotificationSetting(
      setting: null,
    );
    await _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  Future<Result<void>> _fetchSetting() async {
    if (_userId == null) {
      return Result.failure(OTException(alertMessage: 'ログインが必要です'));
    }
    _streamSubscription = _pushNotificationRepository
        .getPushNotificationSetting(userId: _userId!)
        .listen((setting) {
      _setPushNotificationSetting(setting: setting);
    });
    return const Result.success(null);
  }

  @override
  Future<Result<void>> requestPermission() async {
    final result = await _pushNotificationRepository.requestPermission();
    if (result is Failure) {
      return Result.failure(
        OTException(alertMessage: 'プッシュ通知の許可ダイアログを出せませんでした'),
      );
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> setPushNotificationSetting({
    required PushNotificationSetting setting,
  }) async {
    if (_userId == null) {
      return Result.failure(OTException(alertMessage: 'ログインが必要です'));
    }
    final result = await _pushNotificationRepository.setPushNotificationSetting(
      userId: _userId!,
      setting: setting,
    );
    if (result is Failure) {
      return Result.failure(
        OTException(alertMessage: '通信エラーが発生しました'),
      );
    }
    return const Result.success(null);
  }

  Future<void> disposed() async {
    await _streamController.close();
    await _streamSubscription?.cancel();
    debugPrint('PushNotificationUseCaseImpl disposed');
  }
}
