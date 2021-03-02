import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final privacyPolicyViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<PrivacyPolicyViewModel, String>(
  (ref, id) {
    final privacyPolicyViewModel = PrivacyPolicyViewModel(
      id,
      ref,
    );
    ref.onDispose(privacyPolicyViewModel.disposed);
    return privacyPolicyViewModel;
  },
);

class PrivacyPolicyViewModel extends ChangeNotifier {
  PrivacyPolicyViewModel(
    this.id,
    this.providerReference,
  );

  final String id;
  final ProviderReference providerReference;

  Future<void> disposed() async {
    debugPrint(id);
  }
}
