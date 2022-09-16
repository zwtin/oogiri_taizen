import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/no_login_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';

class NoLoginView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return RouterWidget(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'マイページ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFFFCC00),
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.white24,
              height: 1,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                showModalBottomSheet<int>(
                  context: context,
                  builder: (_context) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('設定'),
                            onTap: () async {
                              Navigator.of(_context).pop();
                              await context
                                  .read(noLoginViewModelProvider(_key))
                                  .transitionToSetting();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              color: const Color(0xFFFFCC00),
            ),
            SafeArea(
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFFFCC00), //ボタンの背景色
                            ),
                            onPressed: () {
                              context
                                  .read(noLoginViewModelProvider(_key))
                                  .transitionToSignIn();
                            },
                            child: const SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  'ログイン',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFFFFCC00), //ボタンの背景色
                            ),
                            onPressed: () {
                              context
                                  .read(noLoginViewModelProvider(_key))
                                  .transitionToSignUp();
                            },
                            child: const SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  '新規登録',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
