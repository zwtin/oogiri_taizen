import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/entity/current_user.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/model/repository/firestore_user_repository.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/tab_0_navigator_notifier.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view.dart';
import 'package:oogiritaizen/ui/topic_list/topic_list_view.dart';

final answerListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<AnswerListViewModel, String>(
  (ref, id) {
    return AnswerListViewModel(
      id,
      ref.watch(tab0NavigatorNotifierProvider),
      ref.watch(authenticationUseCaseProvider(id)),
      ref.watch(userUseCaseProvider(id)),
    );
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this.id,
    this.tab0navigatorNotifier,
    this.authenticationUseCase,
    this.userUseCase,
  ) {
    userUseCase.getLoginUserStream().listen(
      (UserEntity userEntity) {
        user = User()
          ..id = userEntity.id
          ..name = userEntity.name
          ..introduction = userEntity.introduction
          ..imageUrl = userEntity.imageUrl;
        notifyListeners();
      },
    );
  }

  final String id;
  final Tab0NavigatorNotifier tab0navigatorNotifier;
  final AuthenticationUseCase authenticationUseCase;
  final UserUseCase userUseCase;

  User user;

  void tapped() {
//    providerReference.read(alertNotifierProvider(id)).show(
//          title: 'エラー',
//          subtitle: '選択済みのタブです',
//          showCancelButton: false,
//          onPress: null,
//          style: null,
//        );
  }

  void transitionToPostTopic() {
    tab0navigatorNotifier.present(
      PostTopicView(user),
    );
  }

  void transitionToTopicList() {
    tab0navigatorNotifier.present(
      TopicListView(user),
    );
  }

  void disposed() {
    debugPrint('aaaaa');
  }
}
