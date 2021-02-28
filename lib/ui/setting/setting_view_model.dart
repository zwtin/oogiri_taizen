import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';

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

  Future<void> postSetting() async {}

  Future<void> disposed() async {
    debugPrint(id);
  }
}
