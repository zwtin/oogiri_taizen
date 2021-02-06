import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/entity/topic.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/parameters/get_new_topic_list_parameter.dart';
import 'package:oogiritaizen/data/model/repository/firestore_topic_repository.dart';
import 'package:oogiritaizen/data/model/repository/firestore_user_repository.dart';
import 'package:oogiritaizen/data/model/use_case/topic_list_item.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/navigator_notifier.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view.dart';

final topicListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<TopicListViewModel, String>(
  (ref, id) {
    return TopicListViewModel(
      ref,
      id,
    );
  },
);

class TopicListViewModel extends ChangeNotifier {
  TopicListViewModel(
    this.providerReference,
    this.id,
  ) {
    refreshNewTopicList();
  }

  final ProviderReference providerReference;
  final String id;

  final FirestoreTopicRepository _firestoreTopicRepository =
      FirestoreTopicRepository();
  final FirestoreUserRepository _firestoreUserRepository =
      FirestoreUserRepository();

  bool isConnecting = false;

  User user;

  List<TopicListItem> items = [];
  bool hasNext = false;

  Future<void> refreshNewTopicList() async {
    if (isConnecting) {
      return;
    }
    isConnecting = true;
    final getNewTopicListParameter = GetNewTopicListParameter();
    try {
      final response = await _firestoreTopicRepository.getNewTopicList(
        parameter: getNewTopicListParameter,
      );
      items = [];
      for (final topic in response.topics) {
        final createdUser = await _firestoreUserRepository.getUser(
          userId: topic.createdUser,
        );
        final topicListItem = TopicListItem()
          ..topicId = topic.id
          ..topicText = topic.text
          ..topicImageUrl = topic.imageUrl
          ..topicAnsweredTime = topic.answeredTime
          ..topicCreatedAt = topic.createdAt
          ..createdUserId = createdUser.id
          ..createdUserImageUrl = createdUser.imageUrl
          ..createdUserName = createdUser.name
          ..createdUserIntroduction = createdUser.introduction;
        items.add(topicListItem);
      }
      hasNext = response.hasNext;
      isConnecting = false;
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

  Future<void> getNewTopicList() async {
    if (isConnecting) {
      return;
    }
    isConnecting = true;
    final getNewTopicListParameter = GetNewTopicListParameter();
    final lastTopic = Topic()
      ..id = items.last.topicId
      ..text = items.last.topicText
      ..imageUrl = items.last.topicImageUrl
      ..answeredTime = items.last.topicAnsweredTime
      ..createdAt = items.last.topicCreatedAt
      ..createdUser = items.last.createdUserId;
    getNewTopicListParameter.topic = lastTopic;

    try {
      final response = await _firestoreTopicRepository.getNewTopicList(
        parameter: getNewTopicListParameter,
      );
      for (final topic in response.topics) {
        final createdUser = await _firestoreUserRepository.getUser(
          userId: topic.createdUser,
        );
        final topicListItem = TopicListItem()
          ..topicId = topic.id
          ..topicText = topic.text
          ..topicImageUrl = topic.imageUrl
          ..topicAnsweredTime = topic.answeredTime
          ..topicCreatedAt = topic.createdAt
          ..createdUserId = createdUser.id
          ..createdUserImageUrl = createdUser.imageUrl
          ..createdUserName = createdUser.name
          ..createdUserIntroduction = createdUser.introduction;
        items.add(topicListItem);
      }
      hasNext = response.hasNext;
      isConnecting = false;
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

  void transitionToPostAnswer(TopicListItem topicListItem) {
    providerReference.read(navigatorNotifierProvider(id)).present(
          PostAnswerView(user, Topic()),
        );
  }
}
