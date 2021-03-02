import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/terms_of_service/terms_of_service_view.dart';
import 'package:oogiritaizen/ui/privacy_policy/privacy_policy_view.dart';
import 'package:oogiritaizen/ui/license/license_view.dart';

final settingViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<SettingViewModel, String>(
  (ref, id) {
    final settingViewModel = SettingViewModel(
      id,
      ref,
      ref.watch(userUseCaseProvider(id)),
    );
    ref.onDispose(settingViewModel.disposed);
    return settingViewModel;
  },
);

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(
    this.id,
    this.providerReference,
    this.userUseCase,
  ) {
    setup();
  }

  final String id;
  final ProviderReference providerReference;
  final UserUseCase userUseCase;

  bool isConnecting = false;
  UserEntity loginUser;

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    notifyListeners();
  }

  void transitionToTermsOfService() {
    providerReference.read(navigatorViewModelProvider(id)).present(
          TermsOfServiceView(),
        );
  }

  void transitionToPrivacyPolicy() {
    providerReference.read(navigatorViewModelProvider(id)).present(
          PrivacyPolicyView(),
        );
  }

  void transitionToLicense() {
    providerReference.read(navigatorViewModelProvider(id)).present(
          LicenseView(),
        );
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}
