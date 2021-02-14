import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/topic_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';

final postTopicViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<PostTopicViewModel, String>(
  (ref, id) {
    return PostTopicViewModel(
      id,
      ref.watch(alertViewModelProvider(id)),
      ref.watch(navigatorViewModelProvider(id)),
      ref.watch(userUseCaseProvider(id)),
      ref.watch(topicUseCaseProvider(id)),
    );
  },
);

class PostTopicViewModel extends ChangeNotifier {
  PostTopicViewModel(
    this.id,
    this.alertViewModel,
    this.navigatorViewModel,
    this.userUseCase,
    this.topicUseCase,
  ) {
    setup();
  }

  final String id;
  final AlertViewModel alertViewModel;
  final NavigatorViewModel navigatorViewModel;
  final UserUseCase userUseCase;
  final TopicUseCase topicUseCase;

  bool isConnecting = false;
  File imageFile;
  UserEntity loginUser;
  TopicEntity editedTopic = TopicEntity();

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    notifyListeners();
  }

  Future<void> postTopic() async {
    if (editedTopic.text.isEmpty) {
      // お題本文入力チェック
      alertViewModel.show(
        alertEntity: AlertEntity()
          ..title = 'エラー'
          ..subtitle = 'テキストが未入力です'
          ..showCancelButton = false
          ..onPress = null
          ..style = null,
      );
      return;
    }
    try {
      isConnecting = true;
      notifyListeners();

      await topicUseCase.postTopic(
        imageFile: imageFile,
        editedTopic: editedTopic,
      );
      isConnecting = false;
      alertViewModel.show(
        alertEntity: AlertEntity()
          ..title = '投稿完了'
          ..subtitle = 'お題を投稿しました'
          ..showCancelButton = false
          ..onPress = ((bool b) {
            navigatorViewModel.pop();
            return b;
          })
          ..style = null,
      );
      notifyListeners();
    } on Exception catch (error) {
      isConnecting = false;
      alertViewModel.show(
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
}
