import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/notifer/dynamic_links_notifer.dart';

class DynamicLinksWidget extends HookWidget {
  const DynamicLinksWidget({
    required this.child,
    required this.onCalled,
  });

  final Widget child;
  final Function({
    required String? apiKey,
    required String? mode,
    required String? oobCode,
    required String? continueUrl,
    required String? lang,
  }) onCalled;

  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      onChange: (context, DynamicLinksNotifer dynamicLinksNotifer) async {
        onCalled(
          apiKey: dynamicLinksNotifer.apiKey,
          mode: dynamicLinksNotifer.mode,
          oobCode: dynamicLinksNotifer.oobCode,
          continueUrl: dynamicLinksNotifer.continueUrl,
          lang: dynamicLinksNotifer.lang,
        );
      },
      provider: dynamicLinksNotiferProvider,
      child: child,
    );
  }
}
