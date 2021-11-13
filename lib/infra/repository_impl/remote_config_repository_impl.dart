import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/remote_config_repository.dart';
import 'package:oogiri_taizen/domain/repository/storage_repository.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';

final remoteConfigRepositoryProvider =
    Provider.autoDispose<RemoteConfigRepository>(
  (ref) {
    final remoteConfigRepository = RemoteConfigRepositoryImpl();
    ref.onDispose(remoteConfigRepository.disposed);
    return remoteConfigRepository;
  },
);

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  final _remoteConfig = RemoteConfig.instance;

  @override
  String getForceUpdateAppVersion() {
    return _remoteConfig.getString('force_update_app_version');
  }

  @override
  String getTermsOfService() {
    return _remoteConfig.getString('terms_of_service');
  }

  Future<void> disposed() async {
    debugPrint('RemoteConfigRepositoryImpl disposed');
  }
}
