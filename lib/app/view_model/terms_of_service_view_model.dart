import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/use_case/terms_of_service_use_case.dart';

final termsOfServiceViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<TermsOfServiceViewModel, UniqueKey>(
  (ref, key) {
    return TermsOfServiceViewModel(
      key,
      ref.read,
      ref.watch(termsOfServiceUseCaseProvider(key)),
    );
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
  final _logger = Logger();

  final TermsOfServiceUseCase _termsOfServiceUseCase;

  String html = '';

  @override
  void dispose() {
    super.dispose();
    _logger.d('TermsOfServiceViewModel dispose $_key');
  }
}
