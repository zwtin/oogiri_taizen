import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/license/license_view_model.dart';
import 'package:oogiritaizen/ui/privacy_policy/privacy_policy_view_model.dart';
import 'package:oogiritaizen/ui/terms_of_service/terms_of_service_view.dart';
import 'package:oogiritaizen/ui/privacy_policy/privacy_policy_view.dart';
import 'package:oogiritaizen/ui/license/license_view.dart';
import 'package:oogiritaizen/ui/terms_of_service/terms_of_service_view_model.dart';

final settingViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<SettingViewModel, SettingViewModelParameter>(
  (ref, parameter) {
    final settingViewModel = SettingViewModel(
      ref,
      parameter.screenId,
      ref.watch(userUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(settingViewModel.disposed);
    return settingViewModel;
  },
);

class SettingViewModelParameter {
  SettingViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class SettingViewModel extends ChangeNotifier {
  SettingViewModel(
    this.providerReference,
    this.screenId,
    this.userUseCase,
  ) {
    setup();
  }

  final String screenId;
  final ProviderReference providerReference;
  final UserUseCase userUseCase;

  bool isConnecting = false;
  UserEntity loginUser;

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    notifyListeners();
  }

  void transitionToTermsOfService() {
    final parameter = TermsOfServiceViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider(screenId)).present(
          TermsOfServiceView(parameter),
        );
  }

  void transitionToPrivacyPolicy() {
    final parameter = PrivacyPolicyViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider(screenId)).present(
          PrivacyPolicyView(parameter),
        );
  }

  void transitionToLicense() {
    final parameter = LicenseViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider(screenId)).present(
          LicenseView(parameter),
        );
  }

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}
