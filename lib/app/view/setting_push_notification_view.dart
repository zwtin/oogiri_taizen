import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/setting_push_notification_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';

class SettingPushNotificationView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('SettingPushNotificationView = $_key');
    final viewModel =
        useProvider(settingPushNotificationViewModelProvider(_key));

    return RouterWidget(
      key: _key,
      child: Scaffold(
        // ナビゲーションバー
        appBar: AppBar(
          title: const Text(
            'プッシュ通知',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFFFCC00),
          elevation: 0, // 影をなくす
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.white24,
              height: 1,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: const Color(0xFFFFCC00),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        height: 16,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text(
                                'イイね！された時',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 60,
                                height: 35,
                                child: FlutterSwitch(
                                  width: 60,
                                  height: 35,
                                  activeColor: Colors.yellow,
                                  inactiveColor: Colors.grey,
                                  value: viewModel.whenLiked,
                                  onToggle: (val) {
                                    context
                                        .read(
                                          settingPushNotificationViewModelProvider(
                                            _key,
                                          ),
                                        )
                                        .setWhenLiked(val);
                                  },
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 1,
                            ),
                            ListTile(
                              title: const Text(
                                'お気に入りされた時',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 60,
                                height: 35,
                                child: FlutterSwitch(
                                  width: 60,
                                  height: 35,
                                  activeColor: Colors.yellow,
                                  inactiveColor: Colors.grey,
                                  value: viewModel.whenFavored,
                                  onToggle: (val) {
                                    context
                                        .read(
                                          settingPushNotificationViewModelProvider(
                                            _key,
                                          ),
                                        )
                                        .setWhenFavored(val);
                                  },
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 1,
                            ),
                            ListTile(
                              title: const Text(
                                '運営からのおすすめ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 60,
                                height: 35,
                                child: FlutterSwitch(
                                  width: 60,
                                  height: 35,
                                  activeColor: Colors.yellow,
                                  inactiveColor: Colors.grey,
                                  value: viewModel.whenRecommended,
                                  onToggle: (val) {
                                    context
                                        .read(
                                          settingPushNotificationViewModelProvider(
                                            _key,
                                          ),
                                        )
                                        .setWhenRecommended(val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
