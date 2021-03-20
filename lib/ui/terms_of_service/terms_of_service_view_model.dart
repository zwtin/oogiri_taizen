import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final termsOfServiceViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<TermsOfServiceViewModel, TermsOfServiceViewModelParameter>(
  (ref, parameter) {
    final termsOfServiceViewModel = TermsOfServiceViewModel(
      parameter.screenId,
      ref,
    );
    ref.onDispose(termsOfServiceViewModel.disposed);
    return termsOfServiceViewModel;
  },
);

class TermsOfServiceViewModelParameter {
  TermsOfServiceViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class TermsOfServiceViewModel extends ChangeNotifier {
  TermsOfServiceViewModel(
    this.id,
    this.providerReference,
  );

  final String id;
  final ProviderReference providerReference;

  Future<void> disposed() async {
    debugPrint(id);
  }
}
