import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/model/repository/firebase_storage_repository.dart';
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
  );

  final ProviderReference providerReference;
  final String id;

  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository =
      FirebaseAuthenticationRepository();
  final FirestoreUserRepository _firestoreUserRepository =
      FirestoreUserRepository();
  final FirebaseStorageRepository _firebaseStorageRepository =
      FirebaseStorageRepository();

  User originalUser;
  String editedName;
  String editedIntroduction;
  File imageFile;

  bool isConnecting = false;

  Future<void> postUser() async {
    if (editedName.isEmpty) {
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
    if (editedIntroduction.isEmpty) {
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
      var uploadedUrl = '';
      if (imageFile != null) {
        uploadedUrl = await _firebaseStorageRepository.upload(imageFile);
      }
      await _firestoreUserRepository.updateUser(
        userId: originalUser.id,
        user: User()
          ..name = originalUser.name == editedName ? null : editedName
          ..introduction = originalUser.introduction == editedIntroduction
              ? null
              : editedIntroduction
          ..imageUrl = uploadedUrl.isEmpty ? null : uploadedUrl,
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

    if (croppedFile != null) {
      imageFile = croppedFile;
      notifyListeners();
    }
  }
}
