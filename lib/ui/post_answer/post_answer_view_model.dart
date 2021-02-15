import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postAnswerViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<PostAnswerViewModel, String>(
  (ref, id) {
    final postAnswerViewModel = PostAnswerViewModel(
      ref,
      id,
    );
    ref.onDispose(postAnswerViewModel.disposed);
    return postAnswerViewModel;
  },
);

class PostAnswerViewModel extends ChangeNotifier {
  PostAnswerViewModel(
    this.providerReference,
    this.id,
  );

  final ProviderReference providerReference;
  final String id;

  bool isLoading = false;

  Future<void> disposed() async {
    debugPrint(id);
  }
}
