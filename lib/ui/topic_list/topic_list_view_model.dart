import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/entity/topic.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/parameters/get_new_topic_list_parameter.dart';
import 'package:oogiritaizen/data/model/repository/firestore_topic_repository.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';

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

  bool isConnecting = false;

  User user;

  List<Topic> items = [];
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
      items = response.topics;
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
    final getNewTopicListParameter = GetNewTopicListParameter()
      ..topic = items.last;
    try {
      final response = await _firestoreTopicRepository.getNewTopicList(
          parameter: getNewTopicListParameter);
      items.addAll(response.topics);
      hasNext = response.hasNext;
      notifyListeners();
    } on Exception catch (error) {}
  }
}
