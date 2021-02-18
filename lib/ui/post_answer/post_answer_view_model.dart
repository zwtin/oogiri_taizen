import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/topic_use_case_impl.dart';

final postAnswerViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<PostAnswerViewModel, String>(
  (ref, id) {
    final postAnswerViewModel = PostAnswerViewModel(
      id,
      ref,
      ref.watch(topicUseCaseProvider(id)),
    );
    ref.onDispose(postAnswerViewModel.disposed);
    return postAnswerViewModel;
  },
);

class PostAnswerViewModel extends ChangeNotifier {
  PostAnswerViewModel(
    this.id,
    this.providerReference,
    this.topicUseCase,
  );

  final String id;
  final ProviderReference providerReference;
  final TopicUseCase topicUseCase;

  bool isLoading = false;

  Future<void> disposed() async {
    debugPrint(id);
  }
}
