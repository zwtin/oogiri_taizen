import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dynamicLinksNotiferProvider =
    ChangeNotifierProvider.autoDispose<DynamicLinksNotifer>(
  (ref) {
    return DynamicLinksNotifer();
  },
);

class DynamicLinksNotifer extends ChangeNotifier {
  DynamicLinksNotifer() {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (dynamicLink) async {
        if (dynamicLink == null) {
          return;
        }
        final queryParameters = dynamicLink.link.queryParameters;
        apiKey = queryParameters['apiKey'];
        mode = queryParameters['mode'];
        oobCode = queryParameters['oobCode'];
        continueUrl = queryParameters['continueUrl'];
        lang = queryParameters['lang'];

        notifyListeners();
      },
    );
    FirebaseDynamicLinks.instance.getInitialLink();
  }

  String? apiKey;
  String? mode;
  String? oobCode;
  String? continueUrl;
  String? lang;
}
