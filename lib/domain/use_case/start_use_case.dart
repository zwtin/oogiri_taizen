import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/app_info_repository.dart';
import 'package:oogiri_taizen/domain/repository/remote_config_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/app_info_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/remote_config_repository_impl.dart';

final startUseCaseProvider =
    ChangeNotifierProvider.autoDispose.family<StartUseCase, UniqueKey>(
  (ref, key) {
    return StartUseCase(
      key,
      ref.watch(appInfoRepositoryProvider),
      ref.watch(remoteConfigRepositoryProvider),
    );
  },
);

class StartUseCase extends ChangeNotifier {
  StartUseCase(
    this._key,
    this._appInfoRepository,
    this._remoteConfigRepository,
  );

  final AppInfoRepository _appInfoRepository;
  final RemoteConfigRepository _remoteConfigRepository;

  final UniqueKey _key;
  final _logger = Logger();

  Future<Result<bool>> getNeedUpdate() async {
    final forceUpdateAppVersionResult =
        await _remoteConfigRepository.getForceUpdateAppVersion();
    if (forceUpdateAppVersionResult is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'アプリバージョンの確認に失敗しました',
        ),
      );
    }
    final forceUpdateAppVersion =
        (forceUpdateAppVersionResult as Success<String>).value;
    final forceUpdateAppVersionList =
        forceUpdateAppVersion.split('.').map(int.parse).toList();

    final currentVersionResult = await _appInfoRepository.getVersion();
    if (currentVersionResult is Failure) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'アプリバージョンの確認に失敗しました',
        ),
      );
    }
    final currentVersion = (currentVersionResult as Success<String>).value;
    final currentVersionList =
        currentVersion.split('.').map(int.parse).toList();

    final isNeedUpdate = _isNeedUpdate(
      forceUpdateVersion: forceUpdateAppVersionList,
      currentVersion: currentVersionList,
    );
    return Result.success(isNeedUpdate);
  }

  bool _isNeedUpdate({
    required List<int> forceUpdateVersion,
    required List<int> currentVersion,
  }) {
    final forceUpdateVersionMap = forceUpdateVersion.asMap();
    for (final index in forceUpdateVersionMap.keys) {
      final forceUpdateVersionElement = forceUpdateVersion.elementAt(index);
      final currentVersionElement = currentVersion.elementAt(index);
      if (forceUpdateVersionElement > currentVersionElement) {
        return true;
      } else {
        continue;
      }
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('StartUseCase dispose $_key');
  }
}
