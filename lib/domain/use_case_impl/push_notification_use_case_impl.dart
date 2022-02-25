import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/push_notification_repository.dart';
import 'package:oogiri_taizen/domain/use_case/push_notification_use_case.dart';
import 'package:oogiri_taizen/infra/repository_impl/push_notification_repository_impl.dart';

final pushNotificationUseCaseProvider =
    Provider.autoDispose<PushNotificationUseCase>(
  (ref) {
    final pushNotificationUseCase = PushNotificationUseCaseImpl(
      ref.watch(pushNotificationRepositoryProvider),
    );
    ref.onDispose(pushNotificationUseCase.disposed);
    return pushNotificationUseCase;
  },
);

class PushNotificationUseCaseImpl implements PushNotificationUseCase {
  PushNotificationUseCaseImpl(
    this._pushNotificationRepository,
  );

  final PushNotificationRepository _pushNotificationRepository;

  @override
  Future<Result<void>> requestPermission() async {
    final result = await _pushNotificationRepository.requestPermission();
    if (result is Failure) {
      return Result.failure(
        OTException(alertMessage: 'プッシュ通知の許可ダイアログを出せませんでした'),
      );
    }
    return const Result.success(null);
  }

  Future<void> disposed() async {
    debugPrint('PushNotificationUseCaseImpl disposed');
  }
}
