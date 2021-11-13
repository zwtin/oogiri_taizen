import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/repository/app_info_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/streaming_shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

final appInfoRepositoryProvider = Provider.autoDispose<AppInfoRepository>(
  (ref) {
    final appInfoRepository = AppInfoRepositoryImpl(
      ref.watch(packageInfoProvider),
    );
    ref.onDispose(appInfoRepository.disposed);
    return appInfoRepository;
  },
);

class AppInfoRepositoryImpl implements AppInfoRepository {
  AppInfoRepositoryImpl(
    this._packageInfo,
  );

  final PackageInfo _packageInfo;

  @override
  String getVersion() {
    return _packageInfo.version;
  }

  Future<void> disposed() async {
    debugPrint('AppInfoRepositoryImpl disposed');
  }
}
