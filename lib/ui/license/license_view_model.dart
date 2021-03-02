import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final licenseViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<LicenseViewModel, String>(
  (ref, id) {
    final licenseViewModel = LicenseViewModel(
      id,
      ref,
    );
    ref.onDispose(licenseViewModel.disposed);
    return licenseViewModel;
  },
);

class LicenseViewModel extends ChangeNotifier {
  LicenseViewModel(
    this.id,
    this.providerReference,
  );

  final String id;
  final ProviderReference providerReference;

  Future<void> disposed() async {
    debugPrint(id);
  }
}
