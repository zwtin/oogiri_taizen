import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view_model.dart';
import 'package:oogiritaizen/ui/setting/setting_view_model.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

class SettingView extends HookWidget {
  final id = StringExtension.randomString(8);

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(settingViewModelProvider(id));

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
      provider: alertViewModelProvider(id),
      child: ProviderListener(
        onChange:
            (BuildContext context, NavigatorViewModel navigatorViewModel) {
          if (navigatorViewModel.nextWidget != null) {
            Navigator.of(context, rootNavigator: navigatorViewModel.fullScreen)
                .push(
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  return navigatorViewModel.nextWidget;
                },
                fullscreenDialog: navigatorViewModel.fullScreen,
              ),
            );
          } else if (navigatorViewModel.toRoot) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            Navigator.of(context).pop();
          }
        },
        provider: navigatorViewModelProvider(id),
        child: LoadingOverlay(
          isLoading: viewModel.isConnecting,
          color: Colors.grey,
          child: Scaffold(
            // ナビゲーションバー
            appBar: AppBar(
              title: const Text(
                '設定',
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('ユーザー情報'),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('閲覧履歴'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('ブロックリスト'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('アカウント連携'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('通知設定'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('アカウント削除'),
                        ),
                        Container(
                          height: 50,
                        ),
                        Text('アプリ情報'),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('利用規約'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('プライバシーポリシー'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('ライセンス'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('レビューを書く'),
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('要望・不具合報告'),
                        ),
                        Container(
                          height: 50,
                        ),
                        Text('大喜利大全'),
                        Text('バージョン 1.0.0（20210228）'),
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
