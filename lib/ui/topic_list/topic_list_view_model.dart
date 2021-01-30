import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/navigator_notifier.dart';

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
  );

  final ProviderReference providerReference;
  final String id;

  bool isLoading = false;
}
