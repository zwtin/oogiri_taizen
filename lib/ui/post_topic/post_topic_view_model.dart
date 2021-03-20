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

final postTopicViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<PostTopicViewModel, PostTopicViewModelParameter>(
  (ref, parameter) {
    final postTopicViewModel = PostTopicViewModel(
      parameter.screenId,
      ref,
      ref.watch(userUseCaseProvider(parameter.screenId)),
      ref.watch(topicUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(postTopicViewModel.disposed);
    return postTopicViewModel;
  },
);

class PostTopicViewModelParameter {
  PostTopicViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class PostTopicViewModel extends ChangeNotifier {
  PostTopicViewModel(
    this.id,
    this.providerReference,
    this.userUseCase,
    this.topicUseCase,
  ) {
    setup();
  }

  final String id;
  final ProviderReference providerReference;
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
      providerReference.read(alertViewModelProvider(id)).show(
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
      providerReference.read(alertViewModelProvider(id)).show(
            alertEntity: AlertEntity()
              ..title = '投稿完了'
              ..subtitle = 'お題を投稿しました'
              ..showCancelButton = false
              ..onPress = ((bool b) {
                providerReference.read(navigatorViewModelProvider(id)).pop();
                return b;
              })
              ..style = null,
          );
      notifyListeners();
    } on Exception catch (error) {
      isConnecting = false;
      providerReference.read(alertViewModelProvider(id)).show(
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
    debugPrint(id);
  }
}
