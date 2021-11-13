import 'dart:io';

import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class StorageRepository {
  Future<Result<String>> uploadUserImage({
    required File file,
  });
  Future<Result<void>> delete({
    required String url,
  });
}
