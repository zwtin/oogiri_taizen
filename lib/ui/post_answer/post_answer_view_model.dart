import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final postAnswerViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<PostAnswerViewModel, String>(
  (ref, id) {
    final postAnswerViewModel = PostAnswerViewModel(
      id,
      ref,
    );
    ref.onDispose(postAnswerViewModel.disposed);
    return postAnswerViewModel;
  },
);

class PostAnswerViewModel extends ChangeNotifier {
  PostAnswerViewModel(
    this.id,
    this.providerReference,
  );

  final String id;
  final ProviderReference providerReference;

  bool isLoading = false;

  Future<void> disposed() async {
    debugPrint(id);
  }
}
