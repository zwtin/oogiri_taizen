import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/repository/app_info_repository.dart';

import 'package:oogiri_taizen/domain/repository/remote_config_repository.dart';
import 'package:oogiri_taizen/domain/use_case/force_update_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/terms_of_service_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/app_info_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/remote_config_repository_impl.dart';

final termsOfServiceUseCaseProvider =
    Provider.autoDispose<TermsOfServiceUseCase>(
  (ref) {
    final termsOfServiceUseCase = TermsOfServiceUseCaseImpl(
      ref.watch(remoteConfigRepositoryProvider),
    );
    ref.onDispose(termsOfServiceUseCase.disposed);
    return termsOfServiceUseCase;
  },
);

class TermsOfServiceUseCaseImpl implements TermsOfServiceUseCase {
  TermsOfServiceUseCaseImpl(
    this._remoteConfigRepository,
  );

  final RemoteConfigRepository _remoteConfigRepository;

  @override
  String getTermsOfService() {
    return _remoteConfigRepository.getTermsOfService();
  }

  Future<void> disposed() async {
    debugPrint('TermsOfServiceUseCaseImpl disposed');
  }
}
