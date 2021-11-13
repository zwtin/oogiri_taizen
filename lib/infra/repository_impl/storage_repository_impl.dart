import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/storage_repository.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';

final storageRepositoryProvider = Provider.autoDispose<StorageRepository>(
  (ref) {
    final storageRepository = StorageRepositoryImpl();
    ref.onDispose(storageRepository.disposed);
    return storageRepository;
  },
);

class StorageRepositoryImpl implements StorageRepository {
  final _storage = FirebaseStorage.instance;

  @override
  Future<Result<String>> uploadUserImage({
    required File file,
  }) async {
    return _upload(
      path: 'images/users',
      file: file,
    );
  }

  Future<Result<String>> _upload({
    required String path,
    required File file,
  }) async {
    try {
      final imageName = StringExtension.randomString(8);
      final imagePath = '$path/$imageName';

      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        minHeight: 500,
        minWidth: 500,
        quality: 85,
      );
      if (result == null) {
        throw OTException();
      }
      final ref = _storage.ref().child(imagePath);

      final metaData = SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = ref.putData(result, metaData);
      await Future.value(uploadTask);
      final url = await ref.getDownloadURL();
      return Result.success(url);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> delete({
    required String url,
  }) async {
    try {
      final ref = _storage.refFromURL(url);
      await ref.delete();
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  Future<void> disposed() async {
    debugPrint('StorageRepositoryImpl disposed');
  }
}
