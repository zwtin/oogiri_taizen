import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/model/repository/dynamic_links_repository.dart';

final dynamicLinksRepositoryProvider = Provider<DynamicLinksRepository>(
  (ref) {
    return DynamicLinksRepositoryImpl();
  },
);

class DynamicLinksRepositoryImpl implements DynamicLinksRepository {
  final _firebaseDynamicLinks = FirebaseDynamicLinks.instance;

  final StreamController<Uri> streamController = StreamController<Uri>();

  @override
  Future<void> setupDynamicLinks() async {
    _firebaseDynamicLinks.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final deepLink = dynamicLink?.link;

      if (deepLink != null) {
        streamController.sink.add(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    debugPrint('FirebaseDynamicLinks open');
    if (deepLink != null) {
      debugPrint('FirebaseDynamicLinks $deepLink');
    }
  }

  @override
  Stream<Uri> getDynamicLinksStream() {
    return streamController.stream;
  }

  Future<void> disposed() async {
    await streamController.close();
  }
}
