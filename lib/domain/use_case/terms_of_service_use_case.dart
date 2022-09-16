import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/remote_config_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/remote_config_repository_impl.dart';

final termsOfServiceUseCaseProvider =
    ChangeNotifierProvider.autoDispose.family<TermsOfServiceUseCase, UniqueKey>(
  (ref, key) {
    return TermsOfServiceUseCase(
      key,
      ref.watch(remoteConfigRepositoryProvider),
    );
  },
);

class TermsOfServiceUseCase extends ChangeNotifier {
  TermsOfServiceUseCase(
    this._key,
    this._remoteConfigRepository,
  );

  final RemoteConfigRepository _remoteConfigRepository;

  final UniqueKey _key;
  final _logger = Logger();

  Future<Result<String>> getTermsOfService() async {
    return _remoteConfigRepository.getTermsOfService();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('TermsOfServiceUseCase dispose $_key');
  }
}
