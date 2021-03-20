import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final privacyPolicyViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<PrivacyPolicyViewModel, PrivacyPolicyViewModelParameter>(
  (ref, parameter) {
    final privacyPolicyViewModel = PrivacyPolicyViewModel(
      parameter.screenId,
      ref,
    );
    ref.onDispose(privacyPolicyViewModel.disposed);
    return privacyPolicyViewModel;
  },
);

class PrivacyPolicyViewModelParameter {
  PrivacyPolicyViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

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
