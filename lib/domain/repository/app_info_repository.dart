import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class AppInfoRepository {
  Future<Result<String>> getVersion();
}
