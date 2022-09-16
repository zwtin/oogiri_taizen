import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/app_info_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/streaming_shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

final appInfoRepositoryProvider = Provider.autoDispose<AppInfoRepository>(
  (ref) {
    final appInfoRepository = AppInfoRepositoryImpl(
      ref.watch(packageInfoProvider),
    );
    ref.onDispose(appInfoRepository.dispose);
    return appInfoRepository;
  },
);

class AppInfoRepositoryImpl implements AppInfoRepository {
  AppInfoRepositoryImpl(
    this._packageInfo,
  );

  final _logger = Logger();
  final PackageInfo _packageInfo;

  @override
  Future<Result<String>> getVersion() async {
    final version = _packageInfo.version;
    return Result.success(version);
  }

  void dispose() {
    _logger.d('AppInfoRepositoryImpl dispose');
  }
}
