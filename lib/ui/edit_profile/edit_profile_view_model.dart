import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/model/repository/firestore_user_repository.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/navigator_notifier.dart';

final editProfileViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<EditProfileViewModel, String>(
  (ref, id) {
    return EditProfileViewModel(
      ref,
      id,
    );
  },
);

class EditProfileViewModel extends ChangeNotifier {
  EditProfileViewModel(
    this.providerReference,
    this.id,
  ) {
    setup();
  }

  final ProviderReference providerReference;
  final String id;

  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository =
      FirebaseAuthenticationRepository();
  final FirestoreUserRepository _firestoreUserRepository =
      FirestoreUserRepository();

  User user;

  bool isConnecting = false;

  Future<void> setup() async {
    try {
      isConnecting = true;
      notifyListeners();

      final currentUser = _firebaseAuthenticationRepository.getCurrentUser();
      if (currentUser != null) {
        user = await _firestoreUserRepository.getUser(userId: currentUser.id);
        isConnecting = false;
        notifyListeners();
      } else {
        user = null;
        isConnecting = false;
        notifyListeners();
      }
    } on Exception catch (error) {
      isConnecting = false;
      providerReference.read(alertNotifierProvider(id)).show(
            title: 'エラー',
            subtitle: 'ログイン情報の取得に失敗しました',
            showCancelButton: false,
            onPress: (bool b) {
              providerReference.read(navigatorNotifierProvider(id)).pop();
              return b;
            },
            style: null,
          );
      notifyListeners();
    }
  }

  Future<void> postUser() async {
    if (user.name.isEmpty) {
      // ユーザー名入力チェック
      providerReference.read(alertNotifierProvider(id)).show(
            title: 'エラー',
            subtitle: '名前が未入力です',
            showCancelButton: false,
            onPress: null,
            style: null,
          );
      notifyListeners();
      return;
    }
    if (user.introduction.isEmpty) {
      // 自己紹介入力チェック
      providerReference.read(alertNotifierProvider(id)).show(
            title: 'エラー',
            subtitle: '自己紹介が未入力です',
            showCancelButton: false,
            onPress: null,
            style: null,
          );
      notifyListeners();
      return;
    }
    try {
      isConnecting = true;
      notifyListeners();
      await _firestoreUserRepository.updateUser(
        userId: user.id,
        user: user,
      );
      isConnecting = false;
      providerReference.read(alertNotifierProvider(id)).show(
            title: '投稿完了',
            subtitle: 'プロフィールを更新しました',
            showCancelButton: false,
            onPress: (bool b) {
              providerReference.read(navigatorNotifierProvider(id)).pop();
              return b;
            },
            style: null,
          );
      notifyListeners();
    } on Exception catch (error) {
      isConnecting = false;
      providerReference.read(alertNotifierProvider(id)).show(
            title: 'エラー',
            subtitle: '通信エラーが発生しました',
            showCancelButton: false,
            onPress: null,
            style: null,
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

    if (croppedFile != null) {}
  }
}
