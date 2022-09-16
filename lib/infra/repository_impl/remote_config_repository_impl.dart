import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/remote_config_repository.dart';

final remoteConfigRepositoryProvider =
    Provider.autoDispose<RemoteConfigRepository>(
  (ref) {
    final remoteConfigRepository = RemoteConfigRepositoryImpl();
    ref.onDispose(remoteConfigRepository.dispose);
    return remoteConfigRepository;
  },
);

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  final _logger = Logger();
  final _remoteConfig = RemoteConfig.instance;

  @override
  Future<Result<String>> getForceUpdateAppVersion() async {
    final forceUpdateAppVersion =
        _remoteConfig.getString('force_update_app_version');
    return Result.success(forceUpdateAppVersion);
  }

  @override
  Future<Result<String>> getTermsOfService() async {
    final termsOfService = _remoteConfig.getString('terms_of_service');
    return Result.success(termsOfService);
  }

  void dispose() {
    _logger.d('RemoteConfigRepositoryImpl dispose');
  }
}
