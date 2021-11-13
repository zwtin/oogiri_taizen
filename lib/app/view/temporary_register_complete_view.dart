import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';
import 'package:oogiri_taizen/app/view_model/temporary_register_complete_view_model.dart';

class TemporaryRegisterCompleteView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('TemporaryRegisterCompleteView = $_key');
    final viewModel =
        useProvider(temporaryRegisterCompleteViewModelProvider(_key));

    return WillPopScope(
      onWillPop: () async {
        context
            .read(temporaryRegisterCompleteViewModelProvider(_key))
            .popToRoot();
        return false;
      },
      child: RouterWidget(
        key: _key,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              '仮会員登録完了',
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
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                context
                    .read(temporaryRegisterCompleteViewModelProvider(_key))
                    .popToRoot();
              },
              icon: const Icon(Icons.close),
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 32,
                        ),
                        const Text(
                          '確認のメールをお送りしました！\nメールのURLからアプリを起動することで、本会員登録が完了します。',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Container(
                          height: 48,
                        ),
                        Row(
                          children: [
                            const Text(
                              'メールが届かない方は ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {},
                              child: const Text(
                                'こちら',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 32,
                        ),
                        Row(
                          children: [
                            const Text(
                              '本会員登録をスキップされる方は ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read(
                                        temporaryRegisterCompleteViewModelProvider(
                                            _key))
                                    .popToRoot();
                              },
                              child: const Text(
                                'こちら',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
