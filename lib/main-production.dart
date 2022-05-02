import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/infra/repository_impl/streaming_shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'app.dart';
import 'flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final streamSharedPreference = await StreamingSharedPreferences.instance;

  final packageInfo = await PackageInfo.fromPlatform();

  final remoteConfig = RemoteConfig.instance;
  await remoteConfig.fetchAndActivate();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runZonedGuarded(
    () {
      F.appFlavor = Flavor.PRODUCTION;
      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(
              streamSharedPreference,
            ),
            packageInfoProvider.overrideWithValue(
              packageInfo,
            ),
          ],
          child: App(),
        ),
      );
    },
    FirebaseCrashlytics.instance.recordError,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Logger().d('Handling a background message: ${message.messageId}');
}
