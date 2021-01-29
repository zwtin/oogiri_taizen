import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
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

  bool isLoading = false;
}
