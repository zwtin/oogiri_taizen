import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/entity/current_user.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/model/repository/firestore_user_repository.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/tab_0_navigator_notifier.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view.dart';
import 'package:oogiritaizen/ui/topic_list/topic_list_view.dart';

final answerListViewModelProvider =
    ChangeNotifierProvider.family<AnswerListViewModel, String>(
  (ref, id) {
    return AnswerListViewModel(
      ref,
      id,
    );
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this.providerReference,
    this.id,
  ) {
    _firebaseAuthenticationRepository.getCurrentUserStream().listen(
      (CurrentUser currentUser) {
        if (currentUser == null) {
          user = null;
          notifyListeners();
        } else {
          _firestoreUserRepository.getUserStream(userId: currentUser.id).listen(
            (User _user) {
              user = _user;
              notifyListeners();
            },
          );
        }
      },
    );
  }

  final ProviderReference providerReference;
  final String id;

  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository =
      FirebaseAuthenticationRepository();
  final FirestoreUserRepository _firestoreUserRepository =
      FirestoreUserRepository();

  User user;

  double getRadiansFromDegree(double degree) {
    const unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  void tapped() {
    providerReference.read(alertNotifierProvider(id)).show(
          title: 'エラー',
          subtitle: '選択済みのタブです',
          showCancelButton: false,
          onPress: null,
          style: null,
        );
  }

  void transitionToPostTopic() {
    providerReference.read(tab0NavigatorNotifierProvider).present(
          PostTopicView(user),
        );
  }

  void transitionToTopicList() {
    providerReference.read(tab0NavigatorNotifierProvider).present(
          TopicListView(user),
        );
  }
}
