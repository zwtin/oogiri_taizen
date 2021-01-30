import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:oogiritaizen/data/model/extension/string_extension.dart';

class FirebaseStorageRepository {
  FirebaseStorageRepository({FirebaseStorage storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> upload({String path, File file}) async {
    final imageName = StringExtension.randomString(16);
    final imagePath = '$path/$imageName';

    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minHeight: 500,
      minWidth: 500,
      quality: 85,
    );

    final ref = _storage.ref().child(imagePath);

    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final uploadTask = ref.putData(result, metaData);
    await Future.value(uploadTask);
    final url = (await ref.getDownloadURL()).toString();
    return url;
  }
}
