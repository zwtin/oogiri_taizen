import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/block_user_list_card_view_data.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/view_data/block_user_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/block_user_list_use_case.dart';

final blockUserListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<BlockUserListViewModel, UniqueKey>(
  (ref, key) {
    return BlockUserListViewModel(
      key,
      ref.read,
      ref.watch(blockUserListUseCaseProvider(key)),
    );
  },
);

class BlockUserListViewModel extends ChangeNotifier {
  BlockUserListViewModel(
    this._key,
    this._reader,
    this._blockUserListUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final BlockUserListUseCase _blockUserListUseCase;

  List<BlockUserListCardViewData> get answerViewData {
    return mappingForBlockUserListCardViewData(
      users: _blockUserListUseCase.loadedUsers,
    );
  }

  bool get hasNext {
    return _blockUserListUseCase.hasNext;
  }

  Future<void> resetUsers() async {
    final result = await _blockUserListUseCase.resetBlockUsers();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> fetchUsers() async {
    final result = await _blockUserListUseCase.fetchBlockUsers();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BlockUserListViewModel dispose $_key');
  }
}
