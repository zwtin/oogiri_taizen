import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final licenseViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<LicenseViewModel, LicenseViewModelParameter>(
  (ref, parameter) {
    final licenseViewModel = LicenseViewModel(
      parameter.screenId,
      ref,
    );
    ref.onDispose(licenseViewModel.disposed);
    return licenseViewModel;
  },
);

class LicenseViewModelParameter {
  LicenseViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

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
