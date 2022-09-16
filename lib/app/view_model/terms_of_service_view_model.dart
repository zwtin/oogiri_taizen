import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
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
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final TermsOfServiceUseCase _termsOfServiceUseCase;

  String html = '';

  Future<void> getTermsOfService() async {
    final termsOfServiceResult =
        await _termsOfServiceUseCase.getTermsOfService();
    if (termsOfServiceResult is Failure) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: '利用規約の取得に失敗しました',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
    }
    html = (termsOfServiceResult as Success<String>).value;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('TermsOfServiceViewModel dispose $_key');
  }
}
