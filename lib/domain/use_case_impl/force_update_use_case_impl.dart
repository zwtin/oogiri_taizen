import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/repository/app_info_repository.dart';

import 'package:oogiri_taizen/domain/repository/remote_config_repository.dart';
import 'package:oogiri_taizen/domain/use_case/force_update_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/app_info_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/remote_config_repository_impl.dart';

final forceUpdateUseCaseProvider = Provider.autoDispose<ForceUpdateUseCase>(
  (ref) {
    final forceUpdateUseCase = ForceUpdateUseCaseImpl(
      ref.watch(appInfoRepositoryProvider),
      ref.watch(remoteConfigRepositoryProvider),
    );
    ref.onDispose(forceUpdateUseCase.disposed);
    return forceUpdateUseCase;
  },
);

class ForceUpdateUseCaseImpl implements ForceUpdateUseCase {
  ForceUpdateUseCaseImpl(
    this._appInfoRepository,
    this._remoteConfigRepository,
  );

  final AppInfoRepository _appInfoRepository;
  final RemoteConfigRepository _remoteConfigRepository;

  @override
  bool getNeedUpdate() {
    final forceUpdateAppVersion =
        _remoteConfigRepository.getForceUpdateAppVersion();
    final forceUpdateAppVersionList =
        forceUpdateAppVersion.split('.').map(int.parse).toList();

    final currentVersion = _appInfoRepository.getVersion();
    final currentVersionList =
        currentVersion.split('.').map(int.parse).toList();

    return _isNeedUpdate(
      forceUpdateVersion: forceUpdateAppVersionList,
      currentVersion: currentVersionList,
    );
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

  Future<void> disposed() async {
    debugPrint('FavorUseCaseImpl disposed');
  }
}
