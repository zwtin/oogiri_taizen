import 'dart:io';

import 'package:meta/meta.dart';

abstract class StorageRepository {
  Future<String> upload({
    @required String path,
    @required File file,
  });

  Future<void> delete({
    @required String url,
  });
}
