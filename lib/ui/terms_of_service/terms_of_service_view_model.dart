import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final termsOfServiceViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<TermsOfServiceViewModel, String>(
  (ref, id) {
    final termsOfServiceViewModel = TermsOfServiceViewModel(
      id,
      ref,
    );
    ref.onDispose(termsOfServiceViewModel.disposed);
    return termsOfServiceViewModel;
  },
);

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
