import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/image_detail/fade_in_route.dart';
import 'package:oogiritaizen/ui/license/license_view_model.dart';
import 'package:oogiritaizen/ui/privacy_policy/privacy_policy_view_model.dart';
import 'package:oogiritaizen/ui/terms_of_service/terms_of_service_view_model.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

class LicenseView extends HookWidget {
  const LicenseView(this.parameter);

  final LicenseViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(licenseViewModelProvider(parameter));

    return ProviderListener(
      onChange: (BuildContext context, AlertViewModel alertViewModel) {
        SweetAlert.show(
          context,
          title: alertViewModel.alertEntity.title,
          subtitle: alertViewModel.alertEntity.subtitle,
          showCancelButton: alertViewModel.alertEntity.showCancelButton,
          onPress: alertViewModel.alertEntity.onPress,
          style: alertViewModel.alertEntity.style,
        );
      },
      provider: alertViewModelProvider(parameter.screenId),
      child: ProviderListener(
        onChange:
            (BuildContext context, NavigatorViewModel navigatorViewModel) {
          switch (navigatorViewModel.transitionType) {
            case TransitionType.push:
              Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) {
                    return navigatorViewModel.nextWidget;
                  },
                ),
              );
              break;
            case TransitionType.present:
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) {
                    return navigatorViewModel.nextWidget;
                  },
                  fullscreenDialog: true,
                ),
              );
              break;
            case TransitionType.image:
              Navigator.of(context, rootNavigator: true).push(
                FadeInRoute(
                  widget: navigatorViewModel.nextWidget,
                  opaque: false,
                ),
              );
              break;
            case TransitionType.pop:
              Navigator.of(context).pop();
              break;
            case TransitionType.popToRoot:
              Navigator.of(context).popUntil((route) => route.isFirst);
              break;
          }
        },
        provider: navigatorViewModelProvider(parameter.screenId),
        child: Scaffold(
          // ナビゲーションバー
          appBar: AppBar(
            title: const Text(
              'ライセンス',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFFCC00),
            elevation: 0, // 影をなくす
            bottom: PreferredSize(
              child: Container(
                color: Colors.white24,
                height: 1,
              ),
              preferredSize: const Size.fromHeight(1),
            ),
          ),
          body: Stack(
            children: [
              Container(
                color: const Color(0xFFFFCC00),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('aaa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
