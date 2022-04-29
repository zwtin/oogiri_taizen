import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/repository/app_info_repository.dart';
import 'package:oogiri_taizen/domain/repository/remote_config_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/app_info_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/remote_config_repository_impl.dart';

final startUseCaseProvider =
    Provider.autoDispose.family<StartUseCase, UniqueKey>(
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

  @override
  void dispose() {
    super.dispose();
    _logger.d('StartUseCase dispose $_key');
  }
}
