import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:oogiritaizen/data/model/extension/string_extension.dart';

class FirebaseStorageRepository {
  FirebaseStorageRepository({FirebaseStorage storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> upload(File imageFile) async {
    final imageName = StringExtension.randomString(16);

    final result = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minHeight: 500,
      minWidth: 500,
      quality: 85,
    );

    final ref = _storage.ref().child('images/users/$imageName');

    final metaData = SettableMetadata(contentType: 'image/jpeg');
    final uploadTask = ref.putData(result, metaData);
    await Future.value(uploadTask);
    final url = (await ref.getDownloadURL()).toString();
    return url;
  }
}
