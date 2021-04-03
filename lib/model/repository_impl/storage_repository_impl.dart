import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/extension/string_extension.dart';
import 'package:oogiritaizen/model/repository/storage_repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>(
  (ref) {
    return StorageRepositoryImpl();
  },
);

class StorageRepositoryImpl implements StorageRepository {
  final _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String> upload({
    @required String path,
    @required File file,
  }) async {
    final imageName = StringExtension.randomString(16);
    final imagePath = '$path/$imageName';

    try {
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minHeight: 500,
        minWidth: 500,
        quality: 85,
      );

      final ref = _firebaseStorage.ref().child(imagePath);

      final metaData = SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = ref.putData(result, metaData);
      await Future.value(uploadTask);
      final url = await ref.getDownloadURL();
      return url;
    } on Exception catch (error) {}
  }

  @override
  Future<void> delete({
    @required String url,
  }) async {
    try {
      final ref = _firebaseStorage.refFromURL(url);
      await ref.delete();
    } on Exception catch (error) {}
  }
}
