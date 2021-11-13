import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/use_case/terms_of_service_use_case.dart';
import 'package:oogiri_taizen/domain/use_case_impl/terms_of_service_use_case_impl.dart';

final termsOfServiceViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<TermsOfServiceViewModel, UniqueKey>(
  (ref, key) {
    final termsOfServiceViewModel = TermsOfServiceViewModel(
      key,
      ref.read,
      ref.watch(termsOfServiceUseCaseProvider),
    );
    ref.onDispose(termsOfServiceViewModel.disposed);
    return termsOfServiceViewModel;
  },
);

class TermsOfServiceViewModel extends ChangeNotifier {
  TermsOfServiceViewModel(
    this._key,
    this._reader,
    this._termsOfServiceUseCase,
  ) {
    html = _termsOfServiceUseCase.getTermsOfService();
    notifyListeners();
  }

  final UniqueKey _key;
  final Reader _reader;

  final TermsOfServiceUseCase _termsOfServiceUseCase;

  String html = '';

  Future<void> disposed() async {
    debugPrint('TermsOfServiceViewModel disposed $_key');
  }
}
