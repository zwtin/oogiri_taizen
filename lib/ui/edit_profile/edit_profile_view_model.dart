import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final editProfileViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<EditProfileViewModel, EditProfileViewModelParameter>(
  (ref, parameter) {
    final editProfileViewModel = EditProfileViewModel(
      ref,
      parameter.screenId,
      ref.watch(userUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(editProfileViewModel.disposed);
    return editProfileViewModel;
  },
);

class EditProfileViewModelParameter {
  EditProfileViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel(
    this.providerReference,
    this.screenId,
    this.userUseCase,
  ) {
    setup();
  }

  final String screenId;
  final ProviderReference providerReference;
  final UserUseCase userUseCase;

  UserEntity editedUser;
  File imageFile;
  bool isConnecting = false;

  Future<void> setup() async {
    editedUser = await userUseCase.getLoginUser();
    notifyListeners();
  }

  Future<void> postUser() async {
    if (editedUser.name.isEmpty) {
      // ユーザー名入力チェック
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '名前が未入力です'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      return;
    }
    if (editedUser.introduction.isEmpty) {
      // 自己紹介入力チェック
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '自己紹介が未入力です'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      return;
    }
    try {
      isConnecting = true;
      notifyListeners();
      await userUseCase.updateUser(
        imageFile: imageFile,
        editedUser: editedUser,
      );
      isConnecting = false;
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = '投稿完了'
              ..subtitle = 'プロフィールを更新しました'
              ..showCancelButton = false
              ..onPress = ((bool b) {
                providerReference
                    .read(navigatorViewModelProvider(screenId))
                    .pop();
                return b;
              })
              ..style = null,
          );
      notifyListeners();
    } on Exception catch (error) {
      isConnecting = false;
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '通信エラーが発生しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      notifyListeners();
    }
  }

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    final croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: const AndroidUiSettings(
            toolbarColor: Color(0xFFFFCC00),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings());

    if (croppedFile != null) {
      imageFile = croppedFile;
      notifyListeners();
    }
  }

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}
