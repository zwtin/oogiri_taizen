import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/image_detail/fade_in_route.dart';
import 'package:oogiritaizen/ui/setting/setting_view_model.dart';
import 'package:sweetalert/sweetalert.dart';

class SettingView extends HookWidget {
  const SettingView(this.parameter);

  final SettingViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(settingViewModelProvider(parameter));

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
        child: LoadingOverlay(
          isLoading: viewModel.isConnecting,
          color: Colors.grey,
          child: Scaffold(
            // ???????????????????????????
            appBar: AppBar(
              title: const Text(
                '??????',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFFFCC00),
              elevation: 0, // ???????????????
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('??????????????????'),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('????????????'),
                        ),
                        RaisedButton(
                          child: Text('??????????????????'),
                          onPressed: () {
                            context
                                .read(settingViewModelProvider(parameter))
                                .transitionToBlockList();
                          },
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('?????????????????????'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('????????????'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('?????????????????????'),
                        ),
                        Container(
                          height: 50,
                        ),
                        Text('???????????????'),
                        RaisedButton(
                          onPressed: () {
                            context
                                .read(settingViewModelProvider(parameter))
                                .transitionToTermsOfService();
                          },
                          child: Text('????????????'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            context
                                .read(settingViewModelProvider(parameter))
                                .transitionToPrivacyPolicy();
                          },
                          child: Text('??????????????????????????????'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            context
                                .read(settingViewModelProvider(parameter))
                                .transitionToLicense();
                          },
                          child: Text('???????????????'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('?????????????????????'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('????????????????????????'),
                        ),
                        Container(
                          height: 50,
                        ),
                        Text('???????????????'),
                        Text('??????????????? 1.0.0???20210228???'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
