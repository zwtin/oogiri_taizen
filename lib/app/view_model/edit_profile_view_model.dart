import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/edit_profile_use_case.dart';

final editProfileViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<EditProfileViewModel, UniqueKey>(
  (ref, key) {
    return EditProfileViewModel(
      key,
      ref.read,
      ref.watch(editProfileUseCaseProvider(key)),
    );
  },
);

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel(
    this._key,
    this._reader,
    this._editProfileUseCase,
  ) {
    final loginUser = _editProfileUseCase.loginUser;
    if (loginUser != null && loginUser.user == null) {
      editedName = loginUser.user!.name;
      editedIntroduction = loginUser.user!.introduction;
      loginUserImageUrl = loginUser.user!.imageUrl;
      notifyListeners();
    } else {
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
    }
  }

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final EditProfileUseCase _editProfileUseCase;

  bool isConnecting = false;
  String editedName = '';
  String editedIntroduction = '';
  String? loginUserImageUrl;
  File? imageFile;

  Future<void> getImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: '画像を取得できませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
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
        lockAspectRatio: false,
      ),
      iosUiSettings: const IOSUiSettings(),
    );
    if (croppedFile == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: '画像を取得できませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
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
    final result = await _editProfileUseCase.updateUser(
      newName: editedName,
      newIntroduction: editedIntroduction,
      newImageFile: imageFile,
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
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
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

  @override
  void dispose() {
    super.dispose();
    _logger.d('EditProfileViewModel dispose $_key');
  }
}
