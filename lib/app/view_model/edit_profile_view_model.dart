import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case_impl.dart';

final editProfileViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<EditProfileViewModel, UniqueKey>(
  (ref, key) {
    final editProfileViewModel = EditProfileViewModel(
      key,
      ref.read,
      ref.watch(authenticationUseCaseProvider),
    );
    ref.onDispose(editProfileViewModel.disposed);
    return editProfileViewModel;
  },
);

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel(
    this._key,
    this._reader,
    this._authenticationUseCase,
  ) {
    loginUserSubscription?.cancel();
    loginUserSubscription = _authenticationUseCase.getLoginUserStream().listen(
      (user) {
        if (user == null) {
          _reader.call(alertNotiferProvider).show(
                title: 'エラー',
                message: 'ログインしてください',
                okButtonTitle: 'OK',
                cancelButtonTitle: null,
                okButtonAction: () {
                  _reader.call(alertNotiferProvider).dismiss();
                  _reader.call(routerNotiferProvider(_key)).pop();
                },
                cancelButtonAction: null,
              );
        } else {
          editedName = user.name;
          editedIntroduction = user.introduction;
          loginUserImageUrl = user.imageUrl;
          notifyListeners();
        }
      },
    );
    final user = _authenticationUseCase.getLoginUser();
    if (user == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ログインしてください',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
              _reader.call(routerNotiferProvider(_key)).pop();
            },
            cancelButtonAction: null,
          );
    } else {
      editedName = user.name;
      editedIntroduction = user.introduction;
      loginUserImageUrl = user.imageUrl;
      notifyListeners();
    }
  }

  final UniqueKey _key;
  final Reader _reader;

  final AuthenticationUseCase _authenticationUseCase;

  bool isConnecting = false;
  StreamSubscription<LoginUser?>? loginUserSubscription;

  String editedName = '';
  String editedIntroduction = '';
  String? loginUserImageUrl;
  File? imageFile;

  Future<void> getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
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
      iosUiSettings: const IOSUiSettings(),
    );
    if (croppedFile == null) {
      return;
    }

    imageFile = croppedFile;
    notifyListeners();
  }

  Future<void> updateProfile() async {
    if (editedName.length > 10) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ユーザー名は最大10文字です',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    if (editedIntroduction.length > 100) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: '自己紹介文は最大100文字です',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    isConnecting = true;
    notifyListeners();
    final result = await _authenticationUseCase.updateUser(
      name: editedName,
      introduction: editedIntroduction,
      imageFile: imageFile,
    );
    result.when(
      success: (_) {
        isConnecting = false;
        notifyListeners();
        _reader.call(alertNotiferProvider).show(
              title: '完了',
              message: 'プロフィールを更新しました',
              okButtonTitle: 'OK',
              cancelButtonTitle: null,
              okButtonAction: () {
                _reader.call(alertNotiferProvider).dismiss();
                _reader.call(routerNotiferProvider(_key)).pop();
              },
              cancelButtonAction: null,
            );
      },
      failure: (exception) {
        isConnecting = false;
        notifyListeners();
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> disposed() async {
    await loginUserSubscription?.cancel();
    debugPrint('EditProfileViewModel disposed $_key');
  }
}
