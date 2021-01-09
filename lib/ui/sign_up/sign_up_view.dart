import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiritaizen/data/provider/alert.dart';
import 'package:sweetalert/sweetalert.dart';

class SignUpView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      onChange: (BuildContext context, Alert alert) {
        if (alert.viewName == 'SignUpView') {
          SweetAlert.show(
            context,
            title: alert.title,
            subtitle: alert.subtitle,
            showCancelButton: alert.showCancelButton,
            onPress: alert.onPress,
            style: alert.style,
          );
        }
      },
      provider: alertProvider,
      child: LoadingOverlay(
        child: Scaffold(
          // ナビゲーションバー
          appBar: AppBar(
            title: const Text(
              '新規登録',
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 32,
                    ),
                    const Center(
                      child: Text(
                        ' ー メールアドレスで新規登録 ー ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                    SizedBox(
                      width: 300,
                      height: 44,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: TextField(
                          controller: useTextEditingController(),
                          decoration: InputDecoration(
                            //Focusしていないとき
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            //Focusしているとき
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            hintText: 'メールアドレス',
                            hintStyle: const TextStyle(color: Colors.grey),
                            contentPadding:
                                const EdgeInsets.fromLTRB(16, 0, 16, 0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                    Container(
                      width: 250,
                      height: 44,
                      child: SignInButton(
                        Buttons.Email,
                        text: 'Send Email To Confirm',
                        mini: false,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        InkWell(
                          child: const Text(
                            '利用規約',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {},
                        ),
                        const Text(
                          'に同意の上ご登録ください',
                          style: TextStyle(color: Colors.white),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Container(
                      height: 32,
                    ),
                    const Center(
                      child: Text(
                        ' ー SNSアカウントで新規登録 ー ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                    Container(
                      width: 250,
                      height: 44,
                      child: SignInButton(
                        Buttons.Google,
                        mini: false,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                    Container(
                      width: 250,
                      height: 44,
                      child: SignInButton(
                        Buttons.AppleDark,
                        mini: false,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                    Container(
                      width: 250,
                      height: 44,
                      child: SignInButton(
                        Buttons.Twitter,
                        mini: false,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                    Container(
                      width: 250,
                      height: 44,
                      child: SignInButton(
                        Buttons.Facebook,
                        mini: false,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        isLoading: false,
        color: Colors.grey,
      ),
    );
  }
}
