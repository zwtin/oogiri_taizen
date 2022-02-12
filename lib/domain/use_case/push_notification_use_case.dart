import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class PushNotificationUseCase {
  Future<Result<void>> requestPermission();
}