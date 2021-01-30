import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oogiritaizen/data/model/entity/topic.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/repository/firebase_storage_repository.dart';
import 'package:oogiritaizen/data/model/repository/firestore_topic_repository.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/navigator_notifier.dart';

final postTopicViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<PostTopicViewModel, String>(
  (ref, id) {
    return PostTopicViewModel(
      ref,
      id,
    );
  },
);

class PostTopicViewModel extends ChangeNotifier {
  PostTopicViewModel(
    this.providerReference,
    this.id,
  );

  final ProviderReference providerReference;
  final String id;

  final FirebaseStorageRepository _firebaseStorageRepository =
      FirebaseStorageRepository();
  final FirestoreTopicRepository _firestoreTopicRepository =
      FirestoreTopicRepository();

  bool isConnecting = false;
  File imageFile;

  User user;
  Topic topic = Topic();

  Future<void> postTopic() async {
    if (topic.text.isEmpty) {
      // ユーザー名入力チェック
      providerReference.read(alertNotifierProvider(id)).show(
            title: 'エラー',
            subtitle: 'テキストが未入力です',
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
      if (imageFile != null) {
        topic.imageUrl = await _firebaseStorageRepository.upload(
          path: 'images/topics',
          file: imageFile,
        );
      }
      await _firestoreTopicRepository.postTopic(
        user: user,
        topic: topic,
      );

      isConnecting = false;
      providerReference.read(alertNotifierProvider(id)).show(
            title: '投稿完了',
            subtitle: 'お題を投稿しました',
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
