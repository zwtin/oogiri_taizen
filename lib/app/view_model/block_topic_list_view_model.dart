import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/block_topic_list_card_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view_data/block_topic_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/block_topic_list_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';

final blockTopicListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<BlockTopicListViewModel, UniqueKey>(
  (ref, key) {
    return BlockTopicListViewModel(
      key,
      ref.read,
      ref.watch(blockTopicListUseCaseProvider(key)),
      ref.watch(blockUseCaseProvider(key)),
    );
  },
);

class BlockTopicListViewModel extends ChangeNotifier {
  BlockTopicListViewModel(
    this._key,
    this._reader,
    this._blockTopicListUseCase,
    this._blockUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final BlockTopicListUseCase _blockTopicListUseCase;
  final BlockUseCase _blockUseCase;

  List<BlockTopicListCardViewData> get answerViewData {
    return mappingForBlockTopicListCardViewData(
      topics: _blockTopicListUseCase.loadedTopics,
    );
  }

  bool get hasNext {
    return _blockTopicListUseCase.hasNext;
  }

  Future<void> resetTopics() async {
    final result = await _blockTopicListUseCase.resetBlockTopics();
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

  Future<void> fetchTopics() async {
    final result = await _blockTopicListUseCase.fetchBlockTopics();
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

  Future<void> removeBlockTopic({required String topicId}) async {
    final topic = _blockTopicListUseCase.loadedTopics.getById(topicId);
    if (topic == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'お題が見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _blockUseCase.removeTopic(topic: topic);
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

  Future<void> transitionToImageDetail({
    required String imageUrl,
    required String imageTag,
  }) async {
    if (imageUrl.isEmpty) {
      return;
    }
    await _reader.call(routerNotiferProvider(_key)).presentImage(
          imageUrl: imageUrl,
          imageTag: imageTag,
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('BlockTopicListViewModel dispose $_key');
  }
}
