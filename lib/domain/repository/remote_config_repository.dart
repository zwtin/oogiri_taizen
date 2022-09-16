import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class RemoteConfigRepository {
  Future<Result<String>> getForceUpdateAppVersion();
  Future<Result<String>> getTermsOfService();
}
